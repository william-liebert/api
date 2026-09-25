variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "chart_repository_url" {
  description = "Path to the Helm chart used for the local bootstrap"
  type        = string
  default     = "../../charts/development"
}

variable "api_image_repository" {
  description = "Registry-qualified API image repository for the bootstrap release"
  type        = string
}

variable "api_image_tag" {
  description = "API image tag for the bootstrap release"
  type        = string
  default     = "latest"
}
