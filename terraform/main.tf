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
