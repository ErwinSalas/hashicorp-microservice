variable "project" {
  description = "The GCP project to use."
  default     = "hashicorp-393022"
}

variable "region" {
  description = "The GCP region to deploy to."
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone to deploy to."
  default     = "us-east1-b"
}

variable "machine_image" {
  description = "The compute image to use for the server and client machines. Output from the Packer build process."
  default     = "hashistack-20230815075041"
}

variable "name" {
  description = "Prefix used to name various infrastructure components. Alphanumeric characters only."
  default     = "nomad"
}

variable "retry_join" {
  description = "Used by Consul to automatically form a cluster."
  type        = string
  default     = "project_name=hashicorp-393022 provider=gce tag_value=auto-join"
}

variable "allowlist_ip" {
  description = "IP to allow access for the security groups (set 0.0.0.0/0 for world)"
  default     = "0.0.0.0/0"
}

variable "server_instance_type" {
  description = "The compute engine instance type to use for servers."
  default     = "e2-micro"
}

variable "client_instance_type" {
  description = "The compute engine instance type to use for clients."
  default     = "e2-micro"
}

variable "server_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "client_count" {
  description = "The number of clients to provision."
  default     = "3"
}

variable "root_block_device_size" {
  description = "The volume size of the root block device."
  default     = 20
}

variable "nomad_consul_token_id" {
  description = "Accessor ID for the Consul ACL token used by Nomad servers and clients. Must be a UUID."
  default     = "f1c74ed9-4daa-4e32-fd36-e1e0993e08a6"
}

variable "nomad_consul_token_secret" {
  description = "Secret ID for the Consul ACL token used by Nomad servers and clients. Must be a UUID."
  default     = "83a94b86-e145-b1e3-00d9-aca8e09caf30"
}

variable "nomad_binary" {
  description = "URL of a zip file containing a nomad executable to replace the Nomad binaries in the AMI with. Example: https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"
  default     = "https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"
}