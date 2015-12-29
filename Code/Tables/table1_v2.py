import PyTablePrinter

import ndio.remote.OCP as OCP
oo = OCP()

# This won't be needed after Jan 2016:
import ndio.remote.OCPMeta as ndlims
ndl = ndlims()

"""
This is what we're generating:

| Token | Modality | Species | Dataset | XYZT Resolution | Total Size | Reference |
|-------|----------|---------|---------|-----------------|------------|-----------|
...
"""

# public_datasets_and_tokens = oo.get_public_datasets_and_tokens()
tokens = oo.get_public_tokens()

data = []

for t in tokens:
    info = oo.get_token_info(t)
    metadata = ndl.get_metadata(t)
    if 'reference' in metadata:
        link = metadata['reference']
        link = "[{}]({})".format(link[11:40] + "...", link)
    else:
        link = ""
    data.append({
        "token": t,
        "modality": metadata['type'] if 'type' in metadata else "",
        "species": metadata['species'] if 'species' in metadata else "",
        "dataset": info['dataset']['description'],
        "resolution": metadata['resolution'] if 'resolution' in metadata else "",
        "image_size": ' x '.join([str(d) for d in info['dataset']['imagesize']['0']]),
        "reference": link
    })

col_order = [
    "token",
    "modality",
    "species",
    "dataset",
    "resolution",
    "image_size",
    "reference"
]

tp = PyTablePrinter.TablePrinter(data, col_order=col_order)
print tp.to_markdown()
