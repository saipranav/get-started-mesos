resource "aws_security_group" "default" {
    name        = "${var.project}-default"
    description = "Allows tcp, ping from any IP"
    vpc_id      = "${aws_vpc.default.id}"
    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "tcp"
        self            = "true"
        cidr_blocks     = ["${split(",", var.security_group_ips)}"]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        self            = "true"
        cidr_blocks     = ["${split(",", var.security_group_ips)}"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

#
#   This is how we just open one tcp port instead of opening all tcp ports which is not recommended
#   ingress {
#        from_port       = 22
#        to_port         = 22
#        protocol        = "tcp"
#        cidr_blocks     = [<cidr block contains your computer's public ip with /32 appended like a.b.c.d/32>]
#    }
#