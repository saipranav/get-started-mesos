resource "aws_instance" "mesos_master" {
    ami = "${var.ami}"
    subnet_id = "${aws_subnet.default.id}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.default.key_name}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    root_block_device {
      volume_type = "gp2"
      volume_size = "30"
      delete_on_termination = true
    }
    tags {
        "Project" = "${var.project}"
    }
}

resource "aws_instance" "mesos_agent1" {
    ami = "${var.ami}"
    subnet_id = "${aws_subnet.default.id}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.default.key_name}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    root_block_device {
      volume_type = "gp2"
      volume_size = "30"
      delete_on_termination = true
    }
    tags {
        "Project" = "${var.project}"
    }
}

resource "aws_instance" "mesos_agent2" {
    ami = "${var.ami}"
    subnet_id = "${aws_subnet.default.id}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.default.key_name}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    root_block_device {
      volume_type = "gp2"
      volume_size = "30"
      delete_on_termination = true
    }
    tags {
        "Project" = "${var.project}"
    }
}
