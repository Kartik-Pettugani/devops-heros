# AWS Virtual Private Cloud (VPC) - Networking

## 🌐 What is VPC?
Amazon Virtual Private Cloud (VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define.

---

## 🔌 Core VPC Networking Components

### 1. CIDR Block
Classless Inter-Domain Routing block defining the IP address range allocated to the VPC (e.g. `10.0.0.0/16`).

### 2. Subnets
A range of IP addresses in your VPC:
- **Public Subnet**: Connected to Internet Gateway; instances receive public IPs.
- **Private Subnet**: Isolated from public internet; routes outbound traffic via NAT Gateway.

### 3. Route Tables
A set of rules (routes) used to determine where network traffic from your subnet or gateway is directed.

### 4. Gateways
- **Internet Gateway (IGW)**: Allows bi-directional communication between public subnet resources and the internet.
- **NAT Gateway**: Enables instances in a private subnet to connect to the internet while blocking inbound connections from the internet.

### 5. Security Groups vs Network ACLs
- **Security Group**: Stateful firewall operating at instance level.
- **Network ACL**: Stateless subnet-level firewall acting as a defense line for controlling traffic in/out of subnets.
