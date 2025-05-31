resource "aws_iam_user" "admin_user" {
  name = "${var.env}-eks-admin"
  path="/"
  force_destroy = true
}

# Resource: Admin Access Policy - Attach it to admin user
resource "aws_iam_user_policy_attachment" "admin_user" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

## Resource: AWS IAM Group
#resource "aws_iam_group" "eksadmins_iam_group" {
#  name = "${var.env}-eksadmins"
#  path = "/"
#}
#
## Resource: AWS IAM Group Policy
#resource "aws_iam_group_policy" "eksadmins_iam_group_assumerole_policy" {
#  name  = "${var.env}-eksadmins-group-policy"
#  group = aws_iam_group.eksadmins_iam_group.name
#
#  # Terraform's "jsonencode" function converts a
#  # Terraform expression result to valid JSON syntax.
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "sts:AssumeRole",
#        ]
#        Effect   = "Allow"
#        Sid    = "AllowAssumeOrganizationAccountRole"
#        Resource = "${aws_iam_role.eks_admin_role.arn}"
#      },
#    ]
#  })
#}

## Resource: AWS IAM Group Membership
#resource "aws_iam_group_membership" "eksadmins" {
#  name = "${var.env}-eksadmins-group-membership"
#  users = [
#    aws_iam_user.admin_user.name
#  ]
#  group = aws_iam_group.eksadmins_iam_group.name
#}

resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
  inline_policy {
    name = "eks-full-access-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "iam:ListRoles",
            "eks:*",
            "ssm:GetParameter"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  tags = {
    tag-key = "eks-admin-role"
  }
}