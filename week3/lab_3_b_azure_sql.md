# 📃️ Lab 3-B: Deploy Azure SQL Database using CLI, Portal, and ARM

## 🌟 Objective

- Provision an Azure SQL Database
- Configure firewall rules for secure access
- Connect using Azure Cloud Shell, VS Code, or Docker (sqlcmd)
- Understand pricing tiers and connectivity methods

---

## 🧰 Requirements

- Azure Subscription (Free or Pay-As-You-Go)
- **Azure CLI** v2.38.0+
- **Access to Azure Portal**
- **Visual Studio Code** (optional) with **SQL Server (mssql)** extension
- **Docker** (optional) or MySQL Workbench with ODBC driver

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group and SQL Server

#### 🔹 Azure CLI:

```bash
az group create --name sql-demo-rg --location australiaeast

read -s -p "🔑 Enter a strong password for the SQL admin account: " SQL_PASSWORD

az sql server create \
  --name studentsqlserver123 \
  --resource-group sql-demo-rg \
  --location australiaeast \
  --admin-user sqladmin \
  --admin-password "$SQL_PASSWORD"

az sql db create \
  --resource-group sql-demo-rg \
  --server studentsqlserver123 \
  --name studentdb \
  --service-objective Basic
```

#### 🔹 Azure Portal:

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search for **SQL databases** → **+ Create**
3. Basics tab:
   - Resource Group: `sql-demo-rg`
   - Database name: `studentdb`
   - Server: **Create new** → Name: `studentsqlserver123`, Admin: `sqladmin`, Password: enter secure password
   - Location: `Australia East`
4. Pricing Tier: **Basic**
5. Review + Create → Create

✅ Server and DB are now provisioned.

---

### 2️⃣ Configure SQL Firewall Access

#### 🔹 Azure CLI:

```bash
az sql server firewall-rule create \
  --resource-group sql-demo-rg \
  --server studentsqlserver123 \
  --name allow-local-ip \
  --start-ip-address <your-ip> \
  --end-ip-address <your-ip>

# Optional: open wide public access (demo only)
# --start-ip-address 0.0.0.0 \
# --end-ip-address 255.255.255.255
```

#### 🔹 Azure Portal:

1. Go to SQL Server → Networking
2. Click **+ Add client IP** → Save

✅ Your IP is now whitelisted.

---

### 3️⃣ Connect to SQL Database

#### 🐳 Option 1: Docker (sqlcmd)

```bash
docker run -it --rm mcr.microsoft.com/mssql-tools \
  /opt/mssql-tools/bin/sqlcmd -S studentsqlserver123.database.windows.net -U sqladmin -d studentdb
```

📌 For scripting (avoid hardcoding passwords):

```bash
docker run -it --rm mcr.microsoft.com/mssql-tools \
  /opt/mssql-tools/bin/sqlcmd -S studentsqlserver123.database.windows.net -U sqladmin -P 'YourPassword' -d studentdb
```

🔗 [Install sqlcmd](https://learn.microsoft.com/sql/tools/sqlcmd-utility)

#### 🧰 Option 2: Visual Studio Code

1. Install **SQL Server (mssql)** extension
2. Press `Ctrl+Shift+P` → **MS SQL: Connect**
3. Fill in:
   - Server: `studentsqlserver123.database.windows.net`
   - Database: `studentdb`
   - Authentication: SQL Login
   - Username: `sqladmin`
   - Password: Your secure password

#### 🧰 Option 3: MySQL Workbench (via ODBC)

1. Install **ODBC Driver 18 for SQL Server**
2. Add **System DSN**:
   - Server: `studentsqlserver123.database.windows.net`
   - Auth: SQL Login
   - Encrypt: Yes, Trust Cert: No
3. Connect in Workbench using DSN

---

### 4️⃣ Post-Deployment Testing

After connection, run:

```sql
SELECT DB_NAME();
GO

CREATE TABLE students (
  id INT PRIMARY KEY,
  name NVARCHAR(100),
  enrolled_date DATE
);
GO

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

INSERT INTO students (id, name, enrolled_date)
VALUES (1, 'Alice Smith', '2024-06-01');
GO

SELECT * FROM students;
GO
```

✅ Confirms creation, insert, and read access.

---

### 5️⃣ Deploy SQL via ARM Template (Optional)

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
    "serverName": { "value": "studentsqlserver-arm" },
    "adminUser": { "value": "sqladmin" },
    "adminPassword": { "value": "MySecurePassword123!" },
    "databaseName": { "value": "studentdb-arm" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 Deploy via CLI:

```bash
az deployment group create \
  --resource-group sql-demo-rg \
  --template-file sql-db-deploy.json \
  --parameters @sql-db-deploy.parameters.json
```

✅ SQL Server and DB deployed using ARM.

---

### 6️⃣ Resources Cleanup 

```bash
az group delete --name sql-demo-rg --yes --no-wait
```

---

## ✅ Lab Complete

You’ve successfully deployed and accessed Azure SQL Database using CLI, Portal, Docker, and optionally VS Code or MySQL Workbench!

