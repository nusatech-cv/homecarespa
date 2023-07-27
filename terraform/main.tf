resource "null_resource" "platform" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = var.host_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/platform",
    ]
  }

  provisioner "local-exec" {
    command = "mkdir -p /tmp/upload && rsync -rv --exclude=terraform ../ /tmp/upload/"
  }

  provisioner "file" {
    source      = "/tmp/upload/"
    destination = "/home/${var.ssh_user}/platform"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /home/${var.ssh_user}/platform/bin/install.sh",
        "/home/${var.ssh_user}/platform/bin/install.sh ${var.ssh_password}"
    ]
  }

  provisioner "remote-exec" {
    script = "../bin/start.sh"
  }
}
