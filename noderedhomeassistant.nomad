job "NODERED" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "NODEREDCORE" {
    count = 1
    network {
        mode = "host"
        port "http"{
        static = 1880
        }
    }
    volume "nodered" {
      type      = "host"
      read_only = false
      source    = "nodered"
    }
    task "supervisor" {
      driver = "docker"
      volume_mount {
        volume      = "nodered"
        destination = "/data"
        read_only   = false
      }
      config {
        image = "nodered"
        ports = ["http"]
        network_mode = "host"
      }
      env {
        TZ="America/Sao_Paulo"
      }
      resources {
        cpu    = 2000 # MHz
        memory = 2048 # MB
      }
    }
  }
}