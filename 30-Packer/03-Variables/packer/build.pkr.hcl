variable "my_secret" {
  default = "${env("ARM_CLIENT_SECRET")}"
}

variable "my_client" {
  default = "${env("ARM_CLIENT_ID")}"
}

variable "my_sub" {
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "my_tenant" {
  default = "${env("ARM_TENANT_ID")}"
}


source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "DevOps"
    task = "GoldenImageDeployment"
  }




  client_id       = var.my_client
  client_secret   = var.my_secret
  subscription_id = var.my_sub
  tenant_id       = var.my_tenant

  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "16.04-LTS"
  location                          = "East US"
  managed_image_name                = "my-apache-image-{{timestamp}}"
  managed_image_resource_group_name = "mycustomimages"
  os_type                           = "Linux"

  vm_size = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+env && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}
