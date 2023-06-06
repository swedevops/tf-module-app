resource "aws_security_group" "sg" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "APP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.allow_app_cidr

  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr
  }

  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}

resource "aws_launch_template" "template" {
  name_prefix   = "${var.name}-${var.env}-lt"
  image_id      = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
}


resource "aws_autoscaling_group" "asg" {
  name               = "${var.name}-${var.env}-asg"
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [ aws_lb_target_group.main.arn ]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = local.asg_tags
    content {
      key = tag.key
      propagate_at_launch = true
      value = tag.value
    }
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.name}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = merge(var.tags, { Name = "${var.name}-${var.env}-tg" })
}







