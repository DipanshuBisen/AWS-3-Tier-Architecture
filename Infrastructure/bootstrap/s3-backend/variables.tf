variable "AWS_region" {
  description = "AWS default region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 bucket for the tf stae management"
  type =  string

  validation {
    condition = length(var.bucket_name)>=3 && length(var.bucket_name) <=63
    error_message = "S3 bucket name must be between 3 and 63 characters."
  }
}
