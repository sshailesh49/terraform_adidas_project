variable "project_name" {
  type = string
}

variable "redshift_master_username" {
  description = "Username for Redshift master user"
  type        = string
  default     = "admin"
}

variable "redshift_master_password" {
  description = "Password for Redshift master user"
  type        = string
  sensitive   = true
  default     = "MustBeStrongP4ssword!" # Change this in production
}

variable "redshift_host" { type = string }
variable "redshift_port" { type = string }
variable "redshift_db" { type = string }