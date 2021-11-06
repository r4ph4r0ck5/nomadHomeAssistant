job "PLEX" { 
  datacenters = ["casa"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "PLEXMEDIASERVER" {
    count = 1
    volume "plexconfig" {
      type      = "host"
      read_only = false
      source    = "plexconfig"
    }
    volume "plexmovies" {
      type      = "host"
      read_only = false
      source    = "plexmovies"
    }
    network {
        mode = "host"
        }
    }
    task "plexserver" {
      driver = "docker"
      volume_mount {
        volume      = "plexconfig"
        destination = "/config"
        read_only   = false
      }
      volume_mount {
        volume      = "plexmovies"
        destination = "/movies"
        read_only   = false
      }
      config {
        image = "lscr.io/linuxserver/plex"
        privileged = true
        network_mode = "host"
        force_pull = "true"
      }
      env {
        PUID = "1000"
        PGID = "1000"
        VERSION = "docker"
      }
    }
  }
