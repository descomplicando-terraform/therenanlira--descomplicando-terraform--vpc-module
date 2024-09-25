# Descomplicando Terraform - VPC Module

## Description

This project contains a Terraform module for creating and managing a Virtual Private Cloud (VPC) on AWS. It is part of the "Descomplicando Terraform" series.

## Prerequisites

- Terraform v0.12 or later
- AWS CLI configured with appropriate credentials
- An AWS account

## Usage

1. Create a `main.tf` file in your project directory and include the module:

```hcl
module "vpc" {
  source = "git@github.com:descomplicando-terraform/therenanlira--descomplicando-terraform--vpc-module.git"
  
  # Add required variables here
}
```

1. Initiate and apply the Terraform configuration:

```sh
terraform init && terraform apply
```

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
