### Reproduce the throughput benchmarks

You can reproduce our Read/Write throughput benchmarks using the following steps:

* Launch the AWS type i2.8xlarge.
* To install ndstore: Run the script [here](https://github.com/neurodata/ndstore/blob/microns/setup/neurodata_install.sh)
* Run the benchmark script [here](https://github.com/neurodata/ndstore/tree/microns/benchmarks/ndstore_benchmarks.py). 
* The commands to run the read and write benchmarks are mentioned in the [README file](https://github.com/neurodata/ndstore/blob/microns/benchmarks/README.md). These commands will generate csv files for the respective benchmarks.
* Run the script [here](https://github.com/neurodata/ocp-journal-paper/blob/gh-pages/Code/Plots/ThroughputPlots.r). This script will generate the throughput graphs included in the paper.

### Reproduce the tilecache benchmarks

You can reproduce our Tilecache benchmarks using the following steps:

* Launch the AWS type i2.8xlarge.
* Create the file system using the commands [here](https://github.com/kunallillaney/raid-automator/        blob/master/README.md).
* Run the install script [here](https://github.com/neurodata/ndtilecache/blob/master/setup/                ndtilecache_install.sh) to install ndstore.
* Run the following script to run the benchmark code [here](https://github.com/neurodata/ndtilecache/blob/master/benchmarks/ndtilecache_benchmark.py). The commands are discussed in the [README](https://github.com/neurodata/ndtilecache/blob/master/benchmarks/README.md)
* Run the [here](TilecachePlots.r) script in the Plots folder.  This script will generate the tilecache graph in the paper.
