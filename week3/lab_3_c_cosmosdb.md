# 🌍 Lab 3-C: Provision and Explore Azure Cosmos DB (CLI, Portal, ARM)

## 🌟 Objective

- Understand Azure Cosmos DB workloads
- Deploy Cosmos DB via CLI, Portal, and ARM
- Create a SQL API database and container
- Insert/query JSON documents
- Explore throughput, indexing, and replication

---

## 🧰 Requirements

- Azure Subscription (Free or Pay-As-You-Go)
- **Azure CLI** v2.38.0+
- **Access to Azure Portal**

---

## 👣 Lab Instructions

### 1️⃣ Create Resource Group

#### 🔹 Azure CLI:

```bash
az group create --name lab3c-rg --location australiaeast
```

#### 🚩 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com) → Search **Resource groups**
2. Click **+ Create**
3. Fill: `lab3c-rg`, Region: `Australia East` → Review + Create → Create

---

### 2️⃣ Create Cosmos DB Account (SQL API)

#### 🔹 Azure CLI:

```bash
az cosmosdb create \
  --name lab3ccosmoscli \
  --resource-group lab3c-rg \
  --locations regionName=australiaeast \
  --default-consistency-level Session \
  --kind GlobalDocumentDB \
  --enable-free-tier true
```

#### 🚩 Azure Portal:

1. Search **Azure Cosmos DB** → **+ Create**
2. Choose **Core (SQL)** API
3. Resource Group: `lab3c-rg`, Account name: `lab3c-cosmos-<unique>`
4. Region: `Australia East`, Free Tier: Enabled (if eligible)
5. Review + Create → Create

---

### 3️⃣ Create Database and Container

#### 🔹 Azure CLI:

```bash
az cosmosdb sql database create \
  --account-name lab3ccosmoscli \
  --name lab3c-db \
  --resource-group lab3c-rg

az cosmosdb sql container create \
  --account-name lab3ccosmoscli \
  --database-name lab3c-db \
  --name lab3c-container \
  --partition-key-path "/id" \
  --throughput 400
```

#### 🚩 Azure Portal:

1. Go to Cosmos DB → **Data Explorer**
2. Click **New Container**
3. Fill:
   - Database ID: `lab3c-db`
   - Container ID: `lab3c-container`
   - Partition Key: `/id`
   - Throughput: 400 RU/s
4. Click **OK**

---

### 4️⃣ Insert JSON Documents

#### 🚩 Azure Portal:

1. Go to `lab3c-db` > `lab3c-container` > **Items** > **+ New Item**
2. Paste:

```json
{
  "id": "1",
  "name": "Ada Lovelace",
  "role": "Mathematician",
  "contribution": "First algorithm"
}
```

Click **Save**

3. Insert second document:

```json
{
  "id": "2",
  "name": "Grace Hopper",
  "role": "Computer Scientist",
  "contribution": "COBOL language"
}
```

Click **Save**

❌ Note: CLI does not support item insertion.

---

### 5️⃣ Query Documents

#### 🚩 Azure Portal:

1. Go to **Data Explorer** > `lab3c-container`
2. Click **New SQL Query**, run:

```sql
SELECT c.name, c.contribution FROM c WHERE c.role = "Mathematician"
```

✔️ Returns Ada Lovelace.

---

### 6️⃣ Explore Indexing, Throughput & Scaling

#### 🚩 Azure Portal:

- **Scale & Settings**: Adjust RU/s (e.g. 1000)
- **Indexing Policy**: View/edit automatic indexes
- **Replicate Data Globally**: Add SE Asia, change priorities
- **Metrics**: Monitor RU, latency, throttling

#### 🔹 Azure CLI:

```bash
# Scale throughput
az cosmosdb sql container throughput update \
  --account-name lab3ccosmoscli \
  --database-name lab3c-db \
  --name lab3c-container \
  --throughput 1000

# Add failover region
az cosmosdb failover-priority-change \
  --account-name lab3ccosmoscli \
  --resource-group lab3c-rg \
  --failover-policies australiaeast=0 southeastasia=1
```

---

### 7️⃣ Deploy Cosmos DB via ARM Template

#### 🔹 `cosmosdb-deploy.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "accountName": { "type": "string" },
    "location": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.DocumentDB/databaseAccounts",
      "apiVersion": "2021-06-15",
      "name": "[parameters('accountName')]",
      "location": "[parameters('location')]",
      "kind": "GlobalDocumentDB",
      "properties": {
        "databaseAccountOfferType": "Standard",
        "locations": [
          { "locationName": "[parameters('location')]", "failoverPriority": 0 }
        ]
      }
    }
  ]
}
```

#### 🔹 `cosmosdb-deploy.parameters.json`

```json
{
  "parameters": {
    "accountName": { "value": "lab3c-cosmos-arm" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab3c-rg \
  --template-file cosmosdb-deploy.json \
  --parameters @cosmosdb-deploy.parameters.json
```

---

### 8️⃣ Post-Deployment Validation

#### ✅ CLI Checks:

```bash
az cosmosdb show \
  --name lab3ccosmoscli \
  --resource-group lab3c-rg \
  --query "documentEndpoint"
```

Returns URI: `https://lab3ccosmoscli.documents.azure.com:443/`

#### ✅ Portal Checks:

1. Go to **lab3c-rg** → Open Cosmos DB
2. Confirm **Data Explorer**, **Metrics**, and **Global Replication** are active
3. Run SQL query in Portal to verify documents

---

## ✅ Lab Complete

You deployed Cosmos DB using CLI, Portal, and ARM, created databases and containers, inserted/query documents, and explored performance, indexing, and replication features.

