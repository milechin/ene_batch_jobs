	
## Hidden Character Issue

1. Hidden characters.  To view hidden characters use the following command:
	```bash
	cat -e <filename>
	```
1. The `^M`, or return characters, from Windows machine are the problemn.
1. To correct this we can use the `dos2unix` command
	```bash
	dos2unix <filename>
	```
		
## Run job on buy-in queue only
1. To run only on GEO buy-in nodes add `-l buyin=TRUE` directive to the qsub options.

```bash
#!/bin/bash -l

#$ -P dvm-rcs
#$ -l buyin=TRUE

module load R
Rscript my_script.R

```

## Selecting Job length

To select job length we use the following directive: `-l h_rt=hh:mm:ss`

| Durations |	Directive        |
|---------- | ----------------   |
|12 hours	| -l h_rt 12:00:00   |
|24 hours	| -l h_rt 24:00:00   |
| 5 Days*	| -l h_rt 120:00:00  |
|10 Days	| -l h_rt 240:00:00  |
|30 Days	| -l hr_rt 720:00:00 |
		
*GEO queue limit - 5 Days


### How long did a previous job run for?
We can use the `qacct` command to accomplish this.

```bash
	qacct -j <job_number>
```

To list your jobs for the past five days:

```bash 
	qacct -d 5 -o <username> -j 
```


Below is an excerpt output for a single job.  To get the job length, look at the `ru_wallclock` value.
```console
qsub_time    Fri Jan 24 08:40:07 2025
start_time   Fri Jan 24 08:41:42 2025
end_time     Fri Jan 24 20:41:43 2025
granted_pe   omp16               
slots        16                  
failed       100 : assumedly after job
exit_status  137                 
ru_wallclock 43201    <-- LOOK AT WALLCLOCK (seconds)    
ru_utime     0.777        
ru_stime     0.248        
ru_maxrss    74624 
```


## Large memory jobs

For the SCC, we consider a job that is using more than 4 GB of memory as a large memory job. Refer to our Large Memory Job table to select appropriate resources:

[Large Memory Resource Selection Table](https://www.bu.edu/tech/support/research/system-usage/running-jobs/batch-script-examples/#MEMORY)

To determine how much memory is required by the job, we can use the `top` command method.

For interactive jobs, open a terminal and run the following command:

```console
top -u <username>
```

To monitor a batch job, first use `qstat` to determine what node (hostname) is running the job.

```console
qstat -u <username>
```

Then run the following command to ssh and run top on that login node.

```console
ssh -t <hostname> 'top -u <username>'
```

We can also use the `qacct -j <job_number>` command to get memory usage information.  This method doesn't always work for multi-core jobs.

Look for the `ru_maxrss` value.

```console
qsub_time    Tue Jan 28 10:15:16 2025
start_time   Tue Jan 28 10:18:45 2025
end_time     Tue Jan 28 10:27:26 2025
granted_pe   NONE                
slots        1                   
failed       0    
exit_status  0                   
ru_wallclock 521          
ru_utime     515.572      
ru_stime     1.584        
ru_maxrss    6332824   <-- LOOK AT RU_MAXRSS (kilobytes)
```

		
##  Selecting appropriate number of cores
### Process reaper

```console
The following batch job, running on SCC-PF6, has been terminated because it was using 10.4 processors but was allocated only 8. Please resubmit the job using an appropriate PE specification.
See https://www.bu.edu/tech/support/research/system-usage/running-jobs for more information.

job 2332828.1: owner: milechin pe: omp8 type: "Single node batch" slots: 8
            sge_gid: 1000767 job_pid: 1728528
            cputime: 103 min. rate: 1038.06% starttime: 01/27 13:55:03
COMMAND         STATE     PID    PPID TIME(min.) RATE(%) SIZE  RSS    START TIME
R                   R 1728649       1     6         67   4329 3214  01/27 13:55:04
R                   R 1728648       1     7         73   4329 2968  01/27 13:55:04
R                   R 1728647       1     7         72   4329 2364  01/27 13:55:04
R                   R 1728646       1     6         66   4329 2514  01/27 13:55:04
R                   R 1728645       1     6         67   4329 3049  01/27 13:55:04
R                   R 1728644       1     6         67   4329 3038  01/27 13:55:04
R                   R 1728643       1     6         66   4329 2751  01/27 13:55:04
R                   R 1728642       1     6         67   4329 2476  01/27 13:55:04
R                   R 1728641       1     7         73   4329 4124  01/27 13:55:04
R                   R 1728640       1     6         67   4329 2844  01/27 13:55:04
R                   R 1728639       1     7         73   4329 3772  01/27 13:55:04
R                   R 1728638       1     7         72   4329 3229  01/27 13:55:04
R                   R 1728637       1     7         72   4329 3165  01/27 13:55:04
R                   R 1728636       1     7         72   4329 2645  01/27 13:55:04
R                   R 1728635       1     6         67   4329 2831  01/27 13:55:04
R                   S 1728622 1728528     0          0    247   72  01/27 13:55:03
2332828             S 1728528 1728526     0          0      9    2  01/27 13:55:03

Please email help@scc.bu.edu for assistance.

```

Some programs will use all cores available by default.  If the programmer was nice they will provide you 
with an option/argument to limit how many cores will be used. 

### Job Environment Variables
We can take advantage of job environment variables to set the number of cores a program can use. 
A list of environment variables crated for each job are listed here:
https://www.bu.edu/tech/support/research/system-usage/running-jobs/submitting-jobs/#ENV

We can print the values of the environment values inside our bash script using the `echo` command:

```bash
#!/bin/bash -l

#$ -P dvm-rcs
#$ -l buyin=TRUE

echo JOB_ID: $JOB_ID
echo JOB_NAME: $JOB_NAME
echo NSLOTS: $NSLOTS
echo HOSTNAME: $HOSTNAME
echo SGE_TASK_ID: $SGE_TASK_ID
echo TMPDIR: $TMPDIR

module load R
Rscript my_script.R
```

The output log file will look something like this:

```console
JOB_ID: 2326133
JOB_NAME: env_variables.qsub
NSLOTS: 1
HOSTNAME: scc-ta4
SGE_TASK_ID: undefined
TMPDIR: /scratch/2326133.1.geo
[1] "Hello World!"
```

We can read in environment variables into R, Python, and Matlab scripts.

#### R example

```R
ncores <- as.integer(Sys.getenv("NSLOTS"))
```

[foreach example](https://rcs.bu.edu/examples/r/examples/parallel/foreach/foreach.R)

#### Python example
```python
import os
ncores = int(os.getenv('NSLOTS'))
```
[multiprocessing library example](https://rcs.bu.edu/examples/python/examples/parallel/multiprocessing/multiproc_pool.py)

#### Matlab Example
```matlab
ncores = str2num(getenv('NSLOTS'));

```
[parpool example](https://rcs.bu.edu/examples/matlab/ParallelComputingToolbox/parpool_bp.m)

### How can we tell if our program uses more than one core?

We can use `top` command to monitor the processes. 






		
## Array jobs

## Select architecture
