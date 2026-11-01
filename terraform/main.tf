terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

resource "local_file" "payment_env" {
  filename = "${path.module}/payment.env"
  content  = "URL=http://localhost:30091\n"
}

output "payment_env_path" {
  value = local_file.payment_env.filename
}
