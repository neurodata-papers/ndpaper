### Reproduce the throughput benchmarks

You can reproduce our Read/Write throughput benchmarks using the following steps:

* Launch the AWS type i2.8xlarge.
* To install ndstore: Run the script [here](https://github.com/neurodata/ndstore/blob/microns/setup/neurodata_install.sh)
* Run the benchmark script [here](https://github.com/neurodata/ndstore/tree/microns/benchmarks/ndstore_install.sh). 
* The commands to run the read and write benchmarks are mentioned in the [README file](https://github.com/neurodata/ndstore/blob/microns/benchmarks/README.md). These commands will generate csv files for the respective benchmarks.
* Run the script [here](https://github.com/neurodata/ocp-journal-paper/blob/gh-pages/Code/Plots/ThroughputPlots.r). This script will generate the throughput graphs included in the paper.
