variable "vpc" {
  type = object({
    cidr = string
  })
}

variable "nat" {
  type = object({
    deploy        = bool
    specification = string
    eip           = object({
      bandwidth = number
    })
  })
}

variable "private_vswitches" {
  type = list(string)
}

variable "data_vswitches" {
  type = list(string)
}

variable "security_group" {
  type = object({
    rules = list(object({
      type        = string
      ip_protocol = string
      port_range  = string
      cidr_ip     = string
    }))
  })
}
