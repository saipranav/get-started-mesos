# Get Started Mesos

Code repository for [get started mesos gitbook](https://www.gitbook.com/book/rsaipranav92/get-started-mesos)

## How To Use This Project
Prerequiste : AWS account.

Clone this project. Edit public ssh key in `variables.tf` and run `terraform plan`. If everything looks good then run `terraform apply` to create 3 instances one mesos-master and 2 mesos-slaves.

The folders scripts will have scripts to install consul, zookeeper, mesos, marathon on both server and slaves/agents.

## Contributors
[Alan Scherger](https://github.com/flyinprogrammer)  
[Sai Pranav](https://github.com/saipranav)