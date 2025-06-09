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
	validation {
		condition = (
		length(var.admin_password) >= 8 &&
		length(var.admin_password) <= 123 &&
		(
		(length(regexall("[A-Z]", var.admin_password)) > 0 ? 1 : 0) +
		(length(regexall("[a-z]", var.admin_password)) > 0 ? 1 : 0) +
		(length(regexall("[0-9]", var.admin_password)) > 0 ? 1 : 0) +
		(length(regexall("[!@#\\$%\\^&\\*\\(\\)_\\+\\[\\]\\{\\}\\|;:,.<>\\/?]", var.admin_password)) > 0 ? 1 : 0)
		) >= 3
		)
		error_message = "Password must be 8–123 characters and contain at least 3 of: uppercase, lowercase, number, special character."
	}
}