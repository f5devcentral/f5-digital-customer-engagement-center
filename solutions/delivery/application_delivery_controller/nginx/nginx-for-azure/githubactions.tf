############################# GitHub Actions ###########################

# GitHub workflow rendering
locals {
  nginxGithubActions = templatefile("${path.module}/templates/nginxGithubActions.yml", {
    sharedResourceGroup = azurerm_resource_group.shared.name
    nginxDeploymentName = azurerm_resource_group_template_deployment.nginx.name
  })
}

# GitHub workflow output file
resource "local_file" "nginxGithubActions" {
  content  = local.nginxGithubActions
  filename = "${path.module}/nginxGithubActions.yml"
}
