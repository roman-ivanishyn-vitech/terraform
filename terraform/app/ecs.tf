resource "aws_ecs_cluster" "mentorship_cluster" {
  name = "mentorship-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "1024"
  memory = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.container_definitions.rendered
}

data template_file "container_definitions" {
  template = file("../tmpl/container.json")
}

resource "aws_ecs_service" "mentorship_service" {
  name            = "mentorship-service"
  cluster         = aws_ecs_cluster.mentorship_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public_subnet[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "mentorship-app"
    container_port   = 80
  }

  desired_count = 1
}

resource "aws_lb" "mentorship_load_balancer" {
  name               = "mentorship-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_1.id]
}

resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ecs-target-group"
    Env  = var.environment
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.mentorship_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.mentorship_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:031767501261:certificate/dc531bc8-1a5b-4159-8bc2-af73d989a894"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "ecs_sg"
  description = "ecs_sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_sg"
    Env  = var.environment
  }
}

// Налаштувати CloudFront - який буде origin лоад балансер, а лоад балансер буде колати ECS
// Behavior *, alternative domain name, SSL certificate. Route53 update to CloudFront.
// Create one more app in the same cluster and create a new task definition for it,add new load balancer, and new behavior that will redirect to another load balancer.

