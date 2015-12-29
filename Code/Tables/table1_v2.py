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
    data.append({
        "token": t,
        "modality": metadata['type'] if 'type' in metadata else "",
        "species": metadata['species'] if 'species' in metadata else "",
        "dataset": info['dataset']['description'],
        "resolution": metadata['resolution'] if 'resolution' in metadata else "",
        "image_size": ' x '.join([str(d) for d in info['dataset']['imagesize']['0']]),
        "reference": metadata['reference'] if 'reference' in metadata else ""
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

#
#
# out = ["| Dataset | Public Tokens |",
#        "|---------|---------------|"]
# for dataset, tokens in public_datasets_and_tokens.iteritems():
#     tokens_list = ['{}'.format(t) for t in tokens]
#     out.append("| **{}** | {} |".format(dataset, '; '.join(tokens_list)))
#
# print "\n".join(out)
