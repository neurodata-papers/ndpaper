#!usr/bin/env python

#manually created token and channel using the console

token = 'bock11_mask_v1'
channel = 'mask'
resolution = 5
offset = [0,0,2917]
mask_location = '/Users/graywr1/'

xbound = 4232 #can get from project info
ybound = 3744

from ndio.remote import neurodata
from glob import glob
import numpy as np
from PIL import Image


files = glob('/Users/graywr1/projects/ndpaper/composite_mask/*.png')
nd = neurodata()

c = 0

for f in files: #doing 1 slice at a time, which will be way slower
	print f
	im = Image.open(f)
	im = np.array(im).T
	im = im[0:xbound,0:ybound]
	im_post = np.zeros([np.shape(im)[0],np.shape(im)[1],1])
	im_post[:,:,0] = im #need to project into a 3d array for ndio 
	nd.post_cutout(token, channel, offset[0], offset[1], offset[2]+c, im_post, resolution=5)
	c += 1