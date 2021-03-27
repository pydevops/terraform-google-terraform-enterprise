terraform {
  backend "gcs" {
    bucket = "cdw-tfe-terraform-backend"
    prefix = "regional-ha"
  }
}
