variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type = string
  sensitive = true
}

variable "location" {
  description = "Hetzner datacenter location"
  type = string
  default = "nbg1"
}

variable "key_name" {
  description = "Name for the SSH key"
  type = string
  default = "todo-ops-key"
}