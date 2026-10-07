# AWS Elastic Compute Cloud (EC2) - Compute

## 💻 What is EC2?
Amazon EC2 provides scalable compute capacity in the AWS Cloud, allowing users to launch virtual servers (instances) on demand without upfront hardware investments.

---

## ⚙️ Core EC2 Concepts

### 1. Amazon Machine Image (AMI)
Pre-configured virtual machine template containing an OS (Ubuntu, Amazon Linux 2023, Windows), application server, and software packages.

### 2. Instance Types
Varying combinations of CPU, Memory, Storage, and Networking capacity tailored to workload needs:
- **General Purpose**: `t3.micro`, `m5.large` (Balanced CPU/RAM)
- **Compute Optimized**: `c6i.xlarge` (High CPU workloads)
- **Memory Optimized**: `r6i.large` (In-memory caches, databases)

### 3. Key Pairs
Public-key cryptography mechanism used to securely authenticate SSH connections to Linux EC2 instances.

### 4. Security Groups
Virtual stateful firewalls controlling inbound and outbound traffic rules at the instance ENI level.

### 5. Elastic Block Store (EBS)
Persistent block storage volumes attached to EC2 instances (e.g. `gp3`, `io2`).

### 6. Public vs Private IP
- **Public IP**: Routable over the internet, assigned dynamically or via Elastic IP.
- **Private IP**: Internal non-routable IP address used within the VPC subnet scope.

---

## 🔄 EC2 Instance Lifecycle
`Pending` ➔ `Running` ➔ `Stopping` ➔ `Stopped` ➔ `Terminated`
