locals {
  cpu_ARM = setproduct(["m6g.large", "m6g.xlarge", "m6g.2xlarge", "m6g.4xlarge", "m6g.8xlarge", "m6g.12xlarge" , "m6g.16xlarge"], ["gp2"])
}


resource "aws_instance" "SysBench_MySQL_ARM" {
  ami = "ami-00d1ab6b335f217cf"


  for_each = {
    for unit in local.cpu_ARM : "${unit[0]}-${unit[1]}" => {
      instance = unit[0]
      storage  = unit[1]
    }
  }

  instance_type = each.value.instance

  root_block_device {
    volume_type = "gp2"
    volume_size = "200"
  }


  vpc_security_group_ids = [aws_security_group.percona_lab_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.sysbench_profile.name
  user_data_base64 = "${data.template_cloudinit_config.config_arm.rendered}"

  tags = {
    Name          = "SysBench_MySQL_ARM"
    DB            = "MYSQL"
    PMM           = "client"
    Type          = "ARM"
    Owner         = "Percona performance"
    Project       = "Terraform project"
  }

  depends_on = [
    aws_s3_bucket.sysbench_result,
    aws_iam_role.tf_s3_role,
    aws_iam_instance_profile.sysbench_profile,
    aws_instance.ubuntu_pmm_server
  ]
}



data "template_cloudinit_config" "config_arm" {
  gzip          = true
  base64_encode = true

  part {
  filename     = "000_basic.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_000_basic.rendered}"
  }

  part {
  filename     = "001_setup_R.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_001_setup_R.rendered}"
  }

  part {
  filename     = "010_apache_web_log.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_010_apache_web_log.rendered}"
  }

  part {
  filename     = "030_setup_mysql.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_030_setup_mysql.rendered}"
  }

  part {
  filename     = "031_configure_mysql.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_031_configure_mysql.rendered}"
  }

  part {
  filename     = "041_setup_pmm_arm.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_042_setup_pmm_arm.rendered}"
  }

  part {
  filename     = "080_run_oltp_read_only.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_060_run_oltp_test.rendered}"
  }

  part {
  filename     = "090_copy_result_to_s3.sh.tpl"
  content_type = "text/x-shellscript"
  content      = "${data.template_file.init_090_copy_result.rendered}"
  }

}

output "SysBench_MySQL_ARM"{
  value = {
    for key, value_instance in aws_instance.MySQLx86 : key => "\n id = ${value_instance.id} \n public_dns = ${value_instance.public_dns} \n ARN = ${value_instance.arn} \n public_ip = ${value_instance.public_ip} \n private_ip = ${value_instance.private_ip} \n"
    }
}
