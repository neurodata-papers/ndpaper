#!/bin/bash -l

#SBATCH
#SBATCH --job-name=NeuroDataTest
# time is either min or days-hh:min:sec
#SBATCH --time=10
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=6000
#SBATCH --mail-type=end
#SBATCH --mail-user=wgray13@jhu.edu
#echo "hello"

#http://dsp061.pha.jhu.edu/ocp/ca/bock11/blosc/1/30000,30100/30000,30100/3000,3002/

./get_matrix.py $SLURM_ARRAY_TASK_ID


