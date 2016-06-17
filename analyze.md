---
title: ND Paper 2016 - Analyze
layout: default
---

## 2D-DMG


The data are from a pilot series of an adult female drosophila brain.  This series was collected to test end-to-end workflow, from sample preparation, to imaging, alignment and tracing before imaging the now-complete first complete female adult fly brain.   The imaged series contains ~863 sections, roughly ~12% of a complete brain.  The maximum extent of each section is 147456 x 81920, though only ~2/3 of the area contains biology.  Voxel resolution is roughly 4x4x40nm.

Our data are aligned using the Janelia Alignment Pipeline* [note: not sure of proper name] [https://github.com/khaledkhairy/EM_aligner].  We render the alignment into a format suitable for DMG (labels & pixels) using the renderer service [note: also not sure of proper name] [https://github.com/saalfeldlab/render].  Two features were added to do this.  One, the ability to use solid colors instead of image data (to generate the label files).  Two, a version which binarizes masks to guarantee that each pixel of rendered data came from a single source image.   We  use 8192x8192px PNG images as our standard format for tiling.

We run the latest version of DMG (4.5) on the Janelia cluster.  The current execution environment uses 4x 16-core 2.7Ghz Sandy bridge nodes [E5-2680] with 128Gb memory running Scientific Linux 6.3.  The cluster environment uses the Univa Grid Engine (formerly SGE).  Input & output are stored on a centralized GPFS-based filesystem.

We use a wrapper script to start the server process and four workers.  Each worker uses /dev/shm for scratch space as a nice compromise for having DMG run on the full sections without using scratch space or modifying the code to keep everything in memory.  [Note for Misha: -inCore does not work > ~4GB.]

Current run-time is ~20 minutes per section. [Note: I have actual run times for the entire FAFB series logged but have to find them.]

Once we have the output (stored as iGrid files with 8192x8192 PNG tiles), we retile it into 1024x1024 jpeg tiles for use with CATMAID.


## 3D-GDF

We have only run the 3D smoothing code on small slabs.  ~50 sections takes roughly ~1 day on a 20x3.2ghz workstation.  [I need to find my notes on this still.


## ndparse

