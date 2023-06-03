#resource "aws_security_group" "sg" {
#  name        = "${var.name}-${var.env}-sg"
#  description = "${var.name}-${var.env}-sg"
#  vpc_id      = var.vpc_id
#
#  ingress {
#    description      = "APP"
#    from_port        = 8080
#    to_port          = 8080
#    protocol         = "tcp"
#    cidr_blocks      = [aws_vpc.main.cidr_block]
#
#  }
#
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#
#  tags = {
#    Name = "allow_tls"
#  }
#}
#
#resource "aws_launch_template" "template" {
#  name_prefix   = "${var.name}-${var.env}"
#  image_id      = data.aws_ami.ami.id
#  instance_type = var.instance_type
#}
#
#resource "aws_autoscaling_group" "bar" {
#  availability_zones = ["us-east-1a"]
#  desired_capacity   = 1
#  max_size           = 1
#  min_size           = 1
#
#  launch_template {
#    id      = aws_launch_template.foobar.id
#    version = "$Latest"
#  }
#}

resource "aws_instance" "test" {
  ami = "ami-08ee87f57b38db5af"
  instance_type = var.instance_type
  subnet_id = var.subnet_ids
}
