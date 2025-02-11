# B.2 Job Scheduling & Monitoring with Slurm

## Generating data

The Gaussian input files are generated using the [job-templating-tool](https://github.com/jtfrey/job-templating-tool):

```
$ cd B_2-Slurm-Usage/2d
$ job-templating-tool -vv --parameter D_N2=0.5-8.0:0.1 --parameter A_N2=0.0-90.0:5.0 \
        --prefix=jobs/ --catalog=job-mapping N2-N2.com
```

A directory for the Slurm stdout/stderr files is needed:

```
$ mkdir logs
```

The resulting array job `N2-N2-array.qs` is then submitted to Slurm from that working directory.
