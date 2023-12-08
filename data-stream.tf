resource "aws_kinesis_stream" "demo_stream" {
  name             = var.kinesis_data_stream
  retention_period = 24
  shard_count      = 1

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}