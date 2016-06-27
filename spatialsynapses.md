---
title: ND Paper 2016 - Case Study 2
layout: default
---

This page contains supplementary methods documenting case study 2, demonstrating scalable synapse detection and analysis in the NeuroData framework.

Starting point:  aligned image data in ndstore

Manual Annotation:  Completed by partners (could be uploaded with mana)

Train classifier
Deploy classifier
——

We then train a mask to remove obvious sources of non-uniformities, such as 
Upload Mask
Given result, download paint data and mask data with pad
If synapse is mostly in main region, count it.  Else delete
For all synapses left, then intersect centroid with mask
Pull out bin location (x1, y1, z1, x2, y2, z2, res, masked count, unmasked count), save as csv.  Save centroids as a second CSV.
At the end, join all the CSVs
naligned synapses




The spatial distribution of synapses is a fundamental property of neural tissue, and one that has been studied in smaller volumes in the past.  Large electron microscopy datasets now offer the possibility of investigating these questions at much larger scales, but require new tools and approaches for processing, analysis and assessment.  \textit{NeuroData} provides these tools and showcases a scalable approach and result in this case study.  The goal of this work is to enable similar research by other investigators, regardless of resources or prior experience with big data neuroscience.

Two recent studies have examined the spatial distribution of synapses in rat cortex \cite{merchan2014three,anton2014three} in smaller volumes.  Using a few thousand synapses, they fail to reject the hypothesis that synapses are distributed according to a random sequential adsorption model. This implied that their synapses were distributed almost randomly, with the only constraint being that they could not overlap. Their experimental design included multiple small volumes from different animals, which is often a wise experimental design choice, to mitigate batch effects \cite{leek2010tackling}. 

\input{figs/spdist.tex}

In contrast to the above small-volume studies, we used a single large volume of mouse visual cortex \cite{bock11}.  However, extracting the scientific information in large datasets requires adapting analysis  paradigms and algorithms to operate on (one) large volume rather than many small volumes.  This requires considering tradeoffs in terms of algorithm complexity and robustness, and incorporating strategies for dealing with block boundaries and distributed computing.
\textit{NeuroData} leverages tools such as \textit{ndio} and \textit{ndparse} to deploy a state-of-the-art synapse detection algorithm \cite{grayroncal2015} at scale, extract putative synapses and analyze the resulting  densities.

Briefly, we began with ground truthed data \cite{Kreshuk2014}, and divided it into non-overlapping training and validation sets.  We used this data to train, evaluate and deploy a VESICLE-RF classifier \cite{} using a small compute cluster running LONI Pipeline and Son of Grid Engine.  Finally, we deployed our chosen classifier on the full dataset, utilizing a combination of distributed computing tools such as LONI Pipeline, SGE, and slurm.  
We quantified our performance on the small validation dataset, and chose a relatively balanced detection operating point of 0.69 precision and 0.62 recall, as our analysis is totally automated.  To process the entire data volume ($\approx 20 TB$ at native resolution, downsampled to $\approx 5 TB$ at 8x8x45nm resolution), we chunked our data into cubes and then merged across cube boundary seams.  

We investigated the result using our scalable visualization tools and observed that our detector did not generalize well to Layer I data, near the pia.  To simplify our analysis and reduce bias, we created a mask of blank areas, our estimation of Layer I tissue, and other known areas of non-uniformity (e.g., blood vessels and soma).  

We then leveraged MARCC, a slurm-based compute cluster to estimate synapse densities across $\approx 100,000$  $5 \times 5 \times 5 \mu m$ non-overlapping blocks, while using the mask to eliminate areas with known-nonuniformities.  Our mean density estimate was XX, which is commensurate with the
expected density of synapses per volume reported in the literature.  Because of tissue contraction associated with this sample prep, and the elimination of no/low density regions, we expect that this estimate may be biased higher than other reported estimates higher than other estimates. \todo{Joshua - mouse seems to be about 1um popularly...i saw human estimates in the 1.6/um^3 range.  We can pull on this further.}  

Using \textit{ndio}, we generated additional slice samples to check for bias.  In most regions of the data, the classifier seemed to perform similarly in different areas; two areas with inaccurate results are regions containing artifacts (e.g., tissue folds), and slices with degraded contrast.  To partially mitigate this effect, we removed values greater than two standard deviations from the mean when testing for uniformity.  A selection of remaining high density and low density slices are shown in the figure and reproducibility code provides tools to generate additional samples.  

Finally, to check for nonuniformity, we ran a XX test, with the null hypothesis equal to uniform density.  We reject the null with a p-value less than XX.

This large-scale analysis represents a new frontier in neuroscience that is only possible using big data neuroscience techniques; indeed this is the largest known assessment of synaptic density to date.  This volume is much smaller than the cubic millimeter or whole brain (in light microscopy) datasets beginning to be generated and these tools can be used for many much larger analyses as they become available.

More detailed methods and links to view our reproducible analysis scripts and data are available online.


The result was $\approx 11$ million putative synapse detections --- shown in Figure~\ref{fig:spatialsyn}\textbf{h} shows a zoomed-out view of them. Figure~\ref{fig:parse}\textbf{i} illustrates an pipeline which completes these operations.

Our complementary experimental design decision enabled us to consider the
spatial distribution across a much larger volume, to prevent false results for the case in which parts of the volume exhibit a uniform synaptic distribution, and other parts do not.  Indeed, by looking at the histogram and heatmap density plots, it is immediately apparent that synapses are \textit{not} distributed uniformly in space and that there is a clear cluster pattern.  Each of the slices in the lower inset represent a 2D slice from a 125 cubic micron volume, approaching the size of the volumes used in the previous publications.  It would be very difficult to detect the anisotropic densities we observe in these smaller volumes given the nature of the non-uniformity.

\todo{do a better job linking in the figure}

\todo{may want to consider including some of this information.  Indeed, Figure
\ref{fig:spdist}\textbf{a} depicts the spatial distribution of synapses
detected in our volume.  The size of the dots corresponds to the
relative density of synapses.  It is immediately apparent that synapses
are \textit{not} distributed uniformly in space; rather, there is a
clear cluster pattern.  We are continuing to explore and analyze this
result to understand this clustering pattern.  The inset in the figure
shows a volume of 200 cubic microns, the size of the volumes used in the
previous publications.  It would be difficult indeed to detect
anisotropies from volumes of this size, given the nature of the
non-uniformity. Figure \ref{fig:spdist}\textbf{b} shows the 2D histograms projected onto the three canonical planes.  Even ignoring the edge effects, again, it is clear that the synapses are not distributed uniformly in space.}

%Annotations produced using the parse workflows described above result in knowledge, often in the form of a spatial point distribution (e.g., synapse centroids), graphs, or simply a collection of objects for which spatial statistics or properties (e.g., cell types, synaptic sizes) may be derived.
