variable "dns_fqdn" {
  description = "The fully qualified domain name for which the certificate will be issued."
  type        = string
}

variable "labels" {
  default     = {}
  description = "A collection of labels which will be applied to resources."
  type        = map(string)
}

variable "prefix" {
  description = "The prefix which will be prepended to the names of resources."
  type        = string
}

variable "primaries_instance_groups_self_links" {
  description = "The self links of the compute instance groups which comprise the primaries."
  type        = list(string)
}

variable "secondaries_instance_group_manager_instance_group" {
  description = "The compute instance group of the secondaries."
  type        = string
}

variable "vpc_address" {
  description = "The address which will be assigned to the load balancer."
  type        = string
}

variable "vpc_application_tcp_port" {
  description = "The application TCP port."
  type        = string
}

variable "vpc_install_dashboard_tcp_port" {
  description = "The install dashboard TCP port."
  type        = string
}
