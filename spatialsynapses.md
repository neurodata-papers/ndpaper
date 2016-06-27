---
title: ND Paper 2016 - Case Study 2
layout: default
---

This page contains supplementary methods documenting case study 2, demonstrating scalable synapse detection and analysis in the NeuroData framework.

Starting point:  aligned image data in ndstore
Ending point:  Automated spatial synapse density analysis, leveraging store, explore, and analyze NeuroData services.

## Directory contents:

- ```/figs```:  Used to assemble the final figure 6 for the manuscript.
- ```spatialsyn_figs.ipynb```:  Jupyter notebook containing reproducible analysis and figure generation.  (~10 minutes to run)
- ```put_mask*.py```:  Used to upload source mask data, created using ilastik
- ```merged_mask_v5_layer23only_DSP.csv```:  Synapse density source data using the layer 2/3 mask (used for paper)
- ```merged_mask_v6_layerall_DSP.csv```:  Alternative mask for generating valid synapse density regions
- ```get_matrix.py```:  python function used to reproducibly compute densities and metadata across all 100k windows
- ```test_bock_matrix.sh```:  driver to execute ```get_matrix.py``` on MARCC
- ```synapse_viz.ipynb```:  an interactive notebook to generate alternate figures and explore (under development)

### Supplementary Processing Description

This section provides a more extensive overview of the processing pipeline used to analyze synaptic density across the Bock data volume

#### Classifier development

To generate putative synapse detections, we used a version of VESICLE-RF, a robust, state of the art classifier that balances performance and scalability.  It is open-source and fully documented here:  docs.neurodata.io/vesicle

We leveraged a version of the manual truth labels created by Kreshuk 2014, et. al for training and validation.  We ensured that our validation set was non-overlapping with our training data.

Classifier training is efficient and was completed on a laptop.  Classifier deployment was originally run using LONI pipeline, a meta-scheduler we used on a Son of Grid Engine cluster with approximately 400 cores.  Processing took about 3 days, and used cuboids of data at scale 1 (8x8x45 nm) in an embarassingly parallel approach.  Subsequently, we leveraged back-end ndstore tools to merge across the cuboid boundaries.  A RESTful endpoint also exists to complete this step client side.  This ultimately resulted in about 11.6 million putative synapses, at an estimated precision of 0.69 and recall of 0.62.

### Synapse Density Estimates


We investigated the result using our scalable visualization tools and observed that our detector did not generalize well to Layer I data, near the pia.  To simplify our analysis and reduce bias, we created a mask (using Ilastik) of blank areas, our estimation of Layer I tissue, and other known areas of non-uniformity (e.g., blood vessels and soma).  We uploaded this mask to NeuroData for inspection and provenance.  We then developed a sampling strategy to compute density estimates.  We divided the data into non-overlapping 5x5x5 um blocks (with a surrounding padded region).  We counted synapses in the block that (i) had more than 50% of their labeled voxels inside the core cuboid, and (ii) were not touching a masked voxel.  To compute density, we divided this by the number of microns in the non-masked region of that block (125 um^3 for regions with no masking).  We saved this information to a csv file for each block and then merged all of the 100,000 csv files after processing.  We computed this data using MARCC (marcc.jhu.edu), a large enterprise, slurm-based cluster.

#### Analysis

Please see our Jupyter notebook for reproducible analysis steps to test for synaptic density uniformity (```spatialsyn_figs.ipynb```).

#### Will you look at that?
All of our data is viewable using NeuroData resources and can be examined, reproduced and extended.

- **ndviz**: An annotation project exists at: ```viz.neurodata.io/MP4merged/```.  Traceability between the csv file and this viz project is straightforward using the provided metadata. 
- **ndio**:  a selection of center slices from high, medium and low density regions were saved for convenience:  ```openconnecto.me/data/public/ndpaper/```
- **jupyter**: our jupyter notebook provides an interactive exploration environment at the bottom of the notebook to examine a block of data and assess classifier performance and bias.
