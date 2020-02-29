variable "location" {
  default = "westus2"
  type    = string
}

variable "environment" {
  type = object({
    name             = string
    background_color = string
  })
}