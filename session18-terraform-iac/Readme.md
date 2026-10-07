# Session 18: Terraform & Infrastructure as Code (IaC)

Welcome to Session 18! This module covers Infrastructure as Code using HashiCorp Terraform alongside deep-dive architectural research on core AWS services (IAM, EC2, S3, VPC, DynamoDB, RDS).

---

## 📁 Directory Structure

```text
Session-18_Terraform_IaC/
├── terraform-s3-demo/      # Task 1: Complete Terraform S3 bucket project
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── README.md
├── aws-services/           # Task 2: Core AWS Cloud services architectural research
│   ├── 01-iam/README.md
│   ├── 02-ec2/README.md
│   ├── 03-s3/README.md
│   ├── 04-vpc/README.md
│   └── 05-dynamodb-rds/README.md
├── images/                 # Terminal output execution evidence
└── README.md               # Main Session index
```

---

## 📷 Command Output Evidence

### 1. Terraform Init, Validate & Plan
![Terraform Init Plan](images/terraform_init_plan_apply.png)

### 2. Terraform S3 Provisioning & Outputs
![Terraform Apply Output](images/terraform_s3_created.png)

### 3. Terraform Destroy Workflow
![Terraform Destroy](images/terraform_destroy.png)
