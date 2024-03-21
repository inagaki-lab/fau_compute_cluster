!#/bin/bash
# This script monitors the output of a job and restarts it if it was cancelled due to time limit
# Usage: restart_job.sh <sbatch arguments>

# Match string for cancelled job
MATCH="slurmstepd: .* STEP .* CANCELLED .* DUE TO TIME LIMIT .*"
# Directory to move old outputs to
OLD_OUTPUTS=old_outputs

while true; do
    for f in *.out; do
        if grep -e "$MATCH" *.out; then
            echo "RESTART SCRIPT: found cancelled job in $f. Moving to $OLD_OUTPUTS"
            mkdir -p $OLD_OUTPUTS
            mv $f $OLD_OUTPUTS
            mv ${f%.out}.err $OLD_OUTPUTS
            echo "RESTART SCRIPT: resubmitting job..."
            sbatch $@
        fi
    done
    # Check every minute
    sleep 60
done