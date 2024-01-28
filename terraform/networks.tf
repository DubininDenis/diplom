
resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_security_group" "webservers" {
  name        = "webservers"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "ANY"
    port = 22
      v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol       = "ANY"
    port = 10050
      v4_cidr_blocks = ["10.10.0.0/16"]
  }
  
  ingress {
    protocol       = "ANY"
    port = 5601
      v4_cidr_blocks = ["10.10.0.0/16"]
  }
  
  ingress {
    protocol       = "ANY"
    port = 9200
      v4_cidr_blocks = ["192.168.3.0/24"]
  }

  ingress {
    protocol       = "ANY"
    port = 80
      v4_cidr_blocks = ["0.0.0.0/16"]
  }

  egress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "elastic" {
  name        = "elastic"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "ANY"
    port = 22
      v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol       = "ANY"
    port = 9200
      v4_cidr_blocks = ["192.168.1.0/16"]
      v4_cidr_blocks = ["192.168.2.0/16"]
  }

  ingress {
    protocol       = "ANY"
    port = 10050
      v4_cidr_blocks = ["10.10.0.0/16"]
  }
  
  egress {
    protocol       = "ANY"
    port = 9200
      v4_cidr_blocks = ["10.10.0.0/16"]
  }
}

resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix-server" {
  name        = "zabbix_server"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "bastion" {
  name        = "bastion"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol       = "ANY"
    port = 22
      v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_subnet" "subnet_1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet_3" {
  name           = "subnet3"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.3.0/24"]
}

resource "yandex_vpc_subnet" "subnet_4" {
  name           = "subnet4"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.10.0.0/16"]
}