job "HASupervisor" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "HASupervisor" {
    count = 1
    volume "dockersock" {
      type      = "host"
      read_only = false
      source    = "dockersock"
    }
    volume "dbus" {
      type      = "host"
      read_only = true
      source    = "dbus"
    }
    volume "udev" {
      type      = "host"
      read_only = true
      source    = "udev"
    }
    volume "machineid" {
      type      = "host"
      read_only = true
      source    = "machineid"
    }
    volume "hassiodata" {
      type      = "host"
      read_only = false
      source    = "hassiodata"
    }
    task "supervisor" {
      driver = "docker"
      volume_mount {
        volume      = "dockersock"
        destination = "/run/docker.sock"
        read_only   = false
      }
      volume_mount {
        volume      = "dbus"
        destination = "/run/dbus"
        read_only   = true
      }
      volume_mount {
        volume      = "udev"
        destination = "/run/udev"
        read_only   = true
      }
      volume_mount {
        volume      = "machineid"
        destination = "/etc/machine-id"
        read_only   = true
      }
      volume_mount {
        volume      = "hassiodata"
        destination = "/data"
        read_only   = false
      }
      config {
        image = "homeassistant/i386-hassio-supervisor"
      }
      env {
        TZ="America/Sao_Paulo"
        SUPERVISOR_SHARE="/data"
        SUPERVISOR_NAME="hassio_supervisor"
      }
      resources {
        cpu    = 2000 # MHz
        memory = 2048 # MB
      }
    }
  }
}