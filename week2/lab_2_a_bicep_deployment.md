# ⚙️ Lab 2-A: Define Azure Resources Using Bicep and Deploy with ARM Templates

## 🎯 Objective

- Understand Bicep syntax and ARM template structure
- Define Azure App Service and Azure SQL Database using modular Bicep files
- Transpile Bicep to ARM JSON templates
- Use a parameters file for deployment customization
- Deploy templates using both Azure CLI and Azure Portal
- Verify successful deployment in the Azure Portal

---

## 🧰 Requirements

- Azure subscription with **Contributor** access
- **Azure CLI** installed (`az version`)
- **Bicep CLI** installed (`az bicep install`)
- **Visual Studio Code** with **Bicep extension**

---

## 👣 Lab Instructions

### 1️⃣ Environment Setup

🛠️ **Install Tools:**
- Install **Azure CLI**: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
- Install **Bicep CLI**:
```bash
az bicep install
```
- Check installations:
```bash
az version
bicep --version
```
- Open **VS Code** → Install Bicep Extension

---

### 2️⃣ Create a Resource Group

#### 🔹 Azure CLI:
```bash create RG
az group create --name lab2a-rg --location australiaeast
```

#### 🔹 Azure Portal:
1. Go to **Azure Portal** → **Resource groups**
2. Click **+ Create**
3. Name: `lab2a-rg`, Region: `Australia East`
4. Click **Review + create** → **Create**

---

### 3️⃣ Assign IAM Role (Contributor)

#### 🔹 Azure CLI:
```bash
az role assignment create \
  --assignee <your-user-email> \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>/resourceGroups/lab2a-rg
```

#### 🔹 Azure Portal:
1. Go to **Resource Groups** → `lab2a-rg`
2. Click **Access Control (IAM)** → **+ Add** → **Add role assignment**
3. Role: **Contributor** → Assign access to: **User** → Select your user
4. Click **Review + assign**

---

### 4️⃣ Understand ARM Templates

Explore [ARM Samples Gallery](https://learn.microsoft.com/en-us/samples/browse/?expanded=azure&products=azure-resource-manager)

📌 Key Sections in Templates:
- `parameters`, `variables`, `resources`, `outputs`

📘 Bicep simplifies the same definitions:
- No nested JSON
- Reusable and more readable

📝 Reflection: Why use declarative templates for provisioning?

---

### 5️⃣ Define Resources Using Bicep

#### 🔹 `web.bicep` – App Service
```bicep
param webAppName string
param location string

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${webAppName}-plan'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: plan.id
  }
}
```

#### 🔹 `sql.bicep` – SQL Server + Database
```bicep
param sqlServerName string
param sqlAdmin string
@secure()
param sqlPassword string
param location string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlPassword
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServerName}/sampledb'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    sampleName: 'AdventureWorksLT'
    sku: {
      name: 'S0'
      tier: 'Standard'
    }
  }
}
```

---

### 6️⃣ Transpile Bicep to ARM JSON

#### 🔹 Azure CLI:
```bash
bicep build web.bicep
bicep build sql.bicep
```
✅ Generates:
- `web.json`
- `sql.json`

---

### 7️⃣ Create Parameters File

#### 🔹 `parameters.json`:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "parameters": {
    "webAppName": { "value": "demo-webapp-unique" },
    "location": { "value": "australiaeast" },
    "sqlServerName": { "value": "demosqlserveruniq" },
    "sqlAdmin": { "value": "adminuser" },
    "sqlPassword": { "value": "YourP@ssw0rd123" }
  }
}
```

✅ Ensure all parameter names match your `.bicep` files exactly.

---

### 8️⃣ Deploy Templates

#### 🔹 Azure CLI:
```bash
az deployment group create \
  --resource-group lab2a-rg \
  --template-file web.json \
  --parameters @parameters.json

az deployment group create \
  --resource-group lab2a-rg \
  --template-file sql.json \
  --parameters @parameters.json
```

#### 🔹 Azure Portal:
1. Go to **Resource groups** → `lab2a-rg`
2. Click **Deployments** → **+ Add** → **Template deployment**
3. Select **Build your own template** → Paste in contents of `web.json`
4. Click **Save** → Upload `parameters.json`
5. Click **Review + create** → Repeat for `sql.json`

---

### 9️⃣ Verify in Azure Portal

✅ Navigate to `lab2a-rg`:
- Confirm **App Service Plan** and **Web App** are deployed
- Confirm **SQL Server** and **SQL Database** are available
- Test Web App URL
- View **Deployments** and **Activity logs**

---

## 📂 Recommended Folder Structure

```
lab-2a-bicep-deployment/
├── web.bicep
├── sql.bicep
├── parameters.json
├── web.json     # Transpiled
├── sql.json     # Transpiled
└── deploy.sh    # Optional automation script
```

#### 🔹 `deploy.sh` Script (Optional):
```bash
#!/bin/bash
RG="lab2a-rg"
PARAMS="parameters.json"

az deployment group create \
  --resource-group $RG \
  --template-file web.json \
  --parameters @$PARAMS

az deployment group create \
  --resource-group $RG \
  --template-file sql.json \
  --parameters @$PARAMS
```

---

## ✅ Lab Complete

You've defined, parameterized, transpiled, and deployed Azure infrastructure using Bicep, ARM templates, Azure CLI, and Portal. Well done!

