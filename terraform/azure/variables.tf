# Declare all variables with types and descriptions
variable "vm_name" {
    type = string
    default = "WebAppVM"
    description = "Name for the Virtual Machine"
}

variable "admin_username" {
    type = string
    description = "Username for the Virtual Machine adminstrator"
}

variable "admin_password" {
    type = string
    description = "Password for the Virtual Machine adminstrator"
    sensitive = true
}

variable "dns_name_for_public_ip" {
    type = string
    description = "Unique DNS Name for the Public IP use to access the Virtual Machine"
}

variable "windows_os_version" {
    type = string
    default = "2022-datracenter-azure-edition"
    description = "The Windows version for the VM"
}

variable "vm_size" {
    type = string
    default = "Standard_B1s"
    description = "Size of the Virtual Machine"
}