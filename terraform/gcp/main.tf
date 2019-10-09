
provider "google" {
    credentials = "${file("~/.gcp/credentials.json")}"
    project = "MVM01"
    region = "us-east1"
}

resource "google_cloudfunctions_function" "GCPfunction"{
    name = "GCPterraform"
    runtime = "python37"
    source_archive_bucket = var.source_archive_bucket
    source_archive_object = var.source_archive_object
    entry_point = var.entry_point
}

resource "google_cloudfunctions_function_iam_member" "admin" {
    region = "us-east-1"
    cloud_function = "${google_cloudfunctions_function.function.name}"
    role = "roles/cloudfunctions.admin"
    member = "vmadbrogcp-cf@utility-braid-166722.iam.gserviceaccount.com"
}