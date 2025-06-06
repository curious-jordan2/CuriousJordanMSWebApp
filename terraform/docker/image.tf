# Pulls the image
resource "docker_image" "image" {
    name = var.image
    build {
        context = var.docker_file_path
        dockerfile = var.docker_file
    }
}