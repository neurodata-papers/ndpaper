## Bias Validation
*W. Gray Roncal*

We ran VESICLE-RF, a random forest classifier on a large volume of TEM data.  Based on our putative synapse detections, we determined that synapses in this volume (approximately Layer 2/3) were not uniformly distributed.

Because machine vision is inherently errorful (i.e., detectors have false positive and false negative rates), we took an additional step to assess detector bias.

More specifically, we divided the previously computed subcubes of 5x5x5 microns into high density and low density regions.  We selected blocks that had less than 10% masking, and then from the remainder, selected 200 blocks that had been identified as high density or low density (mean density + 2 standard deviations; mean density - 2 standard deviations) by the detector.  

Next, a manual annotation expert looked at these 200 blocks (100 for each category) and attempted to categorize them into high and low density groups, without knowledge of the computed density, mask, or putative synapse labels.

The annotator found agreement with the classifier XX% of the time, suggesting that the non-uniform result identified using the VESICLE-RF detections is supportable by the data, and that the classifier has sufficiently good performance.

To evaluate performance, labels should be saved in a csv file, with the first column corresponding to anonymized sample and the second to the label 0/1.  The following script should then be run, producing this expected output.

~~~
`python evaluate_bias.py plumbing_test_0817_v1.npz plumbing_test_0817_v1_will.csv`
***********************************************************************
Test Run: plumbing_test_0817_v1
Test Description: 8172016 10 samples, mean -1, -2, mean +1 + 2 std, 90% unmasked
Accuracy: 100.0%
Total Samples: 10
True Positives: 5
True Negatives: 5
False Positives: 0
False Negatives: 0
***********************************************************************
~~~
