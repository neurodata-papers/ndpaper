#!/usr/bin/env python


# !/cm/shared/apps/anaconda/2.7.10/bin/python

# !/usr/local/bin python
# compute all volumes (for convenience)

# 101650 blocks

block_size = (39, 39, 111)
pad = (16, 16, 45)
res = 5
nIter = 50

import numpy as np
import argparse 
from time import time
import ndio.utils.parallel as ndp
import ndio.remote.neurodata as neurodata
import csv

# get volume # to compute
parser = argparse.ArgumentParser()
parser.add_argument('idx',action='store',type=int,help='Increment on the base zslice')
result = parser.parse_args() 

start = time()

# we include any synapse that is more than 50% in the block
# we disregard synpases if any of their paint hits a mask in the smaller region

token_synapse = 'MP4merged'
channel_synapse = 'annotation'

token_mask = 'bock11_mask_v1'
channel_mask = 'mask'

nd = neurodata(chunk_threshold=2e9,suppress_warnings=True)

im_size = nd.get_image_size(token_synapse,res)
im_offset = nd.get_image_offset(token_synapse,res)

# custom chunking - only whole blocks

blocks = []
for i in range(im_offset[0]+pad[0], im_size[0]-pad[0]-block_size[0], block_size[0]):
    for j in range(im_offset[1]+pad[1], im_size[1]-pad[1]-block_size[1], block_size[1]):
        for k in range(im_offset[2]+pad[2], im_size[2]-pad[2]-block_size[2], block_size[2]):
            blocks.append([i,i+block_size[0],j,j+block_size[1],k,k+block_size[2]])

print len(blocks)
#blocks = ndp.block_compute(im_offset[0],im_size[0]-pad[0],
#                           im_offset[1],im_size[1]-pad[1],
#                           im_offset[2],im_size[2]-pad[2],
#                           origin=(im_offset[0]+pad[0],im_offset[1]+pad[1],
#                           im_offset[2]+pad[2]), block_size=block_size)
#TODO -1 values are an ndio bug
result.idx = result.idx * nIter


with open('mask_frag_'+str(result.idx).zfill(6)+'.csv', 'w') as csvfile:
	csvwriter = csv.writer(csvfile, delimiter=',')
	for i in range(0, nIter):
		if result.idx+i < len(blocks):
			b = blocks[result.idx+i]
			#b = blocks[10000]
			xstart = b[0]
			xstop = b[1]
			ystart = b[2]
			ystop = b[3]
			zstart = b[4]
			zstop =  b[5]

			#print result.idx+i
			# get anno data
			syn_big = nd.get_cutout(token_synapse, channel_synapse, xstart-pad[0],xstop+pad[0], ystart-pad[1],ystop+pad[1], zstart-pad[2],zstop+pad[2], resolution=5)

			# get mask data
			mask_big = nd.get_cutout(token_mask, channel_mask, xstart-pad[0],xstop+pad[0], ystart-pad[1],ystop+pad[1], zstart-pad[2],zstop+pad[2], resolution=5)

			# extract smaller core volumes
			syn_core = syn_big[pad[0]:np.shape(syn_big)[0]-pad[0], pad[1]:np.shape(syn_big)[1]-pad[1], pad[2]:np.shape(syn_big)[2]-pad[2]]
			mask_core = mask_big[pad[0]:np.shape(syn_big)[0]-pad[0], pad[1]:np.shape(syn_big)[1]-pad[1], pad[2]:np.shape(syn_big)[2]-pad[2]]

			# compute inner stats and outer stats
			uid_inner = np.unique(syn_core)
			uid_inner = uid_inner[uid_inner > 0]

			synList = set()

			for u in uid_inner:
				# find ratio
				obj_size_ratio = 1.0 * np.sum(np.ravel(syn_core)==u) / np.sum(np.ravel(syn_big)==u)

				if obj_size_ratio > 0.5: #synapse should count
					synList.add(u)		

			# intersect mask with synapses in chunk

			maskList = np.unique(syn_core[mask_core > 0])
			maskList = maskList[maskList > 0]
			maskList = set(maskList)

			synList = synList.difference(maskList)

			synList = np.asarray(list(synList))

			syn_count = len(synList)

			mask_core_pix = np.sum(np.ravel(mask_core>0))
			total_pix = len(np.ravel(mask_core))

			if syn_count == 0: 
				density = 0
			else:
				density = np.round(1.0 * syn_count / ((total_pix - mask_core_pix)*0.004*2**5 * 0.004*2**5 * 0.045),3)
			

			mask_fraction = np.round(1.0*mask_core_pix/total_pix,2)

			xc = np.round(1.0*(xstop+xstart)/2 * 2**4) # rounded - it's ok
			yc = np.round(1.0*(ystop+ystart)/2 * 2**4)
			zc = np.round(1.0*(zstop+zstart)/2)
			# x1, y1, z1, x2, y2, z2, res, mask size, non-mask size, number of synapses, density, xc, yc, zc, resc
			# Save file in CSV format for word, excel, etc.
			row = [xstart, ystart, zstart, xstop, ystop, zstop, res, total_pix, mask_core_pix, str(mask_fraction), syn_count, str(density), int(xc), int(yc), int(zc), 1]
			csvwriter.writerow(row)   

print 'Completed processing!'
print np.round(time()-start)