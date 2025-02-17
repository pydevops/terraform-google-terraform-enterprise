variable "node_count" {
  description = "The number of compute instances to create."
  type        = number
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}


variable "license_secret" {
  description = <<-EOD
  The Secret Manager secret which comprises the Base64 encoded Replicated license file. The Terraform provider calls
  this value the secret_id and the GCP UI calls it the name.
  EOD
  type        = string
}

variable "fqdn" {
  description = "The fully qualified domain name which will be assigned to the DNS record."
  type        = string
}

variable "network" {
  description = "The self link of the network to which Terraform Enterprise will be attached."
  type        = string
}

variable "subnetwork" {
  description = "The self link of the subnetwork to which Terraform Enterprise will be attached."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in which a record will be created."
  type        = string
}
