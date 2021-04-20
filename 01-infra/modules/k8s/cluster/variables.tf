variable "vpc_id" {
  type = string
}

variable "vswitch_ids" {
  type = list(string)
}

variable "create_nat" {
  type    = bool
  default = false
}

variable "create_private_zone" {
  type    = bool
  default = false
}

variable "expose_api" {
  type    = bool
  default = false
}
