## The value for name needs to be whatever is the GitHub username
## of the user that installed the GitHub App, if it was installed
## into a personal account, or the name of the GitHub organization that
## the app was installed into, if installed into an GitHub organization
data "tfe_github_app_installation" "github_app" {
  # This is hard-coded to prevent people from importing sentinel policies that do not exist in the Github org that we want all policies to be centralized within, but can be modified in the future if desired
  name = var.github_app_name
}

data "tfe_workspace_ids" "names" {
  for_each = var.policy_sets

  names = each.value.workspace_names != null ? each.value.workspace_names : []
}

data "tfe_workspace_ids" "excluded_names" {
  for_each = var.policy_sets

  names = each.value.excluded_workspace_names != null ? each.value.excluded_workspace_names : []
}

## The check and data sources below are used to verify whether a workspace exclusion has been set through the UI; outside of the policy set yaml configs, if desired

# data "tfe_policy_set" "existing_policy_sets" {
#   for_each = var.policy_sets
#   name     = each.key
# }

# check "excluded_workspace_consistency" {

#   assert {
#     condition = alltrue([
#       for policy_set_name, policy_set in var.policy_sets : length(
#         setsubtract(
#           toset(data.tfe_policy_set.existing_policy_sets[policy_set_name].excluded_workspace_ids),
#           values(data.tfe_workspace_ids.excluded_names[policy_set_name].ids)
#         )
#       ) == 0
#     ])
#     error_message = join("\n\n", [
#       for policy_set_name, policy_set in var.policy_sets : format(
#         "Policy set '%s' has temporary workspace exclusions existing. Please remove these if they should not persist: %s",
#         policy_set_name,
#         join(", ", setsubtract(
#           toset(data.tfe_policy_set.existing_policy_sets[policy_set_name].excluded_workspace_ids),
#           values(data.tfe_workspace_ids.excluded_names[policy_set_name].ids)
#         ))
#       )
#       if length(setsubtract(
#         toset(data.tfe_policy_set.existing_policy_sets[policy_set_name].excluded_workspace_ids),
#         values(data.tfe_workspace_ids.excluded_names[policy_set_name].ids)
#       )) > 0
#     ])
#   }
# }
