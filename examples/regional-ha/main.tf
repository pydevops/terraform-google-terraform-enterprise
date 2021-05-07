provider "google" {
  # credentials = file(var.credentials_file)
  project = var.project
  region  = var.region
}

provider "google-beta" {
  # credentials = file(var.credentials_file)
  project = var.project
  region  = var.region
}


data "google_compute_image" "os" {
  project = "centos-cloud"
  family  = "centos-7"
}

module "tfe" {
  source = "../../"

  namespace  = var.namespace
  node_count = 1
  #tfe_license_path         = var.tfe_license_path
  #tfe_license_name           = var.tfe_license_name
  fqdn                       = var.fqdn
  ssl_certificate_name       = var.ssl_certificate_name
  dns_zone_name              = var.dns_zone_name
  load_balancer              = "PUBLIC"
  database_availability_type = var.database_availability_type
  database_machine_type      = var.database_machine_type
  dnsmasq = {
    zone                 = "us-west1-b"
    domain_name          = "sabre.com"
    upstream_dns_server  = "169.254.169.254"
    bitbucket_ip_address = "10.1.1.10"
    disk_source_image    = data.google_compute_image.os.self_link
  }

}
