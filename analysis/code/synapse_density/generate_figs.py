#!/usr/bin/env python3

"""
@j6k4m8 for support.

# USAGE

Pipe the CSV file through standard-in. Figures are generated in the current
working directory.

    ./generate_figs.py < synapses.csv

"""

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

import os
import sys
import csv

TITLE =         "Figure 2"
TITLESIZE =     18
XLABEL =        "x"
YLABEL =        "y"
ZLABEL =        "z"
THRESHOLD =     280


def csv_to_list(data):
    fieldnames = ['x', 'y', 'z', 'unmasked', 'synapses']
    reader = csv.reader(data)
    next(reader)

    return [[int(col) for col in row] for row in reader]


def main():
    rows = csv_to_list(sys.stdin.readlines())

    try:
        os.makedirs('synapse_density_figs')
    except:
        pass # the directory already exists

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    xs = []; ys = []; zs = []; rs = []

    for r in rows:
        if r[-1] > THRESHOLD:
            xs.append(r[0])
            ys.append(r[1])
            zs.append(r[2])
            rs.append(r[4]/8)

    ax.scatter(xs, ys, zs, c='b', s=rs, alpha=0.25, linewidth=0)

    ax.set_xticks((np.min(xs), np.max(xs)))
    ax.set_yticks((np.min(ys), np.max(ys)))
    ax.set_zticks((np.min(zs), np.max(zs)))

    ax.set_xlabel(XLABEL)
    ax.set_ylabel(YLABEL)
    ax.set_zlabel(ZLABEL)

    plt.suptitle(TITLE, fontsize=TITLESIZE)
    plt.show()

main()
