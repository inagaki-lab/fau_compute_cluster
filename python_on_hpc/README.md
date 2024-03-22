# Running Python in the web browser
You can launch a Jupyter Notebook using the HPC cluster
in the browser via the
[OnDemand web interface](https://ondemand.hpc.fau.edu/)
(Interactive Apps -> Jupyter Notebook).

# Running Python using modules
If you need only very basic Python packages,
e.g. only `numpy` and `pandas`,
and do not care about the specific version,
you can use one of the Python installations available on the HPC system.
To submit a Python script, run
```bash
sbatch submit_python_basic.sh SCRIPT.py
```
where `SCRIPT.py` is the name of your Python script.

To select a different Python version, list the available versions with
```bash
module spider python
```
and then modify this line in the [`submit_python_basic.sh`](submit_python_basic.sh) script: `MODULE1=python3/3.7.7-jupyterhub`


# Creating and using conda environments
To have more flexibility and control over the Python packages,
you can install your own Python distribution using 
[Ananconda](https://www.anaconda.com/download/) and manage your own `conda` environments.

Follow
[these instructions](https://docs.anaconda.com/free/anaconda/install/linux/#installation)
to install Anaconda via the command line on Linux.
Log out and back in again to finalize the installation
and [create custom environments](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

To submit a Python script, run
```bash
sbatch submit_python_conda.sh ENV_NAME SCRIPT.py
```
where `ENV_NAME` is the name of your conda environment and `SCRIPT.py` is the name of your Python script.

# Use case: DeepLabCut
The following instruction will walk throught the installation of [DeepLabCut](https://github.com/DeepLabCut/DeepLabCut/blob/main/docs/installation.md) step-by-step.
Make sure that [Anaconda](https://docs.anaconda.com/free/anaconda/install/linux/#installation)
is properly installed for your user.


## Set up conda environment
Create and activate conda environment
```
conda create –name deeplabcut python=3.8
conda activate deeplabcut

```

Install `CUDA` and `cuDNN`, which is required for `tensorflow`.
Note that each `tensorflow` version requires specific `CUDA` and `cuDNN` versions (see [Tested build configurations](https://www.tensorflow.org/install/source#tested_build_configurations)). 
Steps 4-7 are adapted from the [tensorflow website](https://www.tensorflow.org/install/pip).

```
conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
```

Make libraries available in the conda environment
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

Install DLC via `pip`. Note that we are not using the GUI version on the HPC cluster.
```
pip install deeplabcut
```
Pin `tensorflow` and `numpy` versions.
Note that this step may not be necessary anymore.
```
pip install --upgrade tensorflow==2.9.2
pip install --upgrade numpy==1.22
```

Verify installation
```
python3 -c “import deeplabcut"
```

## Run DLC
To submit a DLC job, run
```bash
sbatch submit_dlc.sh dlc_analysis.py
```
where `dlc_analysis.py` is the name of your DLC script. Note that we are explicitly requesting GPU nodes in the submit script via 
```
#SBATCH --partition=shortq7-gpu
#SBATCH --gres=gpu
```

## Restart DLC
Due to the time limit on GPU queue (currently 6 h), DLC may not finish in time, especially during training.
However, you can restart the job from the last checkpoint, so make sure to turn on saving checkpoints in the `config.yaml`.

In order to automatically restart a job if it was terminated due to time limit,
use the [sbatch_restart.sh](./sbatch_restart.sh) script.
```bash
./sbatch_restart.sh dlc_analysis.py
```
This will search for the termination message in the output file once every 60 seconds. If found, it will copy the output and error file in a new directory
and then resubmit the job.
DLC will continue from the last checkpoint.

This script requires an active terminal session, so you may want to use `tmux` or `screen` to keep the script running in the background.
Furthermore, you may want to modify this script to cycle through multiple folders
to monitor multiple jobs at once.