# Private Registry Onboarding

## Introduction

This documentation will provide guidance for how to deploy a private module within the desired TFC/E environment using this module.

## Prerequisites

* __A module's repository must meet all of the following requirements before you can add it to the registry:__
    * __The repository is following this naming scheme:__ `terraform-<provider>-<module_name>`
        * Module repositories must use the three-part name format, where <module_name> reflects the type of infrastructure the module manages and <provider> is the main provider where it creates that infrastructure. The <provider> segment must be all lowercase. The <module_name> segment can contain additional hyphens. Example: `terraform-aws-ec2` or `terraform-aws-ec2-instances`
    * __It's following the standard module structure for Terraform__
        * The module must adhere to the [standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure). This allows the registry to inspect your module and generate documentation, track resource usage, and more
    * __A release tag has been created within the module's repository__
        * A tag-based workflow is being followed for module's that are being published to the Private Registry through this module

## Steps to Perform

* Within this `registry-modules` folder, create a yaml file that'll define the configuration of the private module you want to publish using the example below:

__For publishing a private module__
```
terraform-<provider_name>-<module_name>:
    identifier: "<github_org_name>/<repository_name>"
```

## FAQ

* _How will I publish new versions of the module to the Private Registry?_
    * To release a new version of a module, create a new release tag within the module's repository. The registry will automatically be informed by GitHub of the new version being created through the VCS connection, and will in turn publish it to the registry
    * Refer to [Preparing a Module Repository](https://developer.hashicorp.com/terraform/cloud-docs/registry/publish-modules#preparing-a-module-repository) for details about release tag requirements
* _How will I delete certain versions of the module from the Private Registry?_
    * Deleting the release and tag from within the module's repository will _not_ cause the version to be deleted from the Private Registry