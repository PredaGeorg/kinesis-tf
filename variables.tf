variable "kinesis_data_stream" {
  description = "The name of your Kinesis Data Stream."
  type        = string
  default     = "my-data-stream"
}

variable "iam_name_prefix" {
  description = "Prefix used for all created IAM roles and policies"
  type        = string
  nullable    = false
  default     = "kinesis-firehose-"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
