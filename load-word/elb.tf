resource "aws_elb" "word"{
  name               = "word-elb"
  #availability_zones = data.aws_availability_zones.all.names
  subnets = [aws_subnet.public_subnet.id, aws_subnet.public_subnet1.id ]
  security_groups = [aws_security_group.elb.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "HTTP:80/wp-admin/setup-config.php"
    interval            = 30
  }

  instances                   = [aws_instance.wordpress.id, aws_instance.wordpress.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "word-elb"
  }
}
