terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.104.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id   = "b1g0ps03hmuj2hk53u6l"
  cloud_id    = "b1gb7qvi1poou9nq5pn0"
}

provider "yandex" {
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "G:/terraform/authorized_key.json"
  zone                     = "ru-central1-a"
}

