output "repo_url" {
  description = "ecr repository URL"
  value = aws_ecr_repository.my_app.repository_url
}
