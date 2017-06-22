output "mesos_master_instance_public_ip" {
    value = "${aws_instance.mesos_master.public_ip}"
}

output "mesos_agent1_instance_public_ip" {
    value = "${aws_instance.mesos_agent1.public_ip}"
}

output "mesos_agent2_instance_public_ip" {
    value = "${aws_instance.mesos_agent2.public_ip}"
}
