# Advanced Cluster Usage

| **Day 8  (Wednesday 6/14)** | **Advanced cluster usage**|
| --- | --- |
| 9:00AM | Getting programs running/environment management <br />  Speaker: **Chris**| 
| 10:00AM | Break |
| 10:10AM | Tutorial: Slurm <br /> Speaker: **Chris**|
| 10:30AM | Tutorial: Large batch runs with DisBatch <br /> Instructor: **Nick**|
| ~11:00AM | Break|
| ~11:10AM | Testing code for correctness and efficiency <br /> Speaker: **Vikram**|



# Running Programs and Environment Management
<h3 style="color:rgb(25, 158, 72)">Christopher Edelmaier (CCB)</h3>

Thanks to the Sciware presentation from Dylan Simon (SCC)

[conda cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf)


## Overview

- Most software you'll use on the cluster (rusty, popeye, other) will either be:
  - In a *module* SCC provides
  - Downloaded/built/installed by you (usually using compiler/library modules)
- By default you only see the *base system* software (Rocky8 Linux), which is often rather old
- Follow along on your own machine after SSH-ing into rusty


## The Module System

- Cluster interactions through the **module** system
- `module avail` shows what modules are available
- Some of these are linked to specific versions of packages!


### `module list`

```text

Currently Loaded Modules:
  1) modules/2.1.1-20230405 (S)   2) slurm (S)   3) openblas/threaded-0.3.21 (S)

  Where:
   S:  Module is Sticky, requires --force to unload or purge
```

- Should give the 'default' modules loaded after logging in
- **Good practice**
  - I (*almost*) always purge the modules to start with to make sure I'm in a pristine state.
  - `module -q purge`
  - The `q` flag makes it quiet (not print to screen)


### `module avail`: Core (example)

```text
------------- Core --------------
gcc/7.5.0                (D)
gcc/10.2.0
gcc/11.2.0
openblas/0.3.15-threaded (S,L,D)
python/3.8.11            (D)
python/3.9.6
...
```
- `D`: default version (also used to build other packages)
- `L`: currently loaded
- `S`: sticky (see BLAS below)


### `module load`

- Load modules with `module load` or `ml NAME[/VERSION] ...`
   ```text
   > gcc -v
   ...
   gcc version 8.5.0 20210514 (Red Hat 8.5.0-18) (GCC)
   ```
- Load a 'default' version
   ```
   > module load gcc
   > module list
   Currently Loaded Modules:
  1) modules/2.1.1-20230405 (S)   2) slurm (S)   3) openblas/threaded-0.3.21 (S)   4) gcc/10.4.0
   > gcc -v
   ...
   gcc version 10.4.0 (Spack GCC)
   ```


### `module spider`

- Many packages have multiple versions
- Essentially implements a `search` function
- Can look up all versions/version information via `module spider`
- GCC for example
   ```text
   > module spider gcc
   -------
   gcc:
   -------
     Versions:
        gcc/7.5.0
        gcc/10.3.0
        gcc/10.4.0
        gcc/11.2.0
        gcc/11.3.0
        gcc/12.2.0
   ```
   ```text
   > module spider gcc/11.3.0
   ...
   'Information on GCC'
   ```


### Compilers/runtime environments

- Many times you need either a compiler (GCC) or a runtime environment (python)
- `module load NAME` loads these, along with any underlying modules needed
- For example `module load gcc/11` also loads an openblas module (more on this later!)
- Will also change the other modules you are 'allowed' to load (`module avail` after loading GCC)


### MPI

- MPI is a set of libraries and compilers that allow communication between different tasks (we'll get into this more later)
- Usually need a **special** MPI version of modules
   ```text
   > module load openmpi
   > module avail
   ...
   boost/mpi-1.80.0
   fftw/mpi-2.1.5
   ...
   ```
- Load them using the full name (with `-mpi` suffix)
- **Good practice**
  - I almost always load the full NAME/VERSION combination of modules so I know *exactly* what I am working with.
  - Double check with `module list`


### flexiBLAS

- Any module that needs BLAS (e.g. numpy) will use whichever BLAS module you have loaded:
  - `openblas`: `-threaded` (pthreads), `-openmp`, or `-single` (no threads)
  - `intel-oneapi-mkl`
- BLAS modules replace each other and won't get removed by default (`S`)


### Python

- `module load python` has a lot of packages built-in (check `pip list`)
- If you need something more, create a [virtual environment](https://docs.python.org/3/tutorial/venv.html):

```bash
module load python
mkdir -p ~/envs
python3 -m venv --system-site-packages ~/envs/myvenv
source ~/envs/myvenv
pip install ...
```

- Use `module load python` and `source activate` to get back into this environment


### Python example script

Good practice to load the modules you need in a script (tutorials on using the cluster resources)

```bash
#!/bin/bash
#SBATCH --partition=ccx
module -q purge
module load gcc
module load python
source ~/envs/myvenv/bin/activate

python3 myscript.py
```


### Other software

If you need something not in the base systems, modules, or pip:
- Download and install it yourself
  - Many packages provide install instructions
  - Load modules to find dependencies
- Ask! #sciware, #scicomp@, Sciware Office Hours


### Try to compile ourselves (if time)

Try to compile the toy `mpi_omp_mockup` program packaged with the SLURM tutorial

```bash
module -q purge
module load gcc/11.3.0
moduel load openmpi/4.0.7

mpicxx -fopenmp mpi_omp_mockup.cpp -o mpi_omp_mockup_test
```



# SLURM Tutorial
<h3 style="color:rgb(25, 158, 72)">Christopher Edelmaier (CCB)</h3>
How to run jobs efficiently on Flatiron's clusters


## Slurm

- How do you share a set of computational resources among cycle-hungry scientists?
  - With a job scheduler! Also known as a queue system
- Flatiron uses [Slurm](https://slurm.schedmd.com) to schedule jobs

<center><img width="30%" src="./assets/Slurm_logo.png"></center>


## Slurm

- Wide adoption at universities and HPC centers. The skills you learn today will be highly transferable!
- Flatiron has two clusters (rusty & popeye), each with multiple kinds of nodes (refer to sciware or the [wiki](https://wiki.flatironinstitute.org/))
- Run slurm commands after you have logged into rusty (or popeye) (or if you have a Flatiron workstation)
- Access all slurm commands via module system (`module load slurm`)
- How many of you have used Slurm before?
  - How many have just used a Slurm script handed to you by someone else?


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

# Make sure you have a clean module environment
module -q purge

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

module -q purge
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


## Summary of Slurm

- **Always** talk to your mentor about your particular program and its needs and wants!
- **No really always** make sure you understand what your program needs
  - Does it run better with more processes or threads?
  - Does this depend on the paramters controlling my program (*spoiler*: it does)?

<img width="20%" src="./assets/slurm_futurama.webp"></img>


## Epilogue

- I didn't say anything about GPUs, those are a special consideration for lots of this
- Anything else?



# Large Batch Runs with disBatch
### Nick Carriero, SCC


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




