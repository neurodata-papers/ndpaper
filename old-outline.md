====== OCP Paper Outline ======


=== Fig1: Schematic illustrating the software stack and hardware configuration ===

  * spatial database
  * annotation database
  * api
  * parity
  * loni workflows
  * 3d viz
  * admin console
  * 3d color correction
  * hardware: datascope & HPC | EC2 | Allen | Harvard
 
=== Fig2: Tools we have back-ended ===

  * CATMAID
  * BigDataViewer
  * Thunder
  * iLastic
  * VAST
  * ITK-SNAP

=== Fig3: Use Cases ===

  * ingest, color correct, re-ingest, CATAMID
  * davi synapse detect & point process
  * ATomo synapse detect
  * i2g
  * cell counting from {CLARITY,2P,xray,partha}? 


=== Fig: performance on our cluster vs. amazon for various sub-routines ===

  * extract a dendrite using tight bounding box vs. not using it (time for us, cost for amazon), as a function of the volume of the bounding box
  * find all synapses per volume
  * i2g per volume


=== Tab: List of Datasets in OCP ===

[[:images]]

