# -*- coding: utf-8 -*-
from PyTablePrinter.tableprinter import TablePrinter
import glob
import json
from operator import mul

"""
This is what we're generating:

Modality | Species | Dataset | Token | XYZT Resolution | Total Size | Reference |
"""

IGNORE_TOKENS = ['ara_test', 'ndio_demos', 'cv_kasthuri11_membrane_2014', 'mniatlas']

cache_path = "../../../Data/metadata/projinfo_cache"
public_token_files = glob.glob('{}/*.json'.format(cache_path))

# Trim the path from the left and .json from the right:
# public_tokens = [i[len(cache_path)+1:-5] for i in public_token_files]
# print public_tokens

token_info = []
sizes = []

for path in public_token_files:
    if path[len(cache_path)+1:-5] in IGNORE_TOKENS:
        continue
    with open(path, 'r') as infile:
        info = json.loads(infile.read())
        if 'image' not in info['channels'].keys():
            skip = True
            for channel, channel_info in info['channels'].iteritems():
                if channel_info['channel_type'] in ['oldchannel', 'timeseries']:
                    skip = False
            if skip:
                continue
        metadata = info['metadata']
        if 'reference' in metadata:
            if type(metadata['reference']) is not dict:
                link = metadata['reference']
                link = "[{}]({})".format(link[11:40] + "...", link)
            else:
                link = "<a href='{}'>{}</a>".format(
                    metadata['reference']['url'],
                    metadata['reference']['text']
                )
        else:
            link = ""

        dimensions = [
            info['dataset']['imagesize']['0'][0] - info['dataset']['offset']['0'][0],
            info['dataset']['imagesize']['0'][1] - info['dataset']['offset']['0'][1],
            info['dataset']['imagesize']['0'][2] - info['dataset']['offset']['0'][2],
        ]

        size = reduce(mul, dimensions, 1)
        size *= len(info['channels'])
        size *= (info['dataset']['timerange'][1] - info['dataset']['timerange'][0]) + 1
        insert = {
            "modality": metadata['type'] if 'type' in metadata else "",

            "species": metadata['species'] if 'species' in metadata else "",

            "dataset": "{}".format(info['dataset']['description']),

            "token": "`{}`".format(path[len(cache_path)+1:-5]),

            "resolution": (" &times; ".join((metadata['resolution'][:-3]).split(' ')) if 'resolution' in metadata else "") + ("; {}".format(metadata['frequency']) if 'frequency' in metadata else ""),

            "image_size": ' &times; '.join([str(d) for d in dimensions]),

            "channels": len(info['channels']),

            "time": (info['dataset']['timerange'][1] - info['dataset']['timerange'][0]) + 1,

            "reference": link,

            "size": size / (1000*1000*1000)
        }
        sizes.append(dimensions)
        token_info.append(insert)

# print sizes
# ss = [reduce(mul, d, 1) for d in sizes]
# print ss
# print sum(ss)

pt = TablePrinter(sorted(token_info, key=lambda k: k['dataset'].lower()),
                  col_order=['reference',
                             'dataset',
                             'modality',
                             'species',
                             ('resolution', "resolution (nm<sup>3</sup>; Hz)"),
                             ('image_size', "# voxels / volume"),
                             ('channels', '#channels'),
                             ('time', '#timesteps'),
                             ('size', "total # voxels (GV)")])
print pt.to_markdown()
