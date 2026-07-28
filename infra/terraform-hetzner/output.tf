output "instance_ip" {
    value = hcloud_server.todo_ops.ipv4_address
}

output "ssh_command" {
  value = "ssh -i ${local_file.ssh_private_key.filename} root@${hcloud_server.todo_ops.ipv4_address}"
}