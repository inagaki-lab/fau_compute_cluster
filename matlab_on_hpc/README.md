Note that the HPC cluster runs on Linux,
so you have to change file paths containing backslashes to forward slashes or use the operating-system-agnostic [fullfile](https://www.mathworks.com/help/matlab/ref/fullfile.html)
function.

# Running MATLAB jobs using the web interface
The easiest way to run MATLAB on the HPC is to use the
[OnDemand web interface](https://ondemand.hpc.fau.edu/).
Select Interactive Apps -> MATLAB to launch MATLAB in the browser.

# Running MATLAB jobs using the command line
To run MATLAB on the HPC, you will need
(i) a MATLAB file and
(ii) a submit script in the same folder.
In this example, we will use the
[`some_function.m`](./some_function.m) file and the
[`submit_matlab.sh`](./submit_matlab.sh) script.

To submit the job, run
```bash
sbatch submit_matlab.sh "some_function(100)"
```
In this example, the `some_function` is called with the argument `100`.
Note that we have to use quotes around the MATLAB command,
because the parentheses are special characters in the shell.

To quickly submit multiple jobs, you can use a loop, such as
```bash
for arg in 100 200 300 400 500; do
  sbatch --job-name=argument_$arg "some_function($arg)"
done
```
Here, we derive the job name from the function argument with the 
`--job-name` flag, so we can easily see which output file belongs to which argument.

If you do not care about passing different arguments to the MATLAB function,
you can also hard-code the function plus arguments in the submit script,
such as 
`srun matlab -nodesktop -r "some_function(100)"`
and then call the submit script without any arguments:
```bash
sbatch submit_matlab.sh
```

# Available MATLAB versions
To find out which MATLAB versions are available, run
```bash
module spider matlab
```
Now set the version you want in the submit script, such as
```bash
# load module 
MATLAB=matlab-R2021a-gcc-9.2.0-mqxdbbu 
```