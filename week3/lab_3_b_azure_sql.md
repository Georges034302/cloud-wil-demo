# 🗃️ Lab 3-B: Deploy Azure SQL Database using CLI, Portal, and ARM

## 🎯 Objective

- Understand Azure SQL deployment structure (server + database)
- Deploy a SQL database using Portal, CLI, and ARM template
- Configure firewall rules for public access
- Connect using Query Editor and VS Code
- Learn about pricing tiers and connectivity

---

## 🧰 Requirements

- Azure Subscription (Free or Pay-As-You-Go)
- **Azure CLI** v2.38.0+
- **Access to Azure Portal**
- **Visual Studio Code** with **SQL Server (mssql)** extension

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group

#### 🔹 Azure CLI:

```bash
az group create --name lab3b-rg --location australiaeast
```

#### 🔹 Azure Portal:

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search for **Resource Groups** → **+ Create**
3. Resource Group: `lab3b-rg`
4. Region: `Australia East` → **Review + Create** → **Create**

---

### 2️⃣ Deploy Azure SQL Database

#### 🔹 Azure CLI:

```bash
# Create SQL logical server
az sql server create \
  --name lab3b-sqlserver-cli \
  --resource-group lab3b-rg \
  --location australiaeast \
  --admin-user sqladmin \
  --admin-password MySecurePassword123!

# Create SQL database
az sql db create \
  --resource-group lab3b-rg \
  --server lab3b-sqlserver-cli \
  --name lab3b-sqldb-cli \
  --service-objective Basic
```

#### 🔹 Azure Portal:

1. Search **SQL databases** → **+ Create**
2. Basics tab:
   - Resource Group: `lab3b-rg`
   - Database name: `lab3b-sqldb`
   - Server: **Create new**: `lab3b-sqlserver-<unique>`
     - Admin: `sqladmin`, Password: `MySecurePassword123!`
     - Region: `Australia East`
3. Pricing Tier: Choose **Basic** or **General Purpose: Serverless**
4. Review + Create → Create

✅ Server and DB are now provisioned.

---

### 3️⃣ Configure SQL Firewall Access

#### 🔹 Azure CLI:

```bash
az sql server firewall-rule create \
  --resource-group lab3b-rg \
  --server lab3b-sqlserver-cli \
  --name AllowMyIP \
  --start-ip-address <your-ip> \
  --end-ip-address <your-ip>
```

#### 🔹 Azure Portal:

1. Go to SQL Database → Linked Server
2. Click **Networking**
3. Click **+ Add client IP** → **Save**

✅ Your IP address is now allowed to connect.

---

### 4️⃣ Connect Using Portal Query Editor

1. Navigate to SQL Database → Click **Query Editor (Preview)**
2. Login:
   - Username: `sqladmin`
   - Password: `MySecurePassword123!`
3. Query:

```sql
SELECT name, create_date FROM sys.databases;
```

✅ Confirms access and visibility.

---

### 5️⃣ Connect Using Visual Studio Code

1. Open **VS Code** → Extensions → Install **SQL Server (mssql)**
2. Press `Ctrl+Shift+P` → **MS SQL: Connect**
3. Fill:
   - Server: `lab3b-sqlserver-cli.database.windows.net`
   - Database: `lab3b-sqldb-cli`
   - Auth: SQL Login → User: `sqladmin`, Pass: `MySecurePassword123!`

Run:

```sql
SELECT name FROM sys.databases;
```

✅ You should see your database listed.

---

### 6️⃣ Deploy SQL via ARM Template

#### 🔹 `sql-db-deploy.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "serverName": { "type": "string" },
    "adminUser": { "type": "string" },
    "adminPassword": { "type": "securestring" },
    "databaseName": { "type": "string" },
    "location": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.Sql/servers",
      "apiVersion": "2021-11-01-preview",
      "name": "[parameters('serverName')]",
      "location": "[parameters('location')]",
      "properties": {
        "administratorLogin": "[parameters('adminUser')]",
        "administratorLoginPassword": "[parameters('adminPassword')]"
      }
    },
    {
      "type": "Microsoft.Sql/servers/databases",
      "apiVersion": "2021-11-01-preview",
      "name": "[format('{0}/{1}', parameters('serverName'), parameters('databaseName'))]",
      "location": "[parameters('location')]",
      "properties": {},
      "dependsOn": [
        "[resourceId('Microsoft.Sql/servers', parameters('serverName'))]"
      ]
    }
  ]
}
```

#### 🔹 `sql-db-deploy.parameters.json`

```json
{
  "parameters": {
    "serverName": { "value": "lab3b-sqlserver-arm" },
    "adminUser": { "value": "sqladmin" },
    "adminPassword": { "value": "MySecurePassword123!" },
    "databaseName": { "value": "lab3b-sqldb-arm" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab3b-rg \
  --template-file sql-db-deploy.json \
  --parameters @sql-db-deploy.parameters.json
```

✅ SQL Server and DB deployed using ARM.

---

### 7️⃣ Post-Deployment Testing

#### ✅ Check resources:

```bash
az sql server show --name lab3b-sqlserver-cli --resource-group lab3b-rg
az sql db show --name lab3b-sqldb-cli --server lab3b-sqlserver-cli --resource-group lab3b-rg
```

#### ✅ Confirm firewall rule:

```bash
az sql server firewall-rule list --server lab3b-sqlserver-cli --resource-group lab3b-rg
```

#### ✅ Test login via VS Code or Portal Query Editor:

Run:

```sql
SELECT name FROM sys.databases;
```

✅ Response confirms authentication and database availability.

---

## ✅ Lab Complete

You’ve deployed Azure SQL Database using CLI, Portal, and ARM templates, configured secure firewall access, and validated connection via the portal and Visual Studio Code.

