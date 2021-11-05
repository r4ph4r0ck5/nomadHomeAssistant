job "HACore" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "HACORE" {
    count = 1
    volume "haconfig" {
      type      = "host"
      read_only = false
      source    = "haconfig"
    }
    network {
        mode = "host"
        port "http"{
        static = 8123
        }
    }
    task "corecontainer" {
      driver = "docker"
      volume_mount {
        volume      = "haconfig"
        destination = "/config"
        read_only   = false
      }
      config {
        image = "ghcr.io/home-assistant/home-assistant:stable"
        ports = ["http"]
        privileged = true
        network_mode = "host"
        force_pull = "true"
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
