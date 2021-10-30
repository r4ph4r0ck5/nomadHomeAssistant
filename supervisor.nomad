job "SUPERVISOR" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "HACORE" {
    count = 1
    task "corecontainer" {
      driver = "docker"
      config {
        image = "ghcr.io/home-assistant/home-assistant:stable"
        ports = ["http"]
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