# 🌌 Lab 3-C: Deploy and Query Azure Cosmos DB (SQL API)

## 🏟️ Objective

Provision an Azure Cosmos DB account using the Core (SQL) API, create a database and container, and perform queries using Azure Portal and Visual Studio Code.

---

## 🛠️ Prerequisites

- Azure Subscription
- Azure CLI (v2.38.0+)
- Access to Azure Portal
- Visual Studio Code with **Azure Databases** extension

---

## 👣 Lab Steps

### 1️⃣ Register Cosmos DB Provider (CLI)

Ensure the Cosmos DB resource provider is registered:

```bash
az provider register --namespace Microsoft.DocumentDB

az provider show --namespace Microsoft.DocumentDB --query "registrationState"
```

✅ Expected: `"Registered"`

---

### 2️⃣ Create Resource Group and Cosmos DB Account (CLI)

```bash
COSMOS_DB_NAME="lab3ccosmos$RANDOM"

az group create --name lab3c-rg --location australiaeast

az cosmosdb create \
  --name $COSMOS_DB_NAME \
  --resource-group lab3c-rg \
  --kind GlobalDocumentDB \
  --locations regionName=australiaeast failoverPriority=0 isZoneRedundant=False
```

---

### 3️⃣ Create Database and Container

#### 🔹 Azure CLI:

```bash
az cosmosdb sql database create \
  --account-name $COSMOS_DB_NAME \
  --resource-group lab3c-rg \
  --name studentsdb

az cosmosdb sql container create \
  --account-name $COSMOS_DB_NAME \
  --resource-group lab3c-rg \
  --database-name studentsdb \
  --name grades \
  --partition-key-path /studentId
```

#### 🚩 Azure Portal:

1. Go to **Azure Cosmos DB** → Your account
2. Click **Data Explorer** → **New Container**
3. Enter:
   - Database ID: `studentsdb` (create new)
   - Container ID: `grades`
   - Partition Key: `/studentId`
4. Click **OK**

---

### 4️⃣ Insert Documents

#### 📅 Azure Portal:

1. Navigate to **Data Explorer** → `studentsdb > grades` → **+ New Item**
2. Paste and save:

```json
{
  "id": "1",
  "studentId": "s1001",
  "name": "Ava Chen",
  "course": "Math",
  "grade": 88
}
```

3. Insert second document:

```json
{
  "id": "2",
  "studentId": "s1002",
  "name": "Ben Singh",
  "course": "Science",
  "grade": 76
}
```

#### 💻 Visual Studio Code (Alternative):

1. Install **Azure Databases** extension
2. Log in to Azure from the extension
3. Navigate to your Cosmos DB → `studentsdb > grades`
4. Right-click `grades` → **Create Document** → Paste JSON above
5. Use **Query** tab:

```sql
SELECT * FROM grades g WHERE g.grade > 80
```

✅ Results shown in VS Code

---

### 5️⃣ Query Documents via Portal

1. Open **Data Explorer** → `grades` → **New SQL Query**
2. Paste:

```sql
SELECT g.name, g.grade FROM grades g WHERE g.course = "Math"
```

Click **Execute**

---

### 6️⃣ Scale Throughput and Configure Replication (CLI) (Optional Task)

```bash
# Increase throughput to 1000 RU/s
az cosmosdb sql container throughput update \
  --account-name $COSMOS_DB_NAME \
  --resource-group lab3c-rg \
  --database-name studentsdb \
  --name grades \
  --throughput 1000

# Add a failover region (SE Asia)
az cosmosdb failover-priority-change \
  --account-name $COSMOS_DB_NAME \
  --resource-group lab3c-rg \
  --failover-policies australiaeast=0 southeastasia=1
```

---

### 7️⃣ Clean Up Resources 

```bash
az group delete --name lab3c-rg --yes --no-wait
```

---

## ✅ Lab Complete

You successfully provisioned a Cosmos DB account, created a database and container, inserted JSON documents, and executed queries using the Azure Portal and Visual Studio Code.

