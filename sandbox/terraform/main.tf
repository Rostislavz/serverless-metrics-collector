provider "aws" {
  region = var.region
}

# S3 Backend for Terraform State
terraform {
  backend "s3" {
    bucket  = "serverless-metrics-collector-130823"
    key     = "terraform/sandbox_infrastructure/terraform.tfstate"
    region  = "eu-central-1"
  }
}

# Unattached EBS disks
resource "aws_ebs_volume" "unattached_disk" {
  count             = var.unattached_disks_count
  availability_zone = "${var.region}a"
  size              = var.unattached_disks_size
  tags = {
    Name = "UnattachedDisk-${count.index + 1}"
  }
}

# Non-encrypted EBS disks
resource "aws_ebs_volume" "non_encrypted_disk" {
  count             = var.non_encrypted_disks_count
  availability_zone = "${var.region}a"
  size              = var.non_encrypted_disks_size
  encrypted         = false
  tags = {
    Name = "NonEncryptedDisk-${count.index + 1}"
  }
}

# Non-encrypted snapshots from the non-encrypted disks
resource "aws_ebs_snapshot" "non_encrypted_snapshot" {
  count    = var.non_encrypted_snapshots_count
  volume_id = aws_ebs_volume.non_encrypted_disk[count.index % var.non_encrypted_disks_count].id
  tags = {
    Name = "NonEncryptedSnapshot-${count.index + 1}"
  }
}
