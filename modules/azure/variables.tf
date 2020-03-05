variable "location" {
  default = "southeastasia"
  type    = string
}

variable "environment" {
  type = object({
    name             = string
    background_color = string
  })
}
