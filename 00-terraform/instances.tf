resource "aws_key_pair" "default" {
  key_name   = "${var.project}"
  public_key = "${var.ssh_public_key}"
}

resource "aws_instance" "mesos_master" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  subnet_id              = "${aws_subnet.default.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.default.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }

  tags {
    "Project" = "${var.project}"
  }
}

output "mesos_master_instance_public_ip" {
  value = "${aws_instance.mesos_master.public_ip}"
}

resource "aws_instance" "mesos_agent1" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  subnet_id              = "${aws_subnet.default.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.default.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }

  tags {
    "Project" = "${var.project}"
  }
}

output "mesos_agent1_instance_public_ip" {
  value = "${aws_instance.mesos_agent1.public_ip}"
}

resource "aws_instance" "mesos_agent2" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  subnet_id              = "${aws_subnet.default.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.default.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }

  tags {
    "Project" = "${var.project}"
  }
}

output "mesos_agent2_instance_public_ip" {
  value = "${aws_instance.mesos_agent2.public_ip}"
}
