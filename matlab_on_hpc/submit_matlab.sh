#!/bin/sh 
#SBATCH --partition=shortq7 
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=24 
#SBATCH --output="%x.%j.out" 
#SBATCH --error="%x.%j.err"
 
# print general slurm info 
echo "HPC: Start time is $(date) $(date +%s)" 
echo "HPC: SLURM_JOB_NAME is $SLURM_JOB_NAME" 
echo "HPC: SLURM_SUBMIT_DIR is $SLURM_SUBMIT_DIR" 
echo "HPC: SLURM_JOB_ID is $SLURM_JOB_ID" 
echo "HPC: SLURM_NODELIST is $SLURM_NODELIST" 
echo "HPC: SLURM_CPUS_PER_TASK is $SLURM_CPUS_PER_TASK" 
 
# create temporary directory for $HOME 
# because default dir may be problematic with 
# multiple matlab instances 
SCRATCH="${HOME}/scratch_matlab" 
TMP="${SCRATCH}/job_$SLURM_JOB_ID" 
if mkdir -p "$SCRATCH" && mkdir "$TMP" ; then 
  echo "HPC: Created temporary directory $TMP" 
else 
  echo "HPC: ERROR! Could not create $TMP" 1>&2 
  exit 1 
fi 
HOME="$TMP" 
 
# load module 
MATLAB=matlab-R2021a-gcc-9.2.0-mqxdbbu 
if module load "$MATLAB"; then 
  echo "HPC: Loaded module $MATLAB" 
else 
  echo "HPC: ERROR! Failed to load module $MATLAB" 1>&2 
  exit 1 
fi 
 
# execute task 
echo "HPC: Running matlab..." 
echo 
if srun matlab -nodesktop -r "$1"; then  
  echo 
  echo "HPC: srun finished gracefully" 
else 
  echo 
  echo "HPC: srun finished with an error: exit code $?" 
fi 
 
if rm -rf "$TMP"; then 
  echo "HPC: Deleted $TMP" 
else 
  echo "HPC: Could not delete $TMP" 
fi 
 
echo "HPC: End time is $(date) $(date +%s)" 
