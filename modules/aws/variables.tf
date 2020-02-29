variable "environment" {
  type = object({
    name             = string
    background_color = string
  })
}

variable "ssh_keypair" {
  default = null
  type    = string
}
