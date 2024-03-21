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

# load module 
MODULE1=python3/3.7.7-jupyterhub

for m in $MODULE1; do
  if module load $m; then
    echo "HPC: Loaded module $m" 
  else
    echo "HPC: ERROR! Failed to load module $m" 1>&2
    exit 1
  fi
done

# execute task 
echo "HPC: Running Python..." 
echo 
if srun python3 "$1" 2>&1; then
  echo 
  echo "HPC: srun finished gracefully" 
else
  echo 
  echo "HPC: srun finished with an error: exit code $?" 
fi

echo "HPC: End time is $(date) $(date +%s)" 