# !/cm/shared/apps/anaconda/2.7.10/bin/python

# !/usr/local/bin python
# compute all volumes (for convenience)

# 126876 blocks

block_size = (39, 39, 111)
pad = (16, 16, 45)
res = 5
nIter = 100

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
blocks = ndp.block_compute(im_offset[0],im_size[0]-pad[0],
                           im_offset[1],im_size[1]-pad[1],
                           im_offset[2],im_size[2]-pad[2],
                           origin=(im_offset[0]+pad[0],im_offset[1]+pad[1],
                           im_offset[2]+pad[2]), block_size=block_size)
#TODO -1 values are an ndio bug


with open('mask_frag_'+str(result.idx).zfill(6)+'.csv', 'w') as csvfile:
	csvwriter = csv.writer(csvfile, delimiter=',')
	for i in range(0, nIter):
		if result.idx+i <= len(blocks):
			b = blocks[result.idx+i]
			#b = blocks[10000]
			xstart = b[0][0] 
			xstop = b[0][1]
			ystart = b[1][0]
			ystop = b[1][1]
			zstart = b[2][0]
			zstop =  b[2][1]

			#print result.idx+i
			# get anno data
			try:
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

				# x1, y1, z1, x2, y2, z2, res, mask size, non-mask size, number of synapses, density
				# Save file in CSV format for word, excel, etc.
				row = [xstart, ystart, zstart, xstop, ystop, zstop, res, total_pix, mask_core_pix, str(mask_fraction), syn_count, str(density)]
				csvwriter.writerow(row)   
			except:
				print 'skipping invalid query'
#+'_x'+str(xstart)+'_y'+str(ystart)+'_z'+str(zstart)+'_r'+str(res)+		    
# delete edge synapses
# find centroids 

'''
print np.unique(syn_big)
print time()-start
print np.shape(syn_core)
print np.shape(mask_core)
print np.shape(syn_big)

print np.shape(blocks)
print xstart
print xstop
print ystart
print ystop
print zstart
print zstop
print res
'''
#bock11_subvol = nd.get_volume(token, channel, xstart, xstop, ystart, ystop, zstart, zstop
#, resolution=res)
#bock11_subvol = nd.get_volume(token, channel, xstart-pad[0], xstop+pad[0], ystart-pad[1], 
#ystop+pad[1], zstart-pad[2], zstop+pad[2], resolution=res)

# explicit, just in case
#temp = bock11_subvol.cutout
#temp = temp.astype('uint8')

#np.save('data_bock/run{}_bock11_subvol_{}_{}_{}_{}_{}_{}_{}.npy'.format(str(result.zinc).z
#fill(4),xstart,xstop,ystart,ystop,zstart,zstop,res), temp)
print 'Completed processing!'
print np.round(time()-start)
#print "Downloaded bock11 {} to {} (dims: {})".format(zmin, zmax, bock11_subvol.cutout.sha
#pe)
#print bock11_subvol.cutout.shape