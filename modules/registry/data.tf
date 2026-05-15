## The value for name needs to be whatever is the GitHub username
## of the user that installed the GitHub App, if it was installed
## into a personal account, or the name of the GitHub organization that
## the app was installed into, if installed into an GitHub organization
data "tfe_github_app_installation" "github_app" {
  for_each = var.registry_modules
  name     = element(split("/", each.value.identifier), 0)
}