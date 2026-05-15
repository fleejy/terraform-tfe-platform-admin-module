locals {
  github_app_installations = {
    for github_app_installation in module.platform_admin_module.github_app_installations :
    github_app_installation.attributes.name => {
      id                = github_app_installation.id
      installation_type = github_app_installation.attributes["installation-type"]
      installation_id   = github_app_installation.attributes["installation-id"]
    }
  }
}


output "fixed_projects" {
  description = "Fixed projects metadata"
  value       = module.platform_admin_module.fixed_projects
}

output "fixed_teams" {
  description = "fixed teams metadata"
  value       = module.platform_admin_module.fixed_teams
}

output "policy_sets" {
  description = "policy-set metadata"
  value       = module.platform_admin_module.policy_sets
}

output "github_app_installations" {
  description = "the metadata of every GitHub App Installation"
  value       = local.github_app_installations
}
