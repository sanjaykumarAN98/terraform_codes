resource "aws_db_parameter_group" "default" {
  name   = "rds-pg11"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main-hari"
  subnet_ids = [ aws_subnet.private_subnet.id, aws_subnet.private_subnet1.id ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-hari-security-group"
  description = "allow inbound access to the database"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = var.all
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = [ var.all_cidr]
}

  egress {
    protocol    = var.all
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = [ var.all_cidr ]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  identifier           = "wordpress"
  name                 = "wordpress"
  username             = "root"
  password             = "password"
  parameter_group_name = aws_db_parameter_group.default.id
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids = [ aws_security_group.elb.id ]
  publicly_accessible  = false
  skip_final_snapshot  = true
  multi_az             = false
}
