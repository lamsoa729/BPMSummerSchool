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




