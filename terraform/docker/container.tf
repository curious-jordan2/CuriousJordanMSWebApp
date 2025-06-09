# Creat locals
locals {
    network_mode = var.local_os == "windows" ? "nat" : "bridge"
}

# Create a container
resource "docker_container" "container" {
    name         = var.container_name
    image        = docker_image.image.image_id
    network_mode = local.network_mode
    command      = ["powershell", "-Command", "Start-Sleep -Seconds 3600"]

    ports {
    internal = 8000
    external = var.external_port
    }
}