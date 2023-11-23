job "products-service-cluster" {
  datacenters = ["dc1"]

  group "producs" {
    count = 1

    network {
      mode = "bridge"
      port "rpc" {}
      port "db" {}
    }

    service {
      name = "productsrv"
      # This tells Consul to monitor the service on the port
      # labelled "http". Since Nomad allocates high dynamic port
      # numbers, we use labels to refer to them.
      port = "rpc"
    }
    task "product-service" {
      driver = "docker"

      config {
        image = "erwinsalas42/go-grpc-product-svc:v1.1"
      }

      env {
        PORT   = ":${NOMAD_PORT_rpc}"
        DB_URL = "postgres://erwin:password@127.0.0.1:${NOMAD_PORT_db}/product"
      }

      resources {
        cpu    = 100 # 100 Mhz
        memory = 128 # 128MB
      }
    }

    task "products-database" {
      driver = "docker"
      config {
        image = "postgres"
        args  = ["-p", "${NOMAD_PORT_db}"]

      }

      env {
        POSTGRES_USER     = "erwin"
        POSTGRES_PASSWORD = "password"
        POSTGRES_DB       = "product"
      }

      resources {
        cpu    = 100 # 100 Mhz
        memory = 128 # 128MB
      }
    }
  }
}