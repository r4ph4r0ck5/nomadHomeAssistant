job "HA" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "HACORE" {
    count = 1
    network {
        mode = "host"
        port "http"{
        static = 8123
        }
    }
    task "corecontainer" {
      driver = "docker"
      config {
        image = "ghcr.io/home-assistant/home-assistant:stable"
        ports = ["http"]
        privileged = true
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
