output "export_fixed_teams" {
  description = "fixed teams metadata"
  value       = tfe_team.fixed_teams
}

output "export_fixed_projects" {
  description = "Fixed projects metadata"
  value       = tfe_project.fixed_projects
}
