# Policy Set Onboarding

## Introduction

This documentation will provide guidance for how to deploy a Sentinel Policy Set within the desired TFC/E environment.

## Prerequisites

* A directory created within the github-org-name/terraform-sentinel-policies repository, under the appropriate environment directory, that contains all of the sentinel policies that will be grouped together as a policy set
    * To ensure sentinel polciies are managed through a singular, central repository, the module is hard-coded to only acknowledge sentinel policies that exist within this repository, and from the main branch

## Steps to Perform

1. Within this policy-sets folder, create a <name_you_want_for_the_policy_set>.yaml file that'll define the configuration of the policy set you want to create
    * Below are examples of how you'd configure the yaml file to create certain types of policy sets

__For creating a policy set that is associated to every workspace:__
```
policy-set-1: # The name you want for the policy set
    policies_path: "environment/test-company-<env>/<policy_set_name>" # The directory path that contains the sentinel policies you want this policy set to be a group of
    global: true # Required to have this policy set associated to every workspace
```

__For creating a policy set that is associated to only specific projects:__
```
policy-set-1: # The name you want for the policy set
    policies_path: "environment/test-company-<env>/<policy_set_name>" # The directory path that contains the sentinel policies you want this policy set to be a group of
    project_names: [
        "project-1",
        "project-2"
    ]
```

__For creating a policy set that is associated to only specific workspaces:__
```
policy-set-1: # The name you want for the policy set
    policies_path: "environment/test-company-<env>/<policy_set_name>" # The directory path that contains the sentinel policies you want this policy set to be a group of
    workspace_names: [
        "workspace-1",
        "workspace-2"
    ]
```
__If you need to exclude workspaces, add an `excluded_workspace_names` argument:__
```
policy-set-1: # The name you want for the policy set
    policies_path: "environment/test-company-<env>/<policy_set_name>" # The directory path that contains the sentinel policies you want this policy set to be a group of
    excluded_workspace_names: [
        "workspace-1",
    ]
```