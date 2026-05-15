
###############################################################################################
# Modules
###############################################################################################

resource "tfe_registry_module" "modules" {
  for_each = var.registry_modules

  organization    = var.tfe_organization
  name            = each.value.name
  module_provider = each.value.module_provider
  registry_name   = each.value.registry_name
  namespace       = each.value.namespace

  vcs_repo {
    display_identifier         = each.value.identifier
    identifier                 = each.value.identifier
    github_app_installation_id = data.tfe_github_app_installation.github_app[each.key].id
    branch                     = each.value.branch
    tags                       = each.value.tags
  }

}
