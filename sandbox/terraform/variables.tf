variable "region" {
  description = "The AWS region."
  default     = "eu-central-1"
}


variable "unattached_disks_count" {
  description = "Number of unattached EBS disks."
  default     = 1
}

variable "unattached_disks_size" {
  description = "Size (in GB) for unattached EBS disks."
  default     = 10
}

variable "non_encrypted_disks_count" {
  description = "Number of non-encrypted EBS disks."
  default     = 2
}

variable "non_encrypted_disks_size" {
  description = "Size (in GB) for non-encrypted EBS disks."
  default     = 10
}

variable "non_encrypted_snapshots_count" {
  description = "Number of non-encrypted EBS disk snapshots."
  default     = 3
}
