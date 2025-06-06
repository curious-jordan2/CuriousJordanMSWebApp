variable "application" {
	description = "The application name for the deployment."
	type        = string
	default     = "ExampleApp"
	validation {
	condition     = length(var.application) > 2
	error_message = "The application name must be longer than two characters."
	}
}

variable "local_os" {
	description = "The local operating system where Terraform is running"
	type        = string
	default     = "windows"

	validation {
    condition     = contains(["windows", "linux"], var.local_os)
    error_message = "local_os must be either 'windows' or 'linux'."
	}
}


variable "image" {
	description = "The Docker image to use for the container"
	type        = string
	default     = "ubuntu:20.04"

	validation {
    condition = contains([
		"ubuntu:20.04",
		"ubuntu:22.04",
		"mcr.microsoft.com/windows/servercore:ltsc2025",
		"mcr.microsoft.com/windows/servercore:ltsc2022",
		"mcr.microsoft.com/windows/servercore:ltsc2019"
    ], var.image)
    error_message = "The image must be one of: ubuntu:20.04, ubuntu:22.04, mcr.microsoft.com/windows/servercore:ltsc2025, mcr.microsoft.com/windows/servercore:ltsc2022, or mcr.microsoft.com/windows/servercore:ltsc2019"
	}
}

variable "container_name" {
	description = "The container name for the deployment."
	type        = string
	default     = "example_container_name"
	validation {
	condition     = length(var.container_name) > 2
	error_message = "The container name must be longer than two characters."
	}
}

variable "external_port" {
	description = "The externally facing port."
	type = number
	default = 8000
}