# TFE Platform Admin Module
This terraform module can be used to manage the lifecycle of objects within an organization in HCP Terraform (HCPT) or Terraform Enterprise (TFE).

## Requirements
- Module is configured to work out of the box with:
  - VCS-driven workflow is being used with GitHub
  - GitHub App integration is being used
  - Team membership is controlled through SSO

## Guide
1. Publish this module into the Private Registry of the HCPT/TFE organization.
2. Create a deployment repository with the name `terraform-tfe-platform-admin-deployment`
3. Copy the contents under the `examples` directory into the new repository you created. Make sure to modify the value for the `source` in the main.tf to point to the location of your module in the Private Registry.
4. Through the UI, rename the default project in the org to `PLATFORM`
5. Through the UI, create a variable set named `platform-shared-variables` with the following key/value pairs created:
  - environment variables:
    - `TFE_TOKEN | <Supply a user API token that has no expiration from a service account or user in TFE that has admin privileges to the TFE installation as the value>`
6. Associate the `platform-shared-variables` variable set to the `PLATFORM` project only
7. Through the UI, create a workspace named `platform-admin-management` that will be used with the `terraform-tfe-platform-admin-deployment` repository
8. Execute an apply run in that workspace to deploy the desired objects.
9. Review the project workspaces that were deployed
10. Commit new workspace yamls within the `terraform-tfe-platform-workspace-onboarding-deployment` repo to deploy new workspaces in the appropriate project through the project workspaces.
