###############################################################################################
# Teams
###############################################################################################
resource "tfe_team" "fixed_teams" {
  for_each   = var.fixed_teams
  name       = each.value.name
  visibility = each.value.visibility

  dynamic "organization_access" {
    for_each = each.value.organization_access
    content {
      read_workspaces         = organization_access.value.read_workspaces
      read_projects           = organization_access.value.read_projects
      manage_policies         = organization_access.value.manage_policies
      manage_policy_overrides = var.tfe_organization == "test-company-dev" ? true : organization_access.value.manage_policy_overrides
      manage_workspaces       = organization_access.value.manage_workspaces
      manage_vcs_settings     = organization_access.value.manage_vcs_settings
      manage_providers        = organization_access.value.manage_providers
      manage_modules          = organization_access.value.manage_modules
      manage_run_tasks        = organization_access.value.manage_run_tasks
      manage_projects         = organization_access.value.manage_projects
      manage_membership       = organization_access.value.manage_membership
    }

  }
  organization = var.tfe_organization
}

###############################################################################################
# Projects
###############################################################################################
locals {
  # This is creating a local variable of the list of variables that were provided in the request so that they can be used in the `tfe_variable` resource.
  project_variables = flatten([
    for project, arguments in var.fixed_projects : [
      for variables, variable_arguments in arguments.variables : {
        project   = project
        variable  = variables
        arguments = variable_arguments
      }
    ]
  ])

  # This is creating a local variable of the list of teams that were provided in the request so that they can be used in the `tfe_team_project_access` resource.
  project_team_access = flatten([
    for project, arguments in var.fixed_projects : [
      for team_access, team_arguments in arguments.project_team_access : {
        project_name = project
        team_name    = team_access
        arguments    = team_arguments
      }
    ]
  ])

  #Leaving this here to show an example of how you could create a local variable for each org that uses this module to utilize with certain resources for ensuring those resources are only created specifically for that org/installation
  #This is creating a local variable that contains metadata for every project workspace created in test-company-prod to be used with the tfe_notification_configuration.slack_bot_notifications_prod resource
  # workspaces_prod = {
  #   for workspace, attributes in tfe_workspace.workspaces : workspace => attributes
  #   if attributes.organization == "test-company-prod"
  # }

  # #This is creating a local variable that contains metadata for every project workspace created in test-company-dev to be used with the tfe_notification_configuration.slack_bot_notifications_dev resource
  # workspaces_dev = {
  #   for workspace, attributes in tfe_workspace.workspaces : workspace => attributes
  #   if attributes.organization == "test-company-dev"
  # }
}

resource "tfe_project" "fixed_projects" {
  for_each     = var.fixed_projects
  name         = each.value.name
  organization = each.value.organization
}

resource "tfe_variable_set" "fixed_projects_variable_sets" {
  for_each     = var.fixed_projects
  name         = each.value.name
  organization = each.value.organization
  global       = each.value.project_variable_set.arguments.global
  priority     = each.value.project_variable_set.arguments.priority

}

resource "tfe_project_variable_set" "fixed_projects_variable_sets" {
  for_each        = var.fixed_projects
  variable_set_id = tfe_variable_set.fixed_projects_variable_sets[each.key].id
  project_id      = tfe_project.fixed_projects[each.key].id

}

resource "tfe_variable" "fixed_projects_variables" {
  for_each = { for project_variables in local.project_variables : "${project_variables.project}.${project_variables.variable}" => project_variables }

  key             = each.value.arguments["key"]
  value           = each.value.arguments["value"]
  category        = each.value.arguments["category"]
  hcl             = each.value.arguments["hcl"]
  sensitive       = each.value.arguments["sensitive"]
  variable_set_id = tfe_variable_set.fixed_projects_variable_sets[split(".", each.key)[0]].id
}


resource "tfe_team_project_access" "admin" {
  for_each = { for teams in local.project_team_access : "${teams.project_name}-${teams.team_name}" => teams }

  team_id    = tfe_team.fixed_teams[each.value.team_name].id
  project_id = tfe_project.fixed_projects[each.value.project_name].id
  access     = "custom"

  project_access {
    settings = "read"
    teams    = "none"
  }
  workspace_access {
    state_versions = each.value.arguments["state_versions"]
    sentinel_mocks = each.value.arguments["sentinel_mocks"]
    runs           = each.value.arguments["runs"]
    variables      = each.value.arguments["variables"]
    create         = each.value.arguments["create"]
    locking        = each.value.arguments["locking"]
    move           = each.value.arguments["move"]
    delete         = each.value.arguments["delete"]
    run_tasks      = each.value.arguments["run_tasks"]
  }
}

#Obtains the GitHub App ID from the github-org-name VCS connection to use for each workspace onboarding workspace created below
data "tfe_github_app_installation" "github_app_infrastructure-code" {
  name = var.github_app_name
}

#Creates a workspace that will manage the lifecycle of all of the workspaces that reside under the project
resource "tfe_workspace" "workspaces" {
  for_each                      = var.fixed_projects
  name                          = "workspace-onboarding-${each.value.name}"
  organization                  = var.tfe_organization
  queue_all_runs                = true
  tag_names                     = ["admin", "workspace-onboarding"]
  allow_destroy_plan            = false
  assessments_enabled           = true
  auto_apply                    = true
  auto_apply_run_trigger        = false
  description                   = "This workspace acts as the platform workspace for managing the lifecycle of any workspaces created for the configured project"
  file_triggers_enabled         = true
  force_delete                  = false
  global_remote_state           = false
  remote_state_consumer_ids     = null
  speculative_enabled           = true
  structured_run_output_enabled = true
  ssh_key_id                    = null
  terraform_version             = "latest"
  trigger_patterns              = ["environment/${var.tfe_organization}/projects/${each.value.name}/*", "environment/${var.tfe_organization}/projects/${each.value.name}/workspace-onboarding-module/*"]
  working_directory             = "environment/${var.tfe_organization}/projects/${each.value.name}/workspace-onboarding-module"

  vcs_repo {
    identifier                 = "${var.github_app_name}/terraform-tfe-platform-workspace-onboarding-deployment"
    github_app_installation_id = data.tfe_github_app_installation.github_app_infrastructure-code.id
  }

}

#Leaving these here to show an example of how you could use a local variable for each org that uses this module to utilize with certain resources for ensuring those resources are only created specifically for that org/installation
# resource "tfe_notification_configuration" "slack_bot_notifications_prod" {
#   for_each = local.workspaces_prod
#   name             = "slack-bot-notifications"
#   enabled          = true
#   destination_type = "generic"
#   triggers         = ["run:errored", "run:needs_attention", "run:completed", "assessment:drifted"]
#   url              = "https://<ADDRESS_HERE>"
#   workspace_id     = each.value.id
# }

# resource "tfe_notification_configuration" "slack_bot_notifications_dev" {
#   for_each = local.workspaces_dev
#   name             = "slack-bot-notifications"
#   enabled          = true
#   destination_type = "generic"
#   triggers         = ["run:errored", "run:needs_attention", "run:completed", "assessment:drifted"]
#   url              = "https://<ADDRESS_HERE>"
#   workspace_id     = each.value.id
# }
