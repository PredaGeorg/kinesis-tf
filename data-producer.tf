data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "kinesis_producer" {
  name               = "kinesis-producer-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "kinesis_put" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [
      "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${var.kinesis_data_stream}"
    ]
  }
}

resource "aws_iam_policy" "kinesis_put" {
  name   = "kinesis-put-records-policy"
  policy = data.aws_iam_policy_document.kinesis_put.json
}

resource "aws_iam_role_policy_attachment" "kinesis_producer" {
  role       = aws_iam_role.kinesis_producer.name
  policy_arn = aws_iam_policy.kinesis_put.arn
}

resource "aws_iam_instance_profile" "producer" {
  name = "producer-instance-profile"
  role = aws_iam_role.kinesis_producer.name
}

resource "aws_instance" "producer" {
  ami                  = "ami-0cd3dfa4e37921605"
  iam_instance_profile = aws_iam_instance_profile.producer.name
  instance_type        = "t2.micro"
  user_data            = file("run-python-script.sh")
}



