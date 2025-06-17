# 🌍 Lab 3-C: Provision and Explore Azure Cosmos DB

## 🎯 Objective

- Understand Azure Cosmos DB and its supported workloads
- Create a Cosmos DB account using Portal and CLI
- Create a database and container
- Insert and query JSON documents
- Explore indexing, throughput, and scaling

---

## 🧰 Requirements

- Active Azure subscription
- Access to [https://portal.azure.com](https://portal.azure.com)
- Azure CLI v2.38.0 or higher

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com) → Search for **Resource groups**
2. Click **+ Create**
3. Fill in:
   - Resource group: `lab3c-rg`
   - Region: `Australia East`
4. Click **Review + Create** → **Create**

#### 🖥️ Azure CLI:

```bash
az group create --name lab3c-rg --location australiaeast
```

✅ Resource group ready.

---

### 2️⃣ Create a Cosmos DB Account (SQL API)

#### 🔹 Azure Portal:

1. Search for **Azure Cosmos DB** → Click **+ Create**
2. Select **Core (SQL)**
3. Fill in:
   - Resource Group: `lab3c-rg`
   - Account name: `lab3c-cosmos-<unique>` (lowercase + globally unique)
   - Region: `Australia East`
   - Capacity mode: Provisioned throughput
   - Apply free tier: ✅ if available
4. Click **Review + Create** → **Create**

#### 🖥️ Azure CLI:

```bash
az cosmosdb create \
  --name lab3ccosmoscli \
  --resource-group lab3c-rg \
  --locations regionName=australiaeast \
  --default-consistency-level Session \
  --kind GlobalDocumentDB \
  --enable-free-tier true
```

✅ Cosmos DB account created.

---

### 3️⃣ Create Database and Container

#### 🔹 Azure Portal:

1. Go to Cosmos DB account → **Data Explorer** → **New Container**
2. Fill in:
   - Database ID: `lab3c-db`
   - Container ID: `lab3c-container`
   - Partition Key: `/id`
   - Throughput: 400 RU/s (default)
3. Click **OK**

#### 🖥️ Azure CLI:

```bash
# Create DB
az cosmosdb sql database create \
  --account-name lab3ccosmoscli \
  --name lab3c-db \
  --resource-group lab3c-rg

# Create container
az cosmosdb sql container create \
  --account-name lab3ccosmoscli \
  --database-name lab3c-db \
  --name lab3c-container \
  --partition-key-path "/id" \
  --throughput 400
```

✅ Database and container provisioned.

---

### 4️⃣ Insert JSON Documents

#### 🔹 Azure Portal:

1. In **Data Explorer**, expand `lab3c-db` → `lab3c-container`
2. Click **Items** → **+ New Item**
3. Paste this:

```json
{
  "id": "1",
  "name": "Ada Lovelace",
  "role": "Mathematician",
  "contribution": "First algorithm"
}
```

Click **Save**

4. Repeat with another document:

```json
{
  "id": "2",
  "name": "Grace Hopper",
  "role": "Computer Scientist",
  "contribution": "COBOL language"
}
```

Click **Save**

🛑 **Note:** CLI does not support document insertion — use Portal.

---

### 5️⃣ Query Documents with SQL

#### 🔹 Azure Portal:

1. Still in Data Explorer, click **New SQL Query**
2. Run:

```sql
SELECT c.name, c.contribution FROM c WHERE c.role = "Mathematician"
```

✅ Returns Ada Lovelace.

🛑 **Note:** Azure CLI does not support SQL query directly — use Portal or SDKs.

---

### 6️⃣ Explore Indexing, Throughput, and Global Scaling

#### 🔹 Azure Portal:

1. From Cosmos DB account → use the left-hand menu to explore:

🔸 **Scale & Settings**:

- View/adjust throughput (e.g., scale from 400 to 1000 RU/s)

🔸 **Indexing Policy**:

- View default automatic indexing
- Optionally exclude fields or enable composite indexes

🔸 **Replicate Data Globally**:

- Add regions like Southeast Asia
- Set failover priority

🔸 **Metrics**:

- Track RU usage, latency, throttled requests
- Tune configuration based on real usage

#### 🖥️ Azure CLI:

```bash
# Scale throughput
az cosmosdb sql container throughput update \
  --account-name lab3ccosmoscli \
  --database-name lab3c-db \
  --name lab3c-container \
  --throughput 1000

# Add a read region
az cosmosdb failover-priority-change \
  --account-name lab3ccosmoscli \
  --resource-group lab3c-rg \
  --failover-policies australiaeast=0 southeastasia=1
```

✅ Explore indexing and metrics via Portal only.

---

✔️ **Lab complete – you provisioned an Azure Cosmos DB account, created a container, inserted/query documents, and explored performance, indexing, and scaling options.**

