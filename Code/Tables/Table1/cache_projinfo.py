import json
import ndio.remote.OCP as OCP
oo = OCP()

import ndio.remote.OCPMeta as ndlims
ndl = ndlims()

path = "../../../Data/metadata"

tokens = oo.get_public_tokens()
for t in tokens:
    with open('{}/projinfo_cache/{}.json'.format(path, t), 'w') as outfile:
        info = oo.get_token_info(t)
        info['metadata'] = ndl.get_metadata(t)
        json.dump(info, outfile)
