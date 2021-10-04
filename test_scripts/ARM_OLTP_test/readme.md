# Comparing different cpu types performance for Mysql (OLTP read-only test)


## Goal:

lorem ipsum

## Preparation:

#### step 1
install `terraform`

#### step 2
Then provide system variables for terraform to your AWS account
``` shell
export AWS_ACCESS_KEY_ID="%YOUR_AWS_ACCESS_KEY_ID%"
export AWS_SECRET_ACCESS_KEY="%YOUR_AWS_SECRET_ACCESS_KEY%"
export AWS_DEFAULT_REGION="%YOUR_AWS_DEFAULT_REGION%"
```
#### step 3
you need to change one record in `001_support.tf` file.
you need to change name of your future bucket for results:
```
resource "aws_s3_bucket" "sysbench_result" {
  bucket = "perconatempsysbenchresult"
  acl    = "private"

  tags = {
    Name = "percona bucket"
  }
}
```

change name in row `bucket = "perconatempsysbenchresult"` your bucket name.


## Run test

Test were written in `bash`. Infrastructure deployment was written using `terraform`.
there are 4 terraform files:

1. `001_support.tf` -- deploy AWS group, profile and S3 bucket
1. `020_PMM_server.tf` -- deploy AWS instance with PMM server
1. `021_MySql_x86.tf` -- deploy and test Intel and AMD CPU's
1. `022_MySql_ARM-tf` -- deploy and test Graviton CPU

to run the test it is required to run next command form the folder with test:

``` shell
cd ARM_OLTP_test
terraform init
terraform apply
```

# Destroying:
To destroy all deployed infrastracture you need:

#### step 1
go to you S3 bucket and delete all information from there
#### step 2

delete infrastructure with command (from the folder with test):

``` shell
cd ARM_OLTP_test
terraform destroy -auto-approve
```
