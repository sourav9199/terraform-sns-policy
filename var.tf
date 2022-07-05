variable "account_id" {
    type = string
    description = "Provide AWS Account ID" 
}

variable "sns_name" {
    type = string
    description = "SNS Topic name"
}

variable "sns_display_name" {
    type = string
    description = "SNS Topic Display Name" 
}

variable "user_policy" {
    description = "User can Provide a second policy as JSON."
  
}