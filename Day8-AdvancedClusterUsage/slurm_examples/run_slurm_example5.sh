#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16
#SBATCH --constraint=rome,ib
#SBATCH --partition=ccb
#SBATCH --time=00:10:00
#SBATCH --job-name=mpi_omp_example5
#SBATCH --output=mpi_omp_example5.log

# Set up our environment for this SLURM submission
module -q purge
module -q load openmpi

# Helper functions to see what kind of system we are running on, and if we have GPUs that are accessible
lscpu
nvidia-smi

# Print some helpful information
export COMPUTED_CPUS_PER_TASK=$((${SLURM_CPUS_ON_NODE}/${SLURM_NTASKS_PER_NODE}))
echo "Slurm nodes:              ${SLURM_NNODES}"
echo "Slurm ntasks:             ${SLURM_NTASKS}"
echo "Slurm ntasks-per-node:    ${SLURM_NTASKS_PER_NODE}"
echo "Slurm cpus-per-task:      ${SLURM_CPUS_PER_TASK}"
echo "Computed CPUs per task:   ${COMPUTED_CPUS_PER_TASK}"

# Run the program
OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} mpirun -np ${SLURM_NTASKS} --report-bindings mpi_omp_mockup
