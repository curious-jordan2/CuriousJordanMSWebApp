When using the docker Terraform modules there are requirements prior to deploying.

# Requirements
    1. Configure backend for terraform.tfstate file.
    2. Review and update the erraform.tfvars with required variables
    3. Pull docker images that will be used. If executing on a Windows OS and using Windows OS images, you will need to enable "Hyper-V" and "Container" and switch docker to windows be windows containers.