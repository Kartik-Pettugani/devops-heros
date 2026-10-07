# AWS Database Services: DynamoDB & RDS

## ⚡ DynamoDB (NoSQL Database)
Amazon DynamoDB is a fully managed, serverless, key-value NoSQL database designed for single-digit millisecond performance at any scale.

### Core Concepts
- **Tables, Items & Attributes**: Similar to SQL tables, rows, and columns.
- **Partition Key & Sort Key**: Composite primary key schema allowing fast indexed queries.
- **Use Cases**: Real-time gaming leaderboards, shopping carts, session management.

---

## 🗄️ Relational Database Service (RDS)
Amazon RDS makes it easy to set up, operate, and scale a relational database in the cloud.

### Supported Database Engines
- PostgreSQL, MySQL, MariaDB, Oracle, SQL Server, and Amazon Aurora.

### High Availability Features
- **Multi-AZ Deployment**: Synchronous physical replication across Availability Zones for high availability and automatic failover.
- **Read Replicas**: Asynchronous read-only instances offloading read traffic from primary DB.
- **Automated Backups & Snapshots**: Automated point-in-time recovery.
