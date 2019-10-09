variable "s3_bucket" {
    type = string
}

variable "s3_key" {
    type = string
}

variable "function_name" {
    type = string
}

variable "role" {
    type = string
}

variable "handler" {
    type = string
}

variable "runtime" {
    type = string
}


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

variable "gcp_runtime" {
    type = string
}
