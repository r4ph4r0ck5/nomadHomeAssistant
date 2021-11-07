job "TRANSMISSION" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "TRANSMISSION" {
    count = 1
    volume "transmissionconfig" {
      type      = "host"
      read_only = false
      source    = "transmissionconfig"
    }
    volume "transmissiondownloads" {
      type      = "host"
      read_only = false
      source    = "transmissiondownloads"
    }
    network {
        mode = "host"
        }
    
    task "plexserver" {
      driver = "docker"
      volume_mount {
        volume      = "transmissionconfig"
        destination = "/config"
        read_only   = false
      }
      volume_mount {
        volume      = "transmissiondownloads"
        destination = "/downloads"
        read_only   = false
      }
      config {
        image = "lscr.io/linuxserver/transmission"
        privileged = true
        network_mode = "host"
        force_pull = "true"
      }
      env {
        PUID = "1000"
        PGID = "1000"
        TZ= "Americas/Sao_Paulo"
      }
    }
  }
}