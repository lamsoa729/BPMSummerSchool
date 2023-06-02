# Advanced Cluster Usage

| **Day 8  (Wednesday 6/14)** | **Advanced cluster usage**|
| --- | --- |
| 9:00AM | Getting programs running/environment management <br />  Speaker: **Robert/Chris**| 
| 10:00AM | Break |
| 10:10AM | Tutorial: Slurm <br /> Speaker: **Chris**|
| 10:30AM | Tutorial: Large batch runs with DisBatch <br /> Instructor: **Nick**|
| ~11:00AM | Break|
| ~11:10AM | Testing code for correctness and efficiency <br /> Speaker: **Vickram**|


# Running Programs and Environment Management
[conda cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf)


# SLURM Tutorial

How to run jobs efficiently on Flatiron's clusters

<h3 style="color:#ce3232">Christopher Edelmaier (CCB)</h3>


## Slurm

- How do you share a set of computational resources among cycle-hungry scientists?
  - With a job scheduler! Also known as a queue system
- Flatiron uses [Slurm](https://slurm.schedmd.com) to schedule jobs

<img width="30%" src="./assets/Slurm_logo.png"><\img>


## Slurm

- Wide adoption at universities and HPC centers. The skills you learn today will be highly transferable!
- Flatiron has two clusters (rusty & popeye), each with multiple kinds of nodes (refer to sciware or the [wiki](https://wiki.flatironinstitute.org/)
- Run slurm commands after you have logged into rusty (or popeye) (or if you have a Flatiron workstation)
- Access all slurm commands via module system (`module load slurm`)


## Slurm basics

Write a _batch file_ that specifies the resources you need.

<div class="two-column">  
  <div class="grid-item r-stack">
    <div class="fragment fade-out" data-fragment-index="0">

```bash
#!/bin/bash
# File: myjob.sbatch
# These comments are interpreted by Slurm as sbatch flags
#SBATCH --mem=1G          # Memory?
#SBATCH --time=02:00:00   # Time? (2 hours)
#SBATCH --ntasks=1        # Run one instance
#SBATCH --cpus-per-task=1 # Cores?
#SBATCH --partition=genx

# Load a compiler (GCC) and python
module load gcc python3

./myjob data1.hdf5
```

</div>
<div class="fragment fade-in" data-fragment-index="0">

- Submit the job to the queue with `sbatch myjob.sbatch`: \
  `Submitted batch job 1234567`
- Check the status with: `squeue --me` or `squeue -j 1234567`

  </div>
  </div>
  <div class="grid-item">
    <img src="assets/slurm/basics.svg" class="plain" width="600">
  </div>
</div>


## Where is my output?

- By default, anything printed to `stdout` or `stderr` ends up in `slurm-<jobid>.out` in your current directory
- Can set `#SBATCH -o outfile.log` `-e stderr.log`
- You can also run interactive jobs with `srun --pty ... bash`


## What about multiple things?

Let's say we have 10 files, each using 1 GB and 1 CPU

<div class="two-column">  
  <div class="grid-item">

```bash
#!/bin/bash
#SBATCH --mem=10G           # Request 10x the memory
#SBATCH --time=02:00:00     # Same time
#SBATCH --ntasks=1          # Run one instance (packed with 10 "tasks")
#SBATCH --cpus-per-task=10  # Request 10x the CPUs
#SBATCH --partition=genx

module load gcc python3

for filename in data{1..10}.hdf5; do
    ./myjob $filename &  # << the "&" runs the task in the background
done
wait  # << wait for all background tasks to complete
```
  </div>
  <div class="grid-item">
    <img src="assets/slurm/genxbg10.svg" class="plain" width="500"></img>
  </div>
</div>

This all still runs on a single node. But we have a whole cluster, let's talk about how to use multiple nodes!


## Slurm Tip \#1: Estimating Resource Requirements

- Jobs don't necessarily run in order; most run via "backfill"
  - Implication: specifying the smallest set of resources for your job will help it run **sooner**
  - But don't short yourself!
- Memory requirements can be hard to assess, especially if you're running someone else's code


## Slurm Tip \#1: Estimating Resource Requirements

1. Guess based on your knowledge of the program. Think about the sizes of big arrays and any files being read
2. Run a test job
3. Check the actual usage of the test job with:\
`seff -j <jobid>`
  - `Job Wall-clock time`: how long it took in "real world" time; corresponds to `#SBATCH -t`
  - `Memory Utilized`: maximum amount of memory used; corresponds to `#SBATCH --mem`


## Slurm Tip \#2: Choosing a Partition (CPUs)

- Use `-p gen` to submit small/test jobs, `-p ccX` for real jobs
  - `gen` has small limits and higher priority
- The center and general partitions (`ccX` and `gen`) always allocate whole nodes
  - **All cores, all memory**, reserved for you to make use of
- If your job doesn't use a whole node, you can use the `genx` partition (allows multiple jobs per node)
- Or run multiple things in parallel... (next talk)


## Try it yourself

- See packaged `mpi_omp_mockup` executable in the `slurm_examples` directory
- This is a compiled, toy program for rusty
- Reports MPI tasks and OpenMP threads


## Examples

- Each of the run\_slurm\_example[0-N].sh runs a separate configuration
- These are examples, but you should think about your own batch files/scripts
- Try it yourself!











# Large Batch Runs with disBatch


## High throughput computing: Need to run the same code many times

- Distinct input sets
- Monte Carlo
- Parameter search


## 100s or more runs benefit from bookkeeping

- Error returns
- Command details
- Run time
- Host


## Other considerations

- Often single or few-core runs
  - By the nature of the code
  - Generally more efficient to parallelize at the coarsest possible level  
    - To make good use of 100 cores, it is often faster and simpler to run 100 1-core tasks concurrently than it is to divide each individual task into 100 fine-grained parts each mapped to a core, and then run one task after another
- Single or few-core is inefficient with SLURM used in exclusive mode (job arrays don't help)
- Unnecessary load on SLURM
- Non-SLURM environment (e.g., a workstation)


## Examples

- Each of the ex[1-6]_setup.sh scripts sets up and executes a simple disBatch run
- These scripts are not themselves prototypes for further work
- Each creates a directory containing a `Task` file and a `disBatch_cmd` file. Use these as inspiration for your own runs


## Examples (Continued)

- Ex 1: Basics  
  <code><font size="-1">bash /path/to/BPMSummerSchoolNJC/Day8-AdvancedClusterUsage/disBatch_examples/ex1_setup.sh</font></code>  
- Ex 2: Running faster
- Ex 3: Missing redirections
- Ex 4: Job array analogue
- Ex 5: Resuming incomplete run
- Ex 6: Dynamically adding resources and monitoring


## Notes

- For *real* tasks, use core counts more closely aligned to the number actually available
- Tasks can be set up to use multiple cores each
- Using SLURM (at Flatiron):  
```
module load disBatch/beta
sbatch -n 100 -c 3 -p scc -t 1-0 disBatch Tasks
```  
   Tell SLURM what you want, SLURM will then tell disBatch (note in this example `Tasks` is the only argument for `disBatch`)  
   (Don't need `--use-address=localhost:0`)  
- Intranode MPI: add `unset SLURM_JOBID` to each task command sequence (or invocation wrapper)
- Get in the habit of checking `*_status.txt`
- For the adventurous: there is an API for embedded use (see `disBatch/exampleTaskFiles/dberTest.py`)



# Testing Code for Correctness and Efficiency




