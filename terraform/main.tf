#tworzenie repozytiorum obrazów
resource "aws_ecr_repository" "my_app" {
  name = "devops-inventory-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "devops-inventory-api"
    Managed = "Terraform"
  }
}
#tworzenie grupy logów z retencją 7 dni
resource "aws_cloudwatch_log_group" "my_app" {
  name = "/ecs/devops-inventory-api"
  retention_in_days = 7

  tags = {
    Project = "devops-inventory-api"
    Managed = "Terraform"
  }
}
#tworzenie roli IAM
resource "aws_iam_role" "ecs_task_execution_my_app" {
  name = "ecsTaskExecutionRole_my_app"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = "devops-inventory-api"
    Managed = "Terraform"
  }
}
#Przypięcie polityki IAM
resource "aws_iam_role_policy_attachment" "ecs_task_execution_my_app" {
  role = aws_iam_role.ecs_task_execution_my_app.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#tworzenie klastra ECS
resource "aws_ecs_cluster" "my_app" {
  name = "devops-inventory-api-cluster"

  tags = {
    Project = "devops-inventory-api"
    Managed = "Terraform"
  }
}
#Task Definition
resource "aws_ecs_task_definition" "my_app" {
  family = "devops-inventory-api"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_my_app.arn
 container_definitions = jsonencode([
  {
    name  = "devops-inventory-api"
    image = "${aws_ecr_repository.my_app.repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = 8000
        protocol = "tcp"
      }
    ]
   logConfiguration = {
    logDriver = "awslogs"
  options = {
    awslogs-group         = aws_cloudwatch_log_group.my_app.name
    awslogs-region        = "us-east-1"
    awslogs-stream-prefix = "ecs"
  }
}
  }
])
}
#Określanie domyślnego VPC i podsieci
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
#Tworzenie security grupy
resource "aws_security_group" "my_app" {
  name        = "devops-inventory-api-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {

    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "devops-inventory-api"
    Managed = "Terraform"
  }
}
#ECS Service
resource "aws_ecs_service" "my_app" {
  name  = "devops-inventory-api-service"
  cluster = aws_ecs_cluster.my_app.id
  task_definition = aws_ecs_task_definition.my_app.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = data.aws_subnets.default.ids
    security_groups = [
      aws_security_group.my_app.id
    ]
    assign_public_ip = true
  }
}

