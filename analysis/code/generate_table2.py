from PyTablePrinter import tableprinter

import ndio.remote.neurodata as neurodata
nd = neurodata()

public_datasets_and_tokens = nd.get_public_datasets_and_tokens()
public_datasets_and_tokens = [
    {'name': k, 'channels': cs} for k, cs in public_datasets_and_tokens.items()
]


def channel_summary(item):
    return len(item['channels'])


table_printer = tableprinter.TablePrinter(public_datasets_and_tokens, col_order=[
    # lookup    Col Title               # Function to generate data
    ('name',    'Name',                 None),
    (None,      'Number of Channels',   channel_summary)
])

print(table_printer.to_markdown())
