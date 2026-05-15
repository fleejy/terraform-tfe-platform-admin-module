module "projects_teams" {
  source = "./modules/projects-teams"

  tfe_hostname     = var.tfe_hostname
  tfe_organization = var.tfe_organization
  fixed_projects   = var.fixed_projects
  fixed_teams      = var.fixed_teams
  github_app_name  = var.github_app_name
}

module "policy_sets" {
  source = "./modules/policy-sets"

  tfe_hostname     = var.tfe_hostname
  tfe_organization = var.tfe_organization
  policy_sets      = var.policy_sets
  fixed_projects   = module.projects_teams.export_fixed_projects
  github_app_name  = var.github_app_name
}

module "registry" {
  source = "./modules/registry"

  tfe_hostname     = var.tfe_hostname
  tfe_organization = var.tfe_organization
  registry_modules = var.registry_modules
}

