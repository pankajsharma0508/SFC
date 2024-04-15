resource "aws_amplify_app" "sfc_amplify_app" {
  name                     = "sfc-amplify-app"
  repository               = "https://github.com/pankajsharma0508/sfc"
  access_token             = "..."
  enable_branch_auto_build = true

   custom_rule {
    source = "/<*>"
    status = "200"
    target = "/static/index.html<*>"
  }
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