variable "source_archive_bucket" {
    type = string
}

variable "source_archive_object" {
    type = string
}

variable "name" {
    type = string
}

variable "entry_point" {
    type = string
}

variable "runtime" {
    type = string
}

provider "google" {
    credentials = "${file("$HOME/.gcp/credentials.json")}"
    project = "MVM01"
    region = "us-east1"
}

resource "google_cloudfunctions_function" "GCPfunction"{
    name = var.name
    runtime = var.runtime
    source_archive_bucket = var.source_archive_bucket
    source_archive_object = var.source_archive_object
    entry_point = var.entry_point
}

resource "google_cloudfunctions_function_iam_member" "admin" {
    project = "MVMV01"
    region = "us-east-1"
    cloud_function = ${google_cloudfunctions_function.function.name}
    role = "roles/cloudfunctions.admin"
    member = "vmadbrogcp-cf@utility-braid-166722.iam.gserviceaccount.com"
}