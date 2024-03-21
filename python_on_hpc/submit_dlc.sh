#!/bin/sh
#SBATCH --partition=shortq7
#SBATCH --gres=gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --output="%x.%j.out"
#SBATCH --error="%x.%j.err"

# output file as defined by slurm to clean DLC progress bars
OUT=${SLURM_JOB_NAME}.${SLURM_JOB_ID}.out

# SLURM submit script to run DLC with custom conda environment 
# not via modules

# print general slurm info
echo "HPC: Start time is $(date) $(date +%s)"
echo "HPC: SLURM_JOB_NAME is $SLURM_JOB_NAME"
echo "HPC: SLURM_SUBMIT_DIR is $SLURM_SUBMIT_DIR"
echo "HPC: SLURM_JOB_ID is $SLURM_JOB_ID"
echo "HPC: SLURM_NODELIST is $SLURM_NODELIST"
echo "HPC: SLURM_CPUS_PER_TASK is $SLURM_CPUS_PER_TASK"

CONDA_ENV=deeplabcut
PYTHON_SCRIPT=$1

# activate conda
eval "$(conda shell.bash hook)"
if conda activate $CONDA_ENV; then 
  echo "HPC: Activated conda environment $CONDA_ENV" 
else
  echo "HPC: ERROR! Failed to activate conda environment $CONDA_ENV" 1>&2
  exit 1
fi

# execute task 
echo "HPC: Running DLC..." 
echo 
if srun python3 "$PYTHON_SCRIPT" 2>&1; then
  echo 
  echo "HPC: srun finished gracefully" 
else
  echo 
  echo "HPC: srun finished with an error: exit code $?" 
fi

# clean up output file (progress bars look messy in plain text)
echo "HPC: Cleaning up DLC output file $OUT"
sed -i 's/.*\r//' $OUT

echo
echo "HPC: ...DLC finished"
echo "HPC: End time is $(date) $(date +%s)"
