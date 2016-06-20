# copyright 2014 Open Connectome Project (http://openconnecto.me)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import json
import argparse
import requests
import os
import requests
import ndio.remote.ndingest as NI
SITE_HOST = "http://openconnecto.me"

def main():
  
  ni = NI.NDIngest(SITE_HOST)

  """
  Edit the below values, type and default information can be found on the ingesting page of the ndio docs page.
  """

  dataset_name='bloss16'        #(type=str, help='Name of Dataset')
  imagesize=(11500,7500,1429)           #(type=int[], help='Image size (X,Y,Z)')
  voxelres=(1.0,1.0,1.0)            #(type=float[], help='Voxel scale (X,Y,Z)')

  channel_name='channel0'        #(type=str, help='Name of Channel. Has to be unique in the same project. User Defined.')
  datatype='uint8'            #(type=str, help='Channel Datatype')
  channel_type='image'        #(type=enum, help='Type of channel - image, annotation, timeseries, probmap')
  data_url= 'http://s3.amazonaws.com/neurodata-public/kunal_data'           #(type=str, help='This url points to the root directory of the files. Dropbox is not an acceptable HTTP Server.')
  file_format='SLICE'         #(type=str, help='This is overal the file format type. For now we support only Slice stacks and CATMAID tiles.')
  file_type='tif'           #(type=str, help='This is the specific file format type (tiff, tif, png))

  project_name='bloss16'        #(type=str, help='Name of Project. Has to be unique in OCP. User Defined')
  token_name='bloss16'          #(type=str, default='', help='Token Name. User Defined')


  #Adds data set information
  ni.add_dataset(dataset_name, imagesize, voxelres)

  #Adds project information
  ni.add_project(project_name, token_name)

  #Adds a channel
  ni.add_channel(channel_name, datatype, channel_type, data_url, file_format, file_type)
  """
  If you wish to add additional channels to the object, simply call the
  add_channel function for as many channels as you have
  """

  #Adds metada
  ni.add_metadata('')

  """
  EDIT ABOVE HERE
  """

  #Uncomment this line if you wish to get a json file names file_name
  #ai.output_json("ocp.json")

  #Post the data
  # import pdb; pdb.set_trace()
  import time
  start = time.time()
  ni.post_data()
  print time.time()-start


if __name__ == "__main__":
  main()

