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

Of particular interest (and scale) in neuroscience is high-resolution serial electron microscopy [@Denk04,etc.].  Such datasets can obtain terabytes (TB) a day; multiple such datasets already exist with ~100 TB (personal communication, Josh Morgan and Wei-Chung Allen Lee).  And with the new IARPA program dubbed MICrONS, a 4-10 petabyte (PB) dataset is planned to be collected in the next three years [@MICrONS].  Therefore, pipelines for analysis of massive high-dimensional volumes is of paramount importance.

## Gap

Unfortunately, existing computational ecosystems for data analysis are ill equipped to meet the challenges that arise with petascale data.  Further, if one group does manage to overcome those barriers, reproducing and extending their results  is typically impossible without collecting a new dataset; an unacceptably costly endeavor.



## Challenge

We consider six key components necessary for reproducible and extensible data analysis of any type at any scale: (1) hardware and software infrastructure upon which everything else runs,  (2) storage to enable efficient read and write access to the data, (3) exploratory tools to visualize the data in various ways, (4) pre-processing tools, to address geometric and chromatic aberrations, as well as co-register data to reference templates and atlases, (5) tools to parse the scene, semantically labeling each voxel, and finally (6) analysis tools to make sense of the parsed scene.  The classic data analysis pipeline with which most neuroscientists are familiar are inadequate in each of these steps.

Specifically, (1) standard laboratory workstations or even supercomputers cannot manage and manipulate many terabytes of data.  (2) Data cannot be read and written at scale even locally, much less remotely.  (3) Tools to visualize the data require the whole volume fit into RAM, which is not possible.  (4) Pre-processing tools require manual intervention, which becomes a significant bottleneck when there are literally millions of images.  (5) Manually parsing the scene is at least as arduous due to the fact that there are $\sim 10^{15}$ voxels. (6) Analyzing the resulting data derivatives, be they shapes or graphs or both, benefits from tools that natively operate on those data types, with statistical guarantees.


## Action

We have built the NeuroData computational ecosystem to address each of the six components mentioned above, therefore enabling reproducible and extensible neuroscience regardless of scale. All of our code is open source, and all of the data from which we discover scientific answers is open access.  Moreover, we have deployed a prototype system on our Web-accessible data cluster, which means that anybody can use any of the services we have built free of charge.

For each component of the system, our design was based on achieving sufficient scalability and automation to answer neuroanatomical questions.  Our resulting decisions inevitably led to trade-offs with respect to quality and capabilities.  The results, however, enabled us to answer certain questions much more efficiently and reproducibly than would have otherwise been possible. In particular, we reproduced a recent result regarding Peter's rule in somatosensory cortex [@Kasthuri15], and assessed, for the first time, the three-dimensional distribution of synapses in visual cortex from a different dataset [@Bock11]. 


## Resolution


Our infrastructure has therefore enabled  reproducing previous anatomical results on big data.  Moreover, we have produced quantitative answers to a fundamental neuroanatomical question with a sufficient sample size to leave little room for doubt about the veridicality of this summary statistic, at least on these data.  

Perhaps more important than the particular questions we have address in this work, is the capability we have enabled for the greater neuroscience community.  Because all of our infrastructure is open source, and deployed as Web-services, anybody---professional or citizen scientists---can use our services to learn about the brain.  Power users can modify our scripts to answer different questions, and developers could add additional capabilities for the community.  

# Results

All of the results presented herein are fundamentally reproducible; the data used to generate each table and figure panel can be reproduced by running a single Python script located in \url{http://paper.neurodata.io}.  Figures are made using R's ggplot2; each R script for generating the figures is also available from the above URL.  We have designed all of our supports to support three different types of data: images, annotations, and graphs.  Because the focus of this manuscript is on electron microscopy data, for which scant graphs are currently available, we focus the results on images and annotations.  However, see \url{http://neurodata.io/graphs} for more details about graph processing and analytics.


## Infrastructure


Our infrastructure is designed for fast reading and writing of terabytes of data.  Figure~\ref{fig:infra} shows the read and write speeds for our system, including writing both images and annotations.  Importantly NeuroData is designed to easily enable reading or writing of arbitrarily sized image tiles or cubes using a single URL or Python call.  For example, to download the image in Figure~\ref{fig:infra}(A), one can simply type \url{http://openconnecto.me/ocp/ca/kasthuri11/image/xy/0/9000,9500/12000,12500/50/} into any browser bar.  In contrast, if one desired to download an arbitrary image at an arbitrary zoom from data stored in files in a typical hierarchical folder system, one would have to write code to navigate to the right files, open them up, possibly downsample them, and stitch them back together.  Our infrastructure has built in support for all of that, significantly both speeding up and easing access to the data; Figure~\ref{fig:infra}(B) shows reading speed as a function of cube size, showing that reading speed is linear in the size of the data.    

Naively using the above described system, however, has the drawbacks just mentioned.  Therefore, we built \emph{TileCache} which serves as a content distribution network.  More specifically, TileCache fetches the data and parses it into the appropriate format (e.g., a set of png files), and also pre-fetches data that it expects you will want next.  The implication is that for 1028x1028 frames, TileCache can load 60 frames per second in a streaming fashion (Figure~\ref{fig:infra}(C)).  In other words, using TileCache, Neurodata enables video rate data streaming.  And because TileCache is a stand-alone service, it can easily be deployed locally, thereby further eliminating the data transfer speeds to get data local to the machine on which you want the data.


Writing to our spatial database would be more time consuming than simply uploading to a file server, because we re-write the data into a format that is efficient for reading.  We combat that by using a distributed database management system (such as Cassandra), that automatically distributes writing jobs across nodes.  We further speed up writing by compressing the data using Blosc, a multi-threaded library.  The result is that we can write data in compressed cubes in time linear with the data size (Figure~\ref{fig:infra}(D)).  The implications are the writing a terabyte of data on a single node take XXX hours.  

Writing annotations is a bit more complicated than simply writing images because we store annotations as objects with associated metadata, such as what type of object is it (e.g., synapse), who labeled it, what time, with what confidence, etc. Because each write object is therefore relatively small, and write speeds are determined largely by the number of files to write, we built NeuroBlaze, which caches writes in memory, only writing to disk a single large file joining all the small writes.  This enables us to write  annotations extremely efficiently (Figure~\ref{fig:infra}(E)).



## Databases


# Methods




# Captions

Table 1: List of all current (as of 12/31/15) Open Connectome Project Datasets.  Table 1A lists the *image* datasets and associated metadata.  Table 1B lists the volumetric *annotation* datasets, derived from a subset of the image datasets. Table 1C lists the *graph* datasets, derived from the annotation datasets.

Supplementary Figure 1: Infrastructure supporting all components of the OCP data analysis pipeline.  (A) The OCP Data Cluster. (B) Software running on the backend. (C) Software running on the frontend. 


Figure 1: Reading and writing to the database must be sufficiently fast to not be the primary bottleneck.  (A) OCP can write images faster than most current data collection speeds, meaning that data can be sent directly to OCP without requiring a large local storage buffer.  (B) Reading images from OCP using the tilecache is sufficiently fast to view the data at video rates. (C) Unlike many other scientific big data efforts, neuroscience requires many fast annotation writes.  NeuroBlaze writes annotation objects much more efficiently than our image writing by caching the writes in memory. (D) Although current EM derived neurographs are relatively small, and there are few, we expect that to change dramatically in the coming years. Therefore, we have built infrastructure to support downloading a large number of large graphs efficiently.

Figure 2: Exploring the data is a crucial first step, regardless of the data type, therefore, we have built data explorers for images, vectors, and graphs. (A) Image Explorer enables a Google Maps like interface to pan in X, Y, Z, and time, zoom, and overlay annotations, blend colors, and more.  (B) Graph Explorer facilitates computing various graph statistics, community detection, and plotting for arbitrary uploaded or generated graphs. (C) Vector Explorer allows the user to upload a csv file and do basic exploratory data analysis. 

Figure 3: NeuroData provides fully automatic terascale tools for both 2D & 3D chromatic adjustments, as well as nonlinear volume registration.  (A) DMG Chromatic pre-processing adjusts for aberrations induces by data collection and/or geometric stitching. (Bi) 2D image before DMG. (Bii) 2D image after DMG.  (Biii) XZ projection of data before GDF. (Biv) XZ projection after GDF.  (Bv) Time per image size (red) and number of slices (black) on a particular AMI.  (C) Volume registration 
