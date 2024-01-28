
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm_1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm_1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm_2.network_interface.0.ip_address
}
output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm_2.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm_3.network_interface.0.ip_address
}
output "external_ip_address_vm_3" {
  value = yandex_compute_instance.vm_3.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_4" {
  value = yandex_compute_instance.vm_4.network_interface.0.ip_address
}
output "external_ip_address_vm_4" {
  value = yandex_compute_instance.vm_4.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_5" {
  value = yandex_compute_instance.vm_5.network_interface.0.ip_address
}
output "external_ip_address_vm_5" {
  value = yandex_compute_instance.vm_5.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_6" {
  value = yandex_compute_instance.vm_6.network_interface.0.ip_address
}
output "external_ip_address_vm_6" {
  value = yandex_compute_instance.vm_6.network_interface.0.nat_ip_address
}

output "subnet-1" {
  value = yandex_vpc_subnet.subnet_1.id
}

output "subnet-2" {
  value = yandex_vpc_subnet.subnet_2.id
}

output "subnet-3" {
  value = yandex_vpc_subnet.subnet_3.id
}

output "subnet-4" {
  value = yandex_vpc_subnet.subnet_4.id
}