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
    task "nodered" {
      driver = "docker"
      user = "1000:1000"
      volume_mount {
        volume      = "nodered"
        destination = "/data"
        read_only   = false
      }
      config {
        image = "192.168.15.69:5000/nodered"
        ports = ["http"]
        network_mode = "host"
        privileged = true
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