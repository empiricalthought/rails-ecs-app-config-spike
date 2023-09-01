
resource "aws_ecr_repository" "rails_app" {
  name = "rails-ecs-app-config-spike"
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.rails_app.name
  policy     = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only the last 5 untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": 5
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF
}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOF
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com
	    docker build -t "${aws_ecr_repository.rails_app.repository_url}:latest" -f Dockerfile .
        docker push ${aws_ecr_repository.rails_app.repository_url}:latest
    EOF
  }
  triggers = {
    "run_at" = timestamp()
  }
  depends_on = [
    aws_ecr_repository.rails_app
  ]
}
