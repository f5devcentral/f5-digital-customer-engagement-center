############################# GitHub Actions ###########################

# GitHub workflow rendering
locals {
  nginxGithubActions = templatefile("${path.module}/templates/nginxGithubActions.yml", {
    sharedResourceGroup  = azurerm_resource_group.shared.name
    appWestResourceGroup = azurerm_resource_group.appWest.name
    appEastResourceGroup = azurerm_resource_group.appEast.name
    vmssNameWest         = azurerm_linux_virtual_machine_scale_set.appWest.name
    vmssNameEast         = azurerm_linux_virtual_machine_scale_set.appEast.name
    nginxDeploymentName  = azurerm_resource_group_template_deployment.nginx.name
  })
}

# GitHub workflow output file
resource "local_file" "nginxGithubActions" {
  content  = local.nginxGithubActions
  filename = "${path.module}/nginxGithubActions.yml"
}
