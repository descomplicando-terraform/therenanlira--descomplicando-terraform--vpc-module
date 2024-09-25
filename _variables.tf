variable "org_name" {
  description = "The name of the organization"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC"
  type        = string
}

variable "azs_count" {
  description = "The number of availability zones"
  type        = number
  default     = 2
  validation {
    condition     = var.azs_count <= 3
    error_message = "The number of availability zones must be between 0 and 3"
  }
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all availability zones"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0"
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.vpc_cidr))
    error_message = "The CIDR block must be in the format x.x.x.x"
  }
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the VPC"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable flow logs for the VPC"
  type        = bool
  default     = false
}