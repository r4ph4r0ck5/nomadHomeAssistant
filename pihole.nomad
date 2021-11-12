job "PIHOLE" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "PIHOLE" {
    count = 1
    volume "pihole" {
      type      = "host"
      read_only = false
      source    = "pihole"
    }
    volume "piholednsmasq" {
      type      = "host"
      read_only = false
      source    = "piholednsmasq"
    }
    network {
        mode = "host"
        port "http"{
        static = 80
        }
        port "DNS"{
        static = 53
        }
    }
    task "piholecore" {
      driver = "docker"
      volume_mount {
        volume      = "pihole"
        destination = "/etc/pihole/"
        read_only   = false
      }
      volume_mount {
        volume      = "piholednsmasq"
        destination = "/etc/dnsmasq.d/"
        read_only   = false
      }
      config {
        image = "pihole/pihole:latest"
        privileged = true
        ports = ["http","DNS"]
        network_mode = "host"
      }
      env {
        TZ="America/Sao_Paulo"
        WEBPASSWORD="Welcome123"
      }
    }
  }
}
