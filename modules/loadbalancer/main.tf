#docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 127.0.0.1:2375:2375 bobrik/socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock
#export DOCKER_HOST=tcp://localhost:2375

resource "docker_container" "loadbalancer" {
  name  = "tia-loadbalancer"
  image = "swinkler/tia-loadbalancer"
  env = [
    "ADDRESSES=${join(" ", var.addresses)}"
  ]
  ports {
    internal = 80
    external = 5000
  }
}

