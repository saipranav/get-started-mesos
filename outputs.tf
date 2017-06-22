output "mesos_master_instance_public_ip" {
    value = "${aws_instance.mesos_master.public_ip}"
}

output "mesos_slave1_instance_public_ip" {
    value = "${aws_instance.mesos_slave1.public_ip}"
}

output "mesos_slave2_instance_public_ip" {
    value = "${aws_instance.mesos_slave2.public_ip}"
}
