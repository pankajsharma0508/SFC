resource "aws_iam_role" "calculator_amply_role" {
  name               = "calculator_amply_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "amplify.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "calculator_amply_role" {
  role       = aws_iam_role.calculator_amply_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
}

resource "aws_amplify_app" "sfc_amplify_app" {
  name                     = "sfc-amplify-app"
  repository               = "https://github.com/pankajsharma0508/sfc"
  #access_token             = "..."
  enable_branch_auto_build = true
  iam_service_role_arn = aws_iam_role.calculator_amply_role.arn
  
  #  custom_rule {
  #   source = "/<*>"
  #   status = "200"
  #   target = "/public/index.html<*>"
  # }
}

resource "aws_amplify_branch" "sfc_amplify_branch_main" {
  count       = 1
  app_id      = aws_amplify_app.sfc_amplify_app.id
  branch_name = "main"
  enable_auto_build = true
  stage       = "PRODUCTION"
  
  environment_variables = {
    Env = "prod"
  }
}