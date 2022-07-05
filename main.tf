resource "aws_sns_topic" "sourav" {
    name = var.sns_name
    display_name = var.sns_display_name
    delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF     
}

resource "aws_sns_topic_policy" "policy" {
    arn = aws_sns_topic.sourav.arn
    policy = data.aws_iam_policy_document.combined.json
  
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.sourav.arn,
    ]

    sid = "Default_Policy"
  }
}

data "aws_iam_policy_document" "combined" {
    source_policy_documents = [
        data.aws_iam_policy_document.sns_topic_policy.json,
        var.user_policy
    ]
  
}