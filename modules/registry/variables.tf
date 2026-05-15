variable "tfe_hostname" {
  description = "Terraform enterprise hostname"
  type        = string
}

variable "tfe_organization" {
  description = "Terraform enterprise organization name"
  type        = string
}

variable "registry_modules" {
  description = "Map of modules to create in the Private Registry"
  type = map(object({
    identifier      = string
    name            = optional(string)
    module_provider = optional(string)
    registry_name   = optional(string)
    namespace       = optional(string)
    branch          = optional(string)
    tags            = optional(bool)
  }))
  default = {}
}
