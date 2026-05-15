variable "tfe_hostname" {
  description = "Terraform enterprise hostname"
  type        = string
}

variable "tfe_organization" {
  description = "Terraform enterprise organization name"
  type        = string
}

## The value for name needs to be whatever is the GitHub username
## of the user that installed the GitHub App, if it was installed
## into a personal account, or the name of the GitHub organization that
## the app was installed into, if installed into an GitHub organization
variable "github_app_name" {
  description = "Name of the GitHub App"
  type        = string
}