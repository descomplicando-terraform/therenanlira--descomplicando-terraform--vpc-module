variable "org_name" {
  description = "The name of the organization"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC"
  type        = string
}

variable "default_tags" {
  description = "The default tags for the VPC"
  type        = map(string)
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

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr_block))
    error_message = "The CIDR block must be in the format x.x.x.x/xx"
  }

  validation {
    condition     = split("/", var.vpc_cidr_block)[1] == "16"
    error_message = "The mask must be /16"
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

variable "flow_logs_retention_in_days" {
  description = "The retention in days for the flow logs"
  type        = number
  default     = 7
}