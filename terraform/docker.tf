provider "docker" {
  host = "tcp://127.0.0.1:2375/"
}

resource "docker_container" "vmadbro" {
  image = "${docker_image.ubuntu.latest}"
  name = "vmadbro"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}
