job "DockerRegistry" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "CORE" {
    count = 1
    volume "registry" {
      type      = "host"
      read_only = false
      source    = "registry"
    }
    network {
        mode = "host"
        port "http"{
        static = 5000
        }
    }
    task "registry" {
      driver = "docker"
      volume_mount {
        volume      = "registry"
        destination = "/var/lib/registry"
        read_only   = false
      }
      config {
        image = "registry:2"
        ports = ["http"]
        privileged = true
        network_mode = "host"
      }
    }
  }
}
