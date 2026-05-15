variable "tfe_hostname" {
  description = "Terraform enterprise hostname"
  type        = string
}

variable "tfe_organization" {
  description = "Terraform enterprise organization name"
  type        = string
}

variable "fixed_projects" {
  description = "The metadata of every project created through this module for use when associating a policy set to project(s)"
  type        = map(any)
}

## The value for name needs to be whatever is the GitHub username
## of the user that installed the GitHub App, if it was installed
## into a personal account, or the name of the GitHub organization that
## the app was installed into, if installed into an GitHub organization
variable "github_app_name" {
  description = "Name of the GitHub App"
  type        = string
}

variable "policy_sets" {
  description = "Map of policy sets to create"
  type = map(object({
    description              = optional(string)
    global                   = optional(string, null)
    organization             = optional(string)
    kind                     = optional(string, "sentinel")
    agent_enabled            = optional(string, "false")
    policy_tool_version      = optional(string, "latest")
    overridable              = optional(string)
    policies_path            = string
    policy_ids               = optional(set(string))
    project_names            = optional(list(string))
    workspace_names          = optional(list(string))
    excluded_workspace_names = optional(list(string))
  }))
  default = {}
}
