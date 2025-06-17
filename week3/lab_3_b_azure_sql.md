# 🗃️ Lab 3-B: Deploy Azure SQL Database

## 🎯 Objective

- Understand Azure SQL deployment structure (server + database)
- Deploy a SQL database using Portal and Azure CLI
- Configure firewall rules for client access
- Connect using Query Editor and VS Code
- Learn about pricing tiers, backup, and connectivity options

---

## 🧰 Requirements

- Active Azure Subscription
- Azure CLI v2.38.0+
- Access to [https://portal.azure.com](https://portal.azure.com)
- Visual Studio Code with **SQL Server (mssql)** extension
- Firewall allowing your public IP address

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group

#### 🔹 Azure Portal:

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search: **Resource Groups** → Click **+ Create**
3. Fill in:
   - Subscription: Default
   - Resource Group: `lab3b-rg`
   - Region: `Australia East`
4. Click **Review + Create** → **Create**

#### 🖥️ Azure CLI:

```bash
az group create --name lab3b-rg --location australiaeast
```

✅ Resource group created.

---

### 2️⃣ Create an Azure SQL Database

#### 🔹 Azure Portal:

1. Search: **SQL Database** → Click **+ Create**
2. **Basics tab**:
   - Resource Group: `lab3b-rg`
   - Database name: `lab3b-sqldb`
   - Server: **Create new**
     - Name: `lab3b-sqlserver-<unique>`
     - Admin login: `sqladmin`
     - Password: `MySecurePassword123!`
     - Region: `Australia East`
3. **Configure database**: Choose `Basic` or `General Purpose: Serverless`
4. Click **Review + Create** → **Create**

#### 🖥️ Azure CLI:

```bash
# Create logical server
az sql server create \
  --name lab3b-sqlserver-cli \
  --resource-group lab3b-rg \
  --location australiaeast \
  --admin-user sqladmin \
  --admin-password MySecurePassword123!

# Create SQL database
az sql db create \
  --name lab3b-sqldb-cli \
  --resource-group lab3b-rg \
  --server lab3b-sqlserver-cli \
  --service-objective Basic
```

✅ SQL Server and Database deployed.

---

### 3️⃣ Configure Server Firewall

#### 🔹 Azure Portal:

1. Go to SQL Database → Click linked **Server name**
2. In the left menu, click **Networking**
3. Click **+ Add client IP** → **Save** ✅ Allows current IP access.

#### 🖥️ Azure CLI:

```bash
az sql server firewall-rule create \
  --resource-group lab3b-rg \
  --server lab3b-sqlserver-cli \
  --name AllowMyIP \
  --start-ip-address <your-ip> \
  --end-ip-address <your-ip>
```

✅ Now the database is accessible from your machine.

---

### 4️⃣ Connect Using Query Editor

#### 🔹 Azure Portal:

1. Open your SQL Database → Click **Query Editor (Preview)**
2. Login:
   - Username: `sqladmin`
   - Password: `MySecurePassword123!`
3. Run:

```sql
SELECT name, create_date FROM sys.databases;
```

✅ Confirms database exists.

---

### 5️⃣ Connect Using VS Code (Real-World Method)

#### 🧰 Setup:

1. Open **VS Code** → Go to **Extensions** → Install **SQL Server (mssql)**
2. Press `Ctrl + Shift + P` → Select **MS SQL: Connect**
3. Fill in:
   - Server: `lab3b-sqlserver-cli.database.windows.net`
   - Database: `lab3b-sqldb-cli`
   - Auth Type: SQL Login
   - User: `sqladmin`
   - Password: `MySecurePassword123!`

#### ✅ Test Query:

```sql
SELECT name FROM sys.databases;
```

You’ll see the database in results.

---

✔️ **Lab complete – you deployed an Azure SQL Server and Database, configured firewall access, and connected using both the Portal and VS Code.**

