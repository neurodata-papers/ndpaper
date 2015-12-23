---
title: Open Connectome Project: Reverse Engineering the Brain One Synapse at a Time
author: everyone
---

# Abstract

Recent technical progress allows neuroexperimentalists to collect ever more detailed and informative anatomical and physiological data from brains of all sizes. With classical approaches it was feasible for neuroscientists to draw their results on paper, but modern experiments are amassing terabytes of data. These datasets span experimentally accessible spatiotemporal scales, ranging from nanometers to meters, and millisecond to monthly sampling rates. These large datasets create significant challenges for our community at every step of the data analysis pipeline: (i) store, (ii) explore, (iii) pre-process, (iv) parse, (v) analyze, all of which needs to happen in a petascale infrastructure.. 

NeuroData, the umbrella project including the Open Connectome Project, has been developed to lower the barrier to entry into big data neuroscience. We have designed and built a computational infrastructure to enable petascale neuroscience. This includes several reference workflows, including images-­to-­graphs from various experimental paradigms, ranging from serial electron microscopy to multimodal MRI. Moreover, anyone in the world with Internet access can now visualize, download, analyze, upload, or otherwise interact with all public datasets. We are in the process of scaling up the number of datasets, the range of experimental modalities, and the Web-services we enable. Work underway will provide pre-packaged cluster environments—1-click deployable on local or commercial cloud computing infrastructures—so that others can replicate and modify our services internally. All of our code and data are available online at neurodata.io, in accordance with open science standards. 


# Introduction

## Opportunity

Data from experimental neuroscientists can now be collected at astonishing rates across a wide variety of experimental paradigms.  In each of the different paradigms, the raw data are typically collections of relatively small (e.g., 4 megabyte, MB) two-dimensional (2D) images.  These 2D images can be montaged into large 2D planes, or larger 3D volumes, 3D+time movies, and/or 3D+color multispectral data.  These data have troves of information about brains lurking within, waiting to be extracted by the community.  

Of particular interest (and scale) in neuroscience is high-resolution serial electron microscopy [@Denk04,etc.].  Such datasets can obtain terabytes (TB) a day; multiple such datasets already exist with ~100 TB (personal communication, Josh Morgan and Wei-Chung Allen Lee).  And with the new IARPA program dubbed MICrONS, a 4-10 petabyte (PB) dataset is planned to be collected in the next three years.  Therefore, pipelines for analysis of massive 3D volumes is of paramount importance.

## Gap

Unfortunately, existing computational ecosystems for data analysis are ill equipped to meet the challenges that arise with petascale data.  We consider six key components necessary for data analysis of any type at any scale: (1) hardware and software infrastructure upon which everything else runs,  (2) storage to enable efficient read and write access to the data, (3) exploratory tools to visualize the data in various ways, (4) pre-processing tools, to address geometric and chromatic aberrations, as well as co-register data to reference templates and atlases, (5) tools to parse the scene, semantically labeling each voxel, and finally (6) analysis tools to make sense of the parsed scene.  The classic data analysis pipeline with which most neuroscientists are familiar are inadequate in each of these steps.

Specifically, (1) standard laboratory workstations or even supercomputers cannot manage and manipulate many terabytes of data.  (2) Data cannot be read and written at scale.  (3) Tools to visualize the data require the whole volume fit into RAM, which is not possible.  (4) Pre-processing tools require manual intervention, which becomes a significant bottleneck when there are literally millions of images.  (5) Manually parsing the scene is similarly intractable due to the fact that there are $\sim 10^{15}$ voxels. (6) Analyzing the resulting data derivatives, be they shapes or graphs or both, benefits from tools that natively operate on those data types, with statistical guarantees.


## Challenge




## Action

## Resolution



# Captions

Table 1: List of all current (as of 12/31/15) Open Connectome Project Datasets.  Table 1A lists the *image* datasets and associated metadata.  Table 1B lists the volumetric *annotation* datasets, derived from a subset of the image datasets. Table 1C lists the *graph* datasets, derived from the annotation datasets.

Supplementary Figure 1: Infrastructure supporting all components of the OCP data analysis pipeline.  (A) The OCP Data Cluster. (B) Software running on the backend. (C) Software running on the frontend. 


Figure 1: Reading and writing to the database must be sufficiently fast to not be the primary bottleneck.  (A) OCP can write images faster than most current data collection speeds, meaning that data can be sent directly to OCP without requiring a large local storage buffer.  (B) Reading images from OCP using the tilecache is sufficiently fast to view the data at video rates. (C) Unlike many other scientific big data efforts, neuroscience requires many fast annotation writes.  NeuroBlaze writes annotation objects much more efficiently than our image writing by caching the writes in memory. (D) Although current EM derived neurographs are relatively small, and there are few, we expect that to change dramatically in the coming years. Therefore, we have built infrastructure to support downloading a large number of large graphs efficiently.

Figure 2: Exploring the data is a crucial first step, regardless of the data type, therefore, we have built data explorers for images, vectors, and graphs. (A) Image Explorer enables a Google Maps like interface to pan in X, Y, Z, and time, zoom, and overlay annotations, blend colors, and more.  (B) Graph Explorer facilitates computing various graph statistics, community detection, and plotting for arbitrary uploaded or generated graphs. (C) Vector Explorer allows the user to upload a csv file and do basic exploratory data analysis. 

Figure 3: NeuroData provides fully automatic terascale tools for both 2D & 3D chromatic adjustments, as well as nonlinear volume registration.  (A) DMG Chromatic pre-processing adjusts for aberrations induces by data collection and/or geometric stitching. (Bi) 2D image before DMG. (Bii) 2D image after DMG.  (Biii) XZ projection of data before GDF. (Biv) XZ projection after GDF.  (Bv) Time per image size (red) and number of slices (black) on a particular AMI.  (C) Volume registration 
