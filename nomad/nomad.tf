provider "nomad" {
  address = "http://34.73.74.131:4646"
}

resource "nomad_job" "api" {
  jobspec = file("${path.module}/api-gateway.nomad")
}

resource "nomad_job" "auth" {
  jobspec = file("${path.module}/auth-service.nomad")
}

resource "nomad_job" "products" {
  jobspec = file("${path.module}/products-service.nomad")
}

resource "nomad_job" "orders" {
  jobspec = file("${path.module}/orders-service.nomad")
}