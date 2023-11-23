# Terraform variables (all are required)
retry_join                = "project_name=hashicorp-393022 provider=gce tag_value=auto-join"
machine_image             = "hashistack-20230815075041"
nomad_consul_token_id     = "123e4567-e89b-12d3-x456-426614174000"
nomad_consul_token_secret = "123e4567-e89b-12d3-a456-426614174000"

# These variables will default to the values shown
# and do not need to be updated unless you want to
# change them
# allowlist_ip            = "0.0.0.0/0"
# name                    = "nomad"
# server_instance_type    = "t2.micro"
# server_count            = "3"
# client_instance_type    = "t2.micro"
# client_count            = "3"