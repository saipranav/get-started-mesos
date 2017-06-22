resource "aws_subnet" "default" {
    vpc_id                  = "${aws_vpc.default.id}"
    cidr_block              = "${var.cidr}"
    availability_zone       = "${var.region}${var.availability_zone}"
    map_public_ip_on_launch = true

    tags {
        "Project" = "${var.project}"
    }
}
