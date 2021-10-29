# This declares a job named "docs". There can be exactly one
# job declaration per job file.
job "HA" { 

  # Spread the tasks in this job between us-west-1 and us-east-1.
  datacenters = ["casa"]

  # Run this job as a "service" type. Each job type has different
  # properties. See the documentation below for more examples.
  type = "service"

  # Specify this job to have rolling updates, two-at-a-time, with
  # 30 second intervals.
  update {
    stagger      = "30s"
    max_parallel = 1
  }


  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  group "HACORE" {
    # Specify the number of these tasks we want.
    count = 1

    network {
        mode = "host"
        port "http"{
        static = 8123
        }

    }

    # The service block tells Nomad how to register this service
    # with Consul for service discovery and monitoring.
    #service {
      # This tells Consul to monitor the service on the port
      # labelled "http". Since Nomad allocates high dynamic port
      # numbers, we use labels to refer to them.
    #  port = "http"

    #  check {
    #    type     = "http"
    #    path     = "/health"
    ##    interval = "10s"
     #   timeout  = "2s"
     # }
    #}

    # Create an individual task (unit of work). This particular
    # task utilizes a Docker container to front a web application.
    task "corecontainer" {
      # Specify the driver to be "docker". Nomad supports
      # multiple drivers.
      driver = "docker"
      
      # Configuration is specific to each driver.
      config {
        image = "ghcr.io/home-assistant/home-assistant:stable"
        ports = ["http"]
      }

      # It is possible to set environment variables which will be
      # available to the task when it runs.
      env {
        TZ="America/Sao_Paulo"
      }

      # Specify the maximum resources required to run the task,
      # include CPU and memory.
      resources {
        cpu    = 2000 # MHz
        memory = 2048 # MB
      }
    }
  }
}
