output "fixed_projects" {
  description = "Fixed projects metadata"
  value       = module.projects_teams.export_fixed_projects
}

output "fixed_teams" {
  description = "fixed teams metadata"
  value       = module.projects_teams.export_fixed_teams
}

output "policy_sets" {
  description = "policy-set metadata"
  value       = module.policy_sets.export_policy_sets
}

output "github_app_installations" {
  description = "the metadata of every GitHub App Installation"
  value       = jsondecode(data.http.github_app_installations.response_body).data
}