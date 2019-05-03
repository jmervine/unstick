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
  description = "Semicolon seperated list of cookies to be deleted."
}

variable "redirect" {
  default     = ""
  description = "The name of the cookie to be deleted. Empty doesn't redirect."
}

variable "use_ssl" {
  default     = "false"
  description = "Enable SSL support."
}

variable "port" {
  default     = "80"
  description = "Port to listen on."
}

variable "bind" {
  default     = "0.0.0.0"
  description = "Address to bind to."
}
