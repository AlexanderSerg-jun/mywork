//Описание провайдера
terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}
// Реквизиты провайдера
provider "yandex" {
    //токен, айди облака, айди директории и зона доступности. Все значения будут описываться в файле variables.tf
    token = var.access["token"]
    cloud_id = var.access["cloud_id"]
    folder_id = var.access["folder_id"]
    zone = var.access["zone"]
}

// 3 Виртуальные машины с gfs2. Добавляем новый ресурс yandex_compute_instance для уникальности имен используем {count.index +1}
resource "yandex_compute_instance" "psnodes" {
    name = "psnode-${count.index +1}"
    // атрибут count используется для создания нескольких экзепляров ресурсов . Все значения будут описываться в файле variables.tf
    count = var.data["count"]
    platform_id               = "standard-v1"
    hostname                  = "psnode-${count.index + 1}"
    
    //Установите значение true, если планируете изменять сетевые настройки, вычислительные ресурсы, диски или файловые хранилища ВМ с помощью Terraform
    allow_stopping_for_update = true //разрешение на остановку работы виртуальной машины для внесения изменений.
    // Описание мощностей сервера память и  ядра
    resources {
        core = 2
        memory = 2
    }
    boot_disk{
        initialize_params{
            image_id ="fd8p7vi5c5bbs2s5i67s"
            size = 10
            type = "network-ssd"
        }
    }
}
