resource "yandex_compute_image" "ubuntu_2204" {
  source_family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm_1" {
  name                      = "server1"
  hostname                  = "server1"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_1.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.webservers.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}

resource "yandex_compute_instance" "vm_2" {
  name                      = "server2"
  hostname                  = "server2"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  zone                      = "ru-central1-b"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_2.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.webservers.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}

resource "yandex_compute_instance" "vm_3" {
  name                      = "zabbix-server"
  hostname                  = "zabbix-server"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true
  zone                      = "ru-central1-d"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_4.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.zabbix-server.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}

resource "yandex_compute_instance" "vm_4" {
  name                      = "elastic"
  hostname                  = "elastic"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  zone                      = "ru-central1-c"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_3.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.elastic.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}

resource "yandex_compute_instance" "vm_5" {
  name                      = "kibana"
  hostname                  = "kibana"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true
  zone                      = "ru-central1-d"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_4.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}

resource "yandex_compute_instance" "vm_6" {
  name                      = "bastion-host"
  hostname                  = "bastion-host"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true
  zone                      = "ru-central1-d"
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      size     = 10
      image_id = yandex_compute_image.ubuntu_2204.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_4.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    user-data = "${file("G:/terraform/meta.yml")}"
  }

  scheduling_policy {
    preemptible = false # неПрерываемая
  }
}