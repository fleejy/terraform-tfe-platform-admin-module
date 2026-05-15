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

variable "fixed_projects" {
  description = "Map of projects to create"
  type = map(object({
    name = string
    #project_team_access = list(string)
    project_team_access = optional(map(object({
      state_versions = optional(string, "read-outputs")
      sentinel_mocks = optional(string, "none")
      runs           = optional(string, "read")
      variables      = optional(string, "read")
      create         = optional(bool, false)
      locking        = optional(bool, false)
      move           = optional(bool, false)
      delete         = optional(bool, false)
      run_tasks      = optional(bool, false)
    })), {})
    organization = optional(string)
    project_variable_set = map(object({
      global   = bool
      priority = bool
    }))
    variables = optional(map(object({
      key       = string
      value     = string
      category  = string
      hcl       = string
      sensitive = bool
    })), {})
  }))
  default = {}
}

variable "fixed_teams" {
  description = "Map of team names to create"
  type = map(object({
    name        = string
    visibility  = optional(string, "secret")
    sso_team_id = optional(string)
    organization_access = optional(map(object({
      read_workspaces         = optional(bool, false)
      read_projects           = optional(bool, false)
      manage_policies         = optional(bool, false)
      manage_policy_overrides = optional(bool, false)
      manage_workspaces       = optional(bool, false)
      manage_vcs_settings     = optional(bool, false)
      manage_providers        = optional(bool, false)
      manage_modules          = optional(bool, false)
      manage_run_tasks        = optional(bool, false)
      manage_projects         = optional(bool, false)
      manage_membership       = optional(bool, false)
    })), {})
  }))
  default = {}
}

variable "policy_sets" {
  description = "Map of policy sets to create"
  type = map(object({
    description              = optional(string)
    global                   = optional(string, null)
    organization             = optional(string)
    kind                     = optional(string, "sentinel")
    agent_enabled            = optional(string, "true")
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

variable "registry_modules" {
  description = "Map of modules to create in the Private Registry"
  type = map(object({
    identifier      = string
    name            = optional(string)
    module_provider = optional(string)
    registry_name   = optional(string)
    namespace       = optional(string)
    branch          = optional(string)
    tags            = optional(bool)
  }))
  default = {}
}