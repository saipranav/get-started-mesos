##############################
## Project Defaults
##----------------------------
variable "project" {
  ## This is your project name.
  default = "get-started-mesos"
}

variable "ssh_public_key" {
  ## This is the ssh public key which will be used to login to your instance.
  default = "<paste your ssh public key which starts with ssh-rsa and ends with email address>"
}

variable "security_group_ips" {
  ## This should be your current Internet facing IP.
  ## This can be found by running the following command:
  ## curl https://api.ipify.org/
  ## And then add '/32' to the address it returns.
  type = "list"

  default = ["0.0.0.0/0"]
}

##############################
## Instance Defaults
##----------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

variable "instance_type" {
  default = "t2.large"
}

##############################
## Region Defaults
##----------------------------
variable "region" {
  default = "us-east-2"
}

variable "availability_zone" {
  default = "a"
}

##############################
## VPC Defaults
##----------------------------
variable "cidr" {
  default = "10.29.0.0/28"
}

##############################
## AWS Provider Defaults
##----------------------------
variable "access_key" {}

variable "secret_key" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
