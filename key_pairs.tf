resource "aws_key_pair" "default" {
  key_name = "${var.project}"
  public_key = "${var.ssh_public_key}"
}
