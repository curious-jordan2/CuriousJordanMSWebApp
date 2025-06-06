locals {
    docker_host = var.local_os == "windows" ? "npipe:////./pipe/docker_engine" : "unix:///var/run/docker.sock"
}

provider "docker" {
    host = local.docker_host
}
