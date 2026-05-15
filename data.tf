
# You would supply this token through an environment variable set in the workspace from a service account or user in TFE that has admin privilages to the TFE installation
data "external" "env" {
  program = ["jq", "-n", "env | {TFE_TOKEN}"]
}

#This is required because the TFE provider does not have a data source that can obtain the same data
data "http" "github_app_installations" {

  url = "https://${var.tfe_hostname}/api/v2/github-app/installations"

  request_headers = {
    Authorization = "Bearer ${data.external.env.result["TFE_TOKEN"]}"
    Content-Type  = "application/vnd.api+json"
  }

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "github_app_installation data source API request unsuccessful."
    }
  }
}