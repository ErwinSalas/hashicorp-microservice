job "api-gateway-cluster" {
  datacenters = ["dc1"]
  type        = "service"

  group "api" {
    count = 2

    task "api-gateway" {
      driver = "docker"

      config {
        image = "erwinsalas42/go-grpc-api-gateway:v1"
      }

      env {
        PORT            = ":${NOMAD_PORT_http}"
        AUTH_SVC_URL    = "authsrv"
        PRODUCT_SVC_URL = "productsrv"
        ORDER_SVC_URL   = "ordersrv"
      }


      service {
        name = "api-gateway"
        # This tells Consul to monitor the service on the port
        # labelled "http". Since Nomad allocates high dynamic port
        # numbers, we use labels to refer to them.
        port = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 100 # 100 Mhz
        memory = 128 # 128MB
        network {
          port "http" {}
        }
      }
    }
  }
}