# AWS Identity and Access Management (IAM) - Governance

## 🔑 What is IAM?
AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources. IAM enables centralized management of permissions and identities.

---

## 🏗️ Core IAM Components

### 1. IAM Users
An entity created in AWS representing a person or workload (e.g. `manohar-admin`). Users possess long-term credentials (password, Access Keys).

### 2. IAM Groups
A collection of IAM users. Groups allow administrators to specify permissions for multiple users simultaneously (e.g. `DevOpsEngineers`, `DBAdmins`).

### 3. IAM Roles
An identity with specific permissions that can be temporarily assumed by a user, application, or AWS service (e.g. `EC2-S3-Access-Role`). Roles issue short-term temporary security credentials via AWS STS.

### 4. Policies
JSON documents defining permissions (Allowed or Denied actions on specific AWS resource ARNs).
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::production-app-bucket/*"]
    }
  ]
}
```

### 5. Principle of Least Privilege
Granting only the absolute minimum permissions necessary for an identity to complete its designated job tasks, preventing unintended access or security breaches.

---

## 🎯 IAM Best Practices
- Lock root account with MFA and refrain from using root for daily operational tasks.
- Assign permissions to Groups or Roles rather than individual IAM users.
- Rotate IAM access keys regularly.
- Enforce strong password complexity rules.
