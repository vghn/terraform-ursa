# VBot
output "vbot_user_arn" {
  description = "VBot user ARN"
  value       = aws_iam_user.vbot.arn
}

output "vbot_access_key_id" {
  description = "VBot access key id"
  value       = aws_iam_access_key.vbot_v1.id
}

output "vbot_secret_access_key" {
  description = "VBot secret access key"
  value       = aws_iam_access_key.vbot_v1.secret
}

output "vbot_role_arn" {
  description = "VBot role ARN"
  value       = aws_iam_role.vbot.arn
}
