provider "aws" {
  region = "us-east-1"
}
resource "aws_iam_group" "group" {
  name = "DevOpsGroup-Hamza"
}
resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each = {
    "EC2FullAccess" = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    "S3FullAccess"  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }

  group      = aws_iam_group.group.name
  policy_arn = each.value
}
resource "aws_iam_user" "user" {
  name = "devops-user"
}
resource "aws_iam_user_group_membership" "membership" {
  user   = aws_iam_user.user.name
  groups = [aws_iam_group.group.name]
}
resource "aws_iam_role" "ec2_role" {
  name = "EC2Role-Hamza"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_role_policies" {
  for_each = {
    "EC2FullAccess" = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    "S3FullAccess"  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }

  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile-Hamza"
  role = aws_iam_role.ec2_role.name
}