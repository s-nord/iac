variable do_token {}
variable ssh_key_name {}
variable ssh_key_rebrain {}
variable tags {}
variable os {}
variable vps {}
variable plan {}
variable region {}
variable dns_zone {}
variable inventory_file {}
variable nipio_file {}
variable url_file {}
variable hosts_public {}
variable hosts_private {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "ssh-key" {
  name       = var.ssh_key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# data "digitalocean_ssh_key" "ssh-key" {
#   name = var.ssh_key_name
# }

data "digitalocean_ssh_key" "ssh-key-rebrain" {
  name = var.ssh_key_rebrain
}

resource "digitalocean_droplet" "vm" {
  count    = length(var.vps)
  name     = element(var.vps, count.index)
  region = var.region
  size   = element(var.plan, count.index)
  image = var.os
  tags = var.tags
  ssh_keys = [ digitalocean_ssh_key.ssh-key.id, data.digitalocean_ssh_key.ssh-key-rebrain.id ]

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "apt update",
      "apt -y install python-minimal python-pip"
    ]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      timeout = "2m"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

resource "local_file" "inv" {
  content  = templatefile("inv.tmpl", { vm = formatlist("[%s]\n%s\n", "${digitalocean_droplet.vm.*.name}", "${digitalocean_droplet.vm.*.ipv4_address}") })
  filename = var.inventory_file
}

resource "local_file" "hosts_public" {
  content  = templatefile("hosts.tmpl", { vm = formatlist("%s %s", "${digitalocean_droplet.vm.*.ipv4_address}", "${digitalocean_droplet.vm.*.name}") })
  filename = var.hosts_public
}

resource "local_file" "hosts_private" {
  content  = templatefile("hosts.tmpl", { vm = formatlist("%s %s", "${digitalocean_droplet.vm.*.ipv4_address_private}", "${digitalocean_droplet.vm.*.name}") })
  filename = var.hosts_private
}

resource "local_file" "nipio" {
  content  = "---\nnipio_ip: ${digitalocean_droplet.vm[0].ipv4_address}\n"
  filename = var.nipio_file
}

resource "local_file" "url" {
  content  = "https://app.${digitalocean_droplet.vm[0].ipv4_address}.${var.dns_zone}\nhttps://grafana.${digitalocean_droplet.vm[0].ipv4_address}.${var.dns_zone}\n"
  filename = var.url_file
}

resource "null_resource" "ansible" {
  depends_on = [local_file.inv]

  provisioner "local-exec" {
    command = "ansible-playbook --vault-password-file ~/.ansible/rebrain-vault.pwd -i ${var.inventory_file} deploy.yml"
  }
}
