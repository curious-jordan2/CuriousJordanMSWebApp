variable "application" {
	description = "The application name for the deployment."
	type        = string
	default     = "ExampleApp"
	validation {
		condition = length(var.application) > 2 && length(var.application) < 12
		error_message = "Length of app name must be greater than 2 and less than 12 characters."
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
		], var.location)
		error_message = "The region must be one of the allowed US regions: eastus, eastus2, centralus, northcentralus, southcentralus, westus, westus2, westus3."
		}
}

variable "environment" {
	description = "Environment of application deployment."
	type = string
	validation {
		condition = contains([
		"p",
		"np",
		"s",
		"d"
		], var.environment)
		error_message = "Provide an environment for this deployment."
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