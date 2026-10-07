# AWS Simple Storage Service (S3) - Object Storage

## 🪣 What is S3?
Amazon S3 is an object storage service offering industry-leading scalability, data availability, security, and performance. Store and retrieve any amount of data from anywhere.

---

## 🛠️ Key S3 Concepts

### 1. Buckets & Objects
- **Bucket**: Top-level container for stored data. Bucket names must be globally unique across all AWS accounts.
- **Object**: File data plus metadata (key-value pair, max single object size 5TB).

### 2. Storage Classes
- **S3 Standard**: High durability, low latency access for frequently accessed data.
- **S3 Intelligent-Tiering**: Automatic cost savings by moving objects between access tiers.
- **S3 Standard-IA / One Zone-IA**: Lower cost for infrequently accessed data.
- **S3 Glacier Flexible / Deep Archive**: Ultra-low-cost long-term archival data.

### 3. Versioning & Encryption
- **Versioning**: Preserves, retrieves, and restores every version of objects stored in your bucket.
- **Encryption**: Server-Side Encryption (SSE-S3, SSE-KMS) automatically encrypts objects at rest.

### 4. Lifecycle Policies
Rules defined to transition objects automatically to cheaper storage tiers or expire old object versions after a specified timeframe.
