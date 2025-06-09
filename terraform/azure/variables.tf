variable "application" {
	description = "The application name for the deployment."
	type        = string
	default     = "Hello"
	validation {
	condition     = length(var.application) > 2
	error_message = "The application name must be longer than two characters."
	}
}


variable "location" {
	description = "The Azure region to deploy resources into."
	type        = string

	validation {
		condition = contains([
		"eastus",
		"eastus2",
		"centralus",
		"northcentralus",
		"southcentralus",
		"westus",
		"westus2",
		"westus3"
		], var.region)
		error_message = "The region must be one of the allowed US regions: eastus, eastus2, centralus, northcentralus, southcentralus, westus, westus2, westus3."
		}
}

variable "resource_group_name" {
	default = "example-rg"
}

variable "vm_name" {
	default = "example-vm"
	validation {
		condition = length(var.vm_name) > 2 && length(var.vm_name) < 14
		error_message = "Length of vm name must be greater than 2 and less than 14 characters."
	}
}

variable "admin_username" {
	default = "azureuser"
}

variable "admin_password" {
	description = "Admin password must meet Azure complexity requirements"
	type        = string
	sensitive   = true
}