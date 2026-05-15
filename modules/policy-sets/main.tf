
###############################################################################################
# Policy Sets
###############################################################################################

# This is creating a local variable of the list of project names provided in the request so that they can be used in the `tfe_project_policy_set` resource to create a resource for each project in the list
locals {
  policy_set_projects = flatten([
    for policy_set_name, policy_set in var.policy_sets : [
      for project_name in policy_set.project_names != null ? policy_set.project_names : [] : {
        policy_set_name = policy_set_name
        project_name    = project_name
      }
    ]
  ])
  excluded_workspaces = flatten([
    for policy_set_name, policy_set in var.policy_sets : [
      for workspace_name in policy_set.excluded_workspace_names != null ? policy_set.excluded_workspace_names : [] : {
        policy_set_name = policy_set_name
        workspace_name  = workspace_name
        global          = policy_set.global
      }
    ]
  ])
}

resource "tfe_policy_set" "policy_sets" {
  for_each = var.policy_sets

  name                = each.key
  description         = each.value.description
  global              = each.value.global
  organization        = each.value.organization
  kind                = each.value.kind
  agent_enabled       = each.value.agent_enabled
  policy_tool_version = each.value.policy_tool_version
  policies_path       = each.value.policies_path
  policy_ids          = each.value.policy_ids
  workspace_ids       = each.value.global == true ? values(data.tfe_workspace_ids.names[each.key].ids) : null

  vcs_repo {
    identifier                 = "github-org-name/terraform-sentinel-policies"
    branch                     = null
    ingress_submodules         = true
    github_app_installation_id = data.tfe_github_app_installation.github_app.id
  }
}

resource "tfe_project_policy_set" "policy_sets" {
  for_each = { for policy_set_project in local.policy_set_projects : "${policy_set_project.policy_set_name}-${policy_set_project.project_name}" => policy_set_project }

  policy_set_id = tfe_policy_set.policy_sets[each.value.policy_set_name].id
  project_id    = var.fixed_projects[each.value.project_name].id
}

resource "tfe_workspace_policy_set_exclusion" "policy_sets" {
  for_each = { for excluded_workspace in local.excluded_workspaces : "${excluded_workspace.policy_set_name}-${excluded_workspace.workspace_name}" => excluded_workspace }

  policy_set_id = tfe_policy_set.policy_sets[each.value.policy_set_name].id
  workspace_id  = data.tfe_workspace_ids.excluded_names[each.value.policy_set_name].ids[each.value.workspace_name]
}
