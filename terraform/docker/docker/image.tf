# Pulls the image
resource "docker_image" "image" {
    name = var.image
}