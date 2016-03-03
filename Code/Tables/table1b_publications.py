#!/usr/bin/env python
"""
Written by Jordan Matelsky (j6k4m8)
March 3 2016

Run with:
    python Code/Tables/table1b_publications.py > Results/Tables/Table1/table1b.md
"""



from PyTablePrinter.tableprinter import TablePrinter
import ndio.remote.neurodata as nd
import sys
n = nd()

tokens = n.get_public_tokens()

refs = {}
for t in tokens:
    md = n.get_metadata(t)
    if 'code' in md['metadata']:
        sys.stderr.write('Failed to find metadata for token {}.\n'.format(t))
    else:
        r = md['metadata']
        if 'reference' in r:
            r = r['reference']
        else:
            continue
        ref = (r['url'], r['text'])
        if ref in refs:
            refs[ref]['count'] += 1
        else:
            refs[ref] = {
                'count': 1,
                'url': r['url'],
                'text': r['text']
            }

tp = TablePrinter(refs.values(), col_order=[
    (None, 'Reference', lambda r: "[{}]({})".format(r['text'], r['url'])),
    ('count', 'Count')
])

print tp.to_markdown()
