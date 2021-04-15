resource "random_pet" "gcs" {
  length = 2
}

resource "google_storage_bucket" "tfe-bucket" {
  name     = "${var.namespace}-storage-${random_pet.gcs.id}"
  location = "us"

  labels = var.labels
}

# data "google_secret_manager_secret_version" "license" {
#   secret  = var.license_secret_id
# }
# resource "google_storage_bucket_object" "license" {
#   name   = var.license_name
#   #source = var.license_path
#   content = data.google_secret_manager_secret_version.license.secret_data
#   bucket = google_storage_bucket.tfe-bucket.name
# }
