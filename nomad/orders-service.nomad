job "orders-service-cluster" {
  datacenters = ["dc1"]
  type        = "service"

  group "orders" {
    count = 1

    network {
      mode = "bridge"
      port "db" {}
      port "rpc" {}
    }

    service {
      name = "ordersrv"
      # This tells Consul to monitor the service on the port
      # labelled "rpc". Since Nomad allocates high dynamic port
      # numbers, we use labels to refer to them.
      port = "rpc"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "productsrv"
              local_bind_port  = 8081
            }
          }
        }
      }
    }

    task "orders-database" {
      driver = "docker"
      config {
        image = "postgres"
        args  = ["-p", "${NOMAD_PORT_db}"]
      }
      env {
        POSTGRES_USER     = "erwin"
        POSTGRES_PASSWORD = "password"
        POSTGRES_DB       = "order"
      }

      resources {
        cpu    = 100 # 100 Mhz
        memory = 128 # 128MB
      }

      restart {
        attempts = 5
        delay    = "25s"
      }
    }

    task "order-service" {
      driver = "docker"

      config {
        image = "erwinsalas42/go-grpc-order-svc:v1"
        ports = ["rpc"]
      }

      env {
        PORT            = ":${NOMAD_PORT_rpc}"
        PRODUCT_SVC_URL = "${NOMAD_UPSTREAM_ADDR_productsrv}"
        DB_URL          = "postgres://erwin:password@127.0.0.1:${NOMAD_PORT_db}/order"
      }

      resources {
        cpu    = 100 # 100 Mhz
        memory = 128 # 128MB
      }

      restart {
        attempts = 5
        delay    = "25s"
      }
    }
  }
}