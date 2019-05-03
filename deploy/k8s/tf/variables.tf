variable "make_namespace" {
  default     = "0"
  description = "Create namespace if set to 1"
}

variable "namespace" {
  default     = "default"
  description = "Namespace to deploy to."
}

variable "service_type" {
  default     = "ClusterIP"
  description = "Determines how the service is exposed. See Kube docs."
}

variable "service_cluster_ip" {
  default     = "None"
  description = "The IP address of the service. See Kube docs."
}

variable "version" {
  default     = "latest"
  description = "Unstick image version tag."
}

variable "cookie_name" {
  default     = "SESSION_AFFINITY"
  description = "The name of the cookie to be deleted."
}

variable "redirect" {
  default     = ""
  description = "The name of the cookie to be deleted. Empty doesn't redirect."
}
