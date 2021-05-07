variable "subnetwork" {}
variable "service_account" {}
variable "dnsmasq" {
  type = map(any)
  default = {
  }
}
