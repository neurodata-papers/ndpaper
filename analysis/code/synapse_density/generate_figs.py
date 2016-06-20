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

SAVEDIR =       "synapse_density_figs"              # Directory to save to
GENERATE_FIGS = ['perspective', 'xy', 'yz', 'xz']   # Names of figs to generate.
                                                    # Remove items from array
                                                    # to prevent regen.

XLABEL =        "x"                                 # What to call the x axis
YLABEL =        "y"                                 # ...
ZLABEL =        "z"                                 # ...
THRESHOLD =     280                                 # Don't include values under


def csv_to_list(data):
    """
    Converts CSV text (from stdin) to a list of lists.
    """
    fieldnames = ['x', 'y', 'z', 'unmasked', 'synapses']
    reader = csv.reader(data)
    next(reader)

    return [[int(col) for col in row] for row in reader]


def _perspective(xs, ys, zs, rs):
    """
    generates the perspective graph
    """
    fig = plt.figure('perspective')
    ax = fig.add_subplot(111, projection='3d')

    ax.scatter(xs, ys, zs, c='b', s=rs, alpha=0.25, linewidth=0)

    ax.set_xticks((np.min(xs), np.max(xs)))
    ax.set_yticks((np.min(ys), np.max(ys)))
    ax.set_zticks((np.min(zs), np.max(zs)))

    ax.set_xlabel(XLABEL)
    ax.set_ylabel(YLABEL)
    ax.set_zlabel(ZLABEL)

    plt.savefig('{}/perspective.png'.format(SAVEDIR))


def _xy(xs, ys, zs, rs):
    _2d(xs, ys, rs, 'xy')

def _yz(xs, ys, zs, rs):
    _2d(ys, zs, rs, 'yz')

def _xz(xs, ys, zs, rs):
    _2d(xs, zs, rs, 'xz')

def _2d(xs, ys, rs, name):
    """
    Generates an arbitrary 2D projection. Specify which axis you want on the x,
    y axes, and give a radius list (if desired... otherwise, pass an integer).
    `name` is the `XY` pair to show as X and Y labels.
    """
    fig = plt.figure(name)
    ax = fig.add_subplot(111)

    ax.scatter(xs, ys, c='b', s=rs, alpha=0.25, linewidth=0)

    ax.set_xticks((np.min(xs), np.max(xs)))
    ax.set_yticks((np.min(ys), np.max(ys)))

    ax.set_xlabel(name[0])
    ax.set_ylabel(name[1])

    plt.savefig('{}/{}.png'.format(SAVEDIR, name))


figure_generators = {
    'perspective': _perspective,
    'xy': _xy,
    'yz': _yz,
    'xz': _xz
}

def main():
    rows = csv_to_list(sys.stdin.readlines())
    xs = []; ys = []; zs = []; rs = []

    # Generate the x, y, and z arrays
    for r in rows:
        if r[-1] > THRESHOLD:
            xs.append(r[0])
            ys.append(r[1])
            zs.append(r[2])
            rs.append(r[4]/8)

    # Try to make the directory...
    try:
        os.makedirs(SAVEDIR)
    except:
        pass # the directory already exists

    # Generate every figure that was requested in GENERATE_FIGS
    for figname in GENERATE_FIGS:
        figure_generators[figname](xs, ys, zs, rs)

main()
