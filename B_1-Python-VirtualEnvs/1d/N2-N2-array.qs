#!/bin/bash -l
#
# DARWIN job script template, generated 2022-06-28T15:24:29-0400
#
# Sections of this script that can/should be edited are delimited by a
# [EDIT] tag.  All Slurm job options are denoted by a line that starts
# with "#SBATCH " followed by flags that would otherwise be passed on
# the command line.  Slurm job options can easily be disabled in a
# script by inserting a space in the prefix, e.g. "# SLURM " and
# reenabled by deleting that space.
#
# This is a batch job template for running the Gaussian quantum chemistry
# program suite.  It includes extensive helper scripting for processing
# your input file and communcating resource limits to the programs via the
# environment.
#
# Run 31 separate jobs, indexed [1,31]:
#SBATCH --array=1-31
#
# Do not alter the --nodes/--ntasks options!
#SBATCH --nodes=1
#SBATCH --ntasks=1
#
# [EDIT] Indicate the number of processor cores/threads to be used
#        by the job:
#
#SBATCH --cpus-per-task=2
#
# [EDIT] All jobs have memory limits imposed.  The default is 1 GB per
#        CPU allocated to the job.  The default can be overridden either
#        with a per-node value (--mem) or a per-CPU value (--mem-per-cpu)
#        with unitless values in MB and the suffixes K|M|G|T denoting
#        kibi, mebi, gibi, and tebibyte units.  Delete the space between
#        the "#" and the word SBATCH to enable one of them:
#
#SBATCH --mem=16G
# SBATCH --mem-per-cpu=1024M
#
# [EDIT] Each node in the cluster has local scratch disk of some sort
#        that is always mounted as /tmp.  Per-job temporary directories
#        are automatically created and destroyed by Slurm and can be
#        referenced via the $TMPDIR environment variable.  To ensure a
#        minimum amount of free space when your job is scheduled, the
#        --tmp option can be used; it has the same behavior unit-wise as
#        --mem and --mem-per-cpu.  Delete the space between the "#" and the
#        word SBATCH to enable:
#
# SBATCH --tmp=24G
#
# [EDIT] It can be helpful to provide a descriptive (terse) name for
#        the job (be sure to use quotes if there's whitespace in the
#        name):
#
#SBATCH --job-name=N2-N2
#
# [EDIT] The partition determines which nodes can be used and with what
#        maximum runtime limits, etc.  Partition limits can be displayed
#        with the "sinfo --summarize" command.
#
#        PLEASE NOTE:  On DARWIN every job is **required** to include the
#                      --partition flag in its submission!
#
#SBATCH --partition=standard
# [EDIT] Jobs that will run in one of the GPU partitions can request GPU
#        resources using ONE of the following flags:
#
#          --gpus=<count>
#              <count> GPUs total for the job, regardless of node count
#          --gpus-per-node=<count>
#              <count> GPUs are required on each node allocated to the job
#          --gpus-per-socket=<count>
#              <count> GPUs are required on each socket allocated to the
#              job
#          --gpus-per-task=<count>
#              <count> GPUs are required for each task in the job
#
#       PLEASE NOTE:  On DARWIN the --gres flag should NOT be used to
#                     request GPU resources.  The GPU type will be
#                     inferred from the partition to which the job is
#                     submitted if not specified.
#
# SBATCH --gpus=1
# SBATCH --gpus-per-task=1
# SBATCH --gpus-per-node=1
# SBATCH --gpus-per-socket=2
#
# [EDIT] The maximum runtime for the job; a single integer is interpreted
#        as a number of minutes, otherwise use the format
#
#          d-hh:mm:ss
#
#        Jobs default to the default runtime limit of the chosen partition
#        if this option is omitted.
#
#SBATCH --time=0-02:00:00
#
#        You can also provide a minimum acceptable runtime so the scheduler
#        may be able to run your job sooner.  If you do not provide a
#        value, it will be set to match the maximum runtime limit (discussed
#        above).
#
# SBATCH --time-min=0-01:00:00
#
# [EDIT] By default SLURM sends the job's stdout to the file "slurm-<jobid>.out"
#        and the job's stderr to the file "slurm-<jobid>.err" in the working
#        directory.  Override by deleting the space between the "#" and the
#        word SBATCH on the following lines; see the man page for sbatch for
#        special tokens that can be used in the filenames:
#
#SBATCH --output=logs/%A_%a.stdout
#SBATCH --error=logs/%A_%a.stderr
#
# [EDIT] Slurm can send emails to you when a job transitions through various
#        states: NONE, BEGIN, END, FAIL, REQUEUE, ALL, TIME_LIMIT,
#        TIME_LIMIT_50, TIME_LIMIT_80, TIME_LIMIT_90, ARRAY_TASKS.  One or more
#        of these flags (separated by commas) are permissible for the
#        --mail-type flag.  You MUST set your mail address using --mail-user
#        for messages to get off the cluster.
#
# SBATCH --mail-user='my_address@udel.edu'
# SBATCH --mail-type=END,FAIL,TIME_LIMIT_90
#
# [EDIT] By default we DO NOT want to send the job submission environment
#        to the compute node when the job runs.
#
#SBATCH --export=NONE
#
#
# [EDIT] If you're not interested in how the job environment gets setup,
#        uncomment the following.
#
#UD_QUIET_JOB_SETUP=YES

#
# [EDIT] Define a Bash function and set this variable to its
#        name if you want to have the function called when the
#        job terminates (time limit reached or job preempted).
#
#        PLEASE NOTE:  when using a signal-handling Bash
#        function, any long-running commands should be prefixed
#        with UD_EXEC, e.g.
#
#                 UD_EXEC mpirun vasp
#
#        If you do not use UD_EXEC, then the signals will not
#        get handled by the job shell!
#
#job_exit_handler() {
#  # Copy all our output files back to the original job directory:
#  cp * "$SLURM_SUBMIT_DIR"
#
#  # Don't call again on EXIT signal, please:
#  trap - EXIT
#  exit 0
#}
#export UD_JOB_EXIT_FN=job_exit_handler

#
# [EDIT] By default, the function defined above is registered
#        to respond to the SIGTERM signal that Slurm sends
#        when jobs reach their runtime limit or are
#        preempted.  You can override with your own list of
#        signals using this variable -- as in this example,
#        which registers for both SIGTERM and the EXIT
#        pseudo-signal that Bash sends when the script ends.
#        In effect, no matter whether the job is terminated
#        or completes, the UD_JOB_EXIT_FN will be called.
#
#export UD_JOB_EXIT_FN_SIGNALS="SIGTERM EXIT"

#
# [EDIT] Slurm only sets SLURM_MEM_PER_CPU when the --mem-per-cpu option is
#        used.  The job template system will attempt to set the missing
#        SLURM_MEM_PER_CPU when --mem was used and the job has a uniform number
#        of tasks per node (the only case when per-node memory yields a
#        uniform memory per task/cpu) if this variable is set:
#UD_PREFER_MEM_PER_CPU=YES
#
#        Uncomment the following variable if the job mandates a per-CPU memory
#        limit to be present or calculable when UD_PREFER_MEM_PER_CPU is set:
#UD_REQUIRE_MEM_PER_CPU=YES
#
# Add Gaussian to the environment:
#
vpkg_require gaussian/g16c01

#
# Gaussian input file:
#
GAUSSIAN_INPUT_FILE="N2-N2.com"

#
# Gaussian output file -- leave this blank and output will go to the
# job output file.
#
GAUSSIAN_OUTPUT_FILE="N2-N2.log"

#
# Normally the job setup helper script will fix-up or add %mem and
# %nproc directives in the input file to match with the job's
# allocated processor count and memory limit.  Uncomment this if
# you want the input file to be used unaltered.
#
#GAUSSIAN_SKIP_INPUT_FIXUP=YES

#
# When doing the input file fix-up, a certain amount of memory
# must be subtracted off the requested memory limit (e.g. --mem)
# to allow for the program itself, the stack, etc.  This defaults
# to 80 MB per thread, but can be altered with either of the
# following variables.  The values must be an integer in units of
# megabytes.
#
# This is a fixed size (not multiplied by thread count):
#GAUSSIAN_RESERVED_MEM=1024
#
# This is a size to be multiplied by thread count:
#GAUSSIAN_RESERVED_MEM_PER_CPU=125

#
# Should the fixed-up input file be dumped to the job output
# file?  The fixed-up file includes alterations to processor
# counts, etc.
#
GAUSSIAN_SHOW_FINAL_INPUT=YES

#
# [EDIT] By default, the function defined above is registered
#        to respond to the SIGTERM signal that Slurm sends
#        when jobs reach their runtime limit or are
#        preempted.  You can override with your own list of
#        signals using this variable -- as in this example,
#        which registers for both SIGTERM and the EXIT
#        pseudo-signal that Bash sends when the script ends.
#        In effect, no matter whether the job is terminated
#        or completes, the UD_JOB_EXIT_FN will be called.
#
#export UD_JOB_EXIT_FN_SIGNALS="SIGTERM EXIT"

#
# Enter the job array indexed directory:
#
if [ -n "$SLURM_ARRAY_TASK_ID" ]; then
    cd "jobs/$SLURM_ARRAY_TASK_ID"
fi

#
# Do standard Gaussian environment setup:
#
. /opt/shared/slurm/templates/libexec/gaussian.sh

#
# Execute Gaussian:
#
exec_gaussian
gaussian_rc=$?

#
# Do any cleanup, post-processing, etc.
#

#
# Done
#
exit $gaussian_rc

