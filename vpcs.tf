resource "aws_vpc" "default" {
    cidr_block             = "${var.cidr}"
    enable_dns_support     = true
    enable_dns_hostnames   = true
    instance_tenancy       = "default"

    tags {
        "Project" = "${var.project}"
    }
}
