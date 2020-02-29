variable "project_id" {
  description = "The GCP project id"
  type        = string
}

variable "region" {
  default     = "us-central1"
  description = "GCP region"
  type        = string
}

variable "environment" {
  type = object({
    name             = string
    background_color = string
  })
}