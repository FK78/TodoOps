output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value = aws_instance.todo_ops.public_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value = "ssh -i ${local_file.ssh_private_key.filename} ubuntu@${aws_instance.todo_ops.public_ip}"
}