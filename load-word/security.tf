resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port = var.port
    to_port = var.port
    protocol = var.all
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    from_port = var.port
    to_port = var.port
    protocol = var.all
    cidr_blocks = [var.all_cidr]
  }
}
