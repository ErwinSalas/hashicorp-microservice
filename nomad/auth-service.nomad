job "auth-service-cluster" {
  datacenters = ["dc1"]
  type        = "service"

  group "database" {
    count = 1

    network {
      mode = "bridge"
      port "db" {
        to = 5432
      }
    }
    service {
      name = "authdb"
      tags = ["postgres for vault"]
      port = "db"
      connect {
        sidecar_service {}
      }
      check {
        type     = "script"
        interval = "10s"
        timeout  = "2s"
        command  = "true"
        args     = ["pg_isready", "-d", "auth"] # Use pg_isready for the health check
      }
    }

    task "auth-database" {
      driver = "docker"

      config {
        image = "postgres:latest"
      }

      env {
        POSTGRES_USER     = "erwin"
        POSTGRES_PASSWORD = "password"
        POSTGRES_DB       = "auth"
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

  group "service" {
    network {
      mode = "bridge"

      port "rpc" {
        to = 50051
      }
    }
    service {
      name = "authsrv"
      # This tells Consul to monitor the service on the port
      # labelled "rpc". Since Nomad allocates high dynamic port
      # numbers, we use labels to refer to them.
      port = "rpc"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "authdb"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "auth-service" {
      driver = "docker"

      config {
        image = "erwinsalas42/go-grpc-auth-svc:v1.1"
      }

      env {
        PORT           = ":${NOMAD_PORT_rpc}"
        DB_URL         = "postgres://erwin:password@${NOMAD_UPSTREAM_ADDR_authdb}/auth"
        JWT_SECRET_KEY = "r43t18sc"
        API_SECRET     = "98hbun98h"
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