# B.1 Using Python Virtual Environments

## Generating data

The Gaussian input files are generated using the [job-templating-tool](https://github.com/jtfrey/job-templating-tool):

```
$ cd B_1-Python-VirtualEnvs/1d
$ job-templating-tool -vv --parameter r=0.3-8.0:+0.25 \
     --prefix=jobs/ --catalog=job-mapping \
     N2-N2.com
```

A directory for the Slurm stdout/stderr files is needed:

```
$ mkdir logs
```

The resulting array job `N2-N2-array.qs` is then submitted to Slurm from that working directory.

Once the job has completed all indices, the data can be extracted:

```
$ ./extract.sh 1 31 > tee data.csv
$ ls -l data.csv
total 355
-rw-r--r--  1 frey it_nss   330 Jan 28 17:24 data.csv
```

## Create the virtualenv

Using only the conda-forge channel:

```
$ pushd ..
$ mkdir potentialfit
$ conda create --prefix ./potentialfit/2025.01.27 \
      --override-channels --channel conda-forge \
      pip tensorflow keras'==3.8.0' matplotlib \
      scipy
$ popd
```

## Run the Python code

After activating the virtualenv, the two Python scripts can be run:

```
$ python3 neural-net.py
$ python3 functional-forms.py
```
