#
# Title:bucket.tf
# Description: create a bucket with standard storage
# Development Environment: OS X 10.13.6/Terraform v1.3.2
#
# how to list using gcloud
resource "google_storage_bucket" "lab14" {
  name          = "terratest-2718"
  location      = "US"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "lab14-demo" {
  name         = "bucket.tf"
  source       = "./bucket.tf"
  content_type = "text/plain"
  bucket       = google_storage_bucket.lab14.id
}
