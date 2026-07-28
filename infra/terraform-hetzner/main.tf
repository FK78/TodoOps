terraform {
  required_providers {
    hcloud = {
        source = "hetznercloud/hcloud"
        version = "1.67.0"
    }
    tls = {
        source = "hashicorp/tls"
        version = "4.3.0"
    }
    local = {
        source = "hashicorp/local"
        version = "2.9.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resourece "tls_private_key" "ssh" {
    algorithm = "ED25519"
}

resource "hcloud_ssh_key" "deployer" {
  name = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content = tls_private_key.ssh.private_key_openssh
  filename = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

resource "hcloud_firewall" "todo_ops" {
  name = "todo-ops-fw"

  rule {
    direction = "in"
    protocol = "tcp"
    port = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol = "tcp"
    port = "3000"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "todo_ops" {
  name = "todo-ops-server"
  image = "ubuntu-24.04"
  server_type = "cax11"
  location = var.location
  ssh_keys = [hcloud_ssh_key.deployer.id]
  firewall_ids = [hcloud_firewall.todo_ops.id]
}