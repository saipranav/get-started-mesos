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
   default = "69.242.22.1/32,69.242.22.2/32"
}

##############################
## Instance Defaults
##----------------------------
variable "ami" {
    ## us-east-1 Ubuntu Server 16.04 LTS (HVM)
    ## https://cloud-images.ubuntu.com/locator/ec2/
    default = "ami-d15a75c7"
}

variable "instance_type" {
    default = "t2.large"
}

##############################
## Region Defaults
##----------------------------
variable "region" {
    default = "us-east-1"
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
    region = "${var.region}"
}
