resource "aws_db_instance" "postgres" {
  identifier              = "terraform-postgres"
  engine                  = "postgres"
  engine_version          = "14.17"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "Chitara"
  password                = "sometestpassword7643"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Name = "PostgresRDS"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow PostgreSQL access from EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "PostgreSQL from EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformRDS_SG"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "default-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "DefaultRDSSubnetGroup"
  }
}
