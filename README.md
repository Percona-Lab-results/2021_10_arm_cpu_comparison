# 2021_10_arm_cpu_comparison

#### overview
Performance comparison of AWS vCPU (Graviton, Intel and AMD)

main goal of this research was compare different CPU (AWS) and how they work with Mysql.

For that purposes we took: Graviton, Intel and AMD. we also took compute EC2 for four experiment from m5 m5a and m6g series.

results you could read on Percona blog.

in this project we use `Terraform` to run tests.
and `R` for result analysis.

#### Structure of this project
1. `test_script` -- folder with scripts we used for getting results. It contains `readme` with instruction how rerun our tests.

1. `raw_results` -- folder with raw log-files in zip.  Each zip contain multiple logs for each test scenario.
there are logs:
- sysbench from the tests - `*.log`
- timeseries from  PMM (monitoring) during the tests
- (additional) we also run benchmark test of EC2's so raw results also there.

1. `analysis` folder with `R` code and instruction how to convert raw log files to pretty bar-plots and simple html-page report. Most of plots are autogenerated.
