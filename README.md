# About
This repository showcases example workflows using the
[high-performance computing (HPC) cluster](https://hpc.fau.edu) at
Florida Atlantic University (FAU) to scale up scientific computing tasks.
The workflows serve as a starting point for
Max Planck Florida Institute for Neuroscience (MPFI) researchers.
Please refer to the exhaustive
[Knowledge Base](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/?CategoryID=23056)
provided by the HPC team at FAU for many great detailed guides on specific topics.
You can also request help from the HPC team by submitting a ticket under
[Services > Research Computing/HPC > Research Application Assistance](https://helpdesk.fau.edu/TDClient/2061/Portal/Requests/ServiceDet?ID=5975).
Note that this requires an FAU login (see below).

# Example Workflows
Specific examples are provided that elaborate on the following topics:
- [Running MATLAB](./matlab_on_hpc/README.md)
    - submit jobs in a loop
    - utilize temporary scratch directories
- [Running Python](./python_on_hpc/README.md)
    - install custom packages
    - use GPU nodes
    - workflow for DeepLabCut
    - restart unfinished jobs


Please read below for general information on how to access the HPC cluster and submit jobs.

# Accessing the clusters
In order to get access to the HPC cluster, you need to have an FAU login.
Contact the MPFI IT team to request an account.
To log in, you will have to use the Duo Mobile App.

The [Open OnDemand web interface](https://ondemand.hpc.fau.edu/)
provides user-friendly and immediate access the HPC cluster.
You can
- upload/download files
- run interactive sessions for e.g.
    - Jupyter notebooks
    - MATLAB
    - virtual Linux desktop
- open a terminal on the login node

If you are using the terminal regularly, I highly recommend setting up
[SSH access](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=141467) and using [Zsh](https://ohmyz.sh/).
Note that you can also use [WSL](https://learn.microsoft.com/en-us/windows/wsl/about) when working on a Windows machine.

There are [multiple ways to transfer files](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=141367)
between your local machine and the HPC cluster
On Windows, I recommend mounting the HPC cluster as a network drive.

Some resources from the Knowledge Base to get started:
- [Computing Storage](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=145079)
- [Submitting Jobs using SLURM](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=141472)
- [Available queues](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=141348)
- [Available nodes](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=142380)
- [Which queue provides GPU's?](https://helpdesk.fau.edu/TDClient/2061/Portal/KB/ArticleDet?ID=146204)


# Job scheduler

## Submitting jobs
The HPC cluster uses the [SLURM](https://slurm.schedmd.com/) job scheduler.
Jobs are submitted using the `sbatch` command:
```bash
sbatch submit.sh
```
where `submit.sh` is a submit script that holds instructions for the job scheduler.
Example submit scripts for different tasks are provided in the subfolders of this repository.

The lines in the submit script starting with `#SBATCH` are
instructions for the job scheduler,
such as which queue and how many CPU cores to use and how to name the output and error files. 
```bash
#SBATCH --partition=shortq7 
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=24 
#SBATCH --output="%x.%j.out" 
#SBATCH --error="%x.%j.err"
```
This is equvivalent to adding the following flags to the `sbatch` command:
```bash
sbatch --partition=shortq7 --nodes=1 --cpus-per-task=24 --output="%x.%j.out" --error="%x.%j.err" submit.sh
```
The `--output` and `--error` flags specify the file names for the text output and errors created during the job, where `%x` is the job name and `%j` is the unique job ID assigned by the job scheduler.


## Monitoring jobs
You can monitor the status of your jobs using the `squeue` command:
```bash
squeue -u $USER
```

To cancel a job, use the `scancel` command:
```bash
scancel JOB_ID
```

## Show available resources
You can show the available queues and their time limits using the `sinfo` command:
```bash
sinfo
```
Note that by default you only have access to `shortq7`, `shortq7-gpu`, `mediumq7`, and `longq7`.

Another useful tool is the [`gnodes`](./gnodes) script from [slurm-utils](https://github.com/birc-aeh/slurm-utils/), which provides a graphical representation of all queues and their utilization.
Copy the file to the HPC and run from the same directory:
```bash
gnodes
```
