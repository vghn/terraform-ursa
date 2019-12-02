resource "aws_iam_role" "vbot" {
  name               = "vbot"
  description        = "VBot"
  assume_role_policy = data.aws_iam_policy_document.vbot_trust.json
}

data "aws_iam_policy_document" "vbot_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.vbot.arn]
    }
  }
}

resource "aws_iam_role_policy_attachment" "vbot" {
  role       = aws_iam_role.vbot.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "vbot" {
  name = "vbot"
}

resource "aws_iam_user_policy" "vbot" {
  name   = "vbot"
  user   = aws_iam_user.vbot.name
  policy = data.aws_iam_policy_document.vbot_user.json
}

data "aws_iam_policy_document" "vbot_user" {
  statement {
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_access_key" "vbot_v1" {
  user = aws_iam_user.vbot.name
}
