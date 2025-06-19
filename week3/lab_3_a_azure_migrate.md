# 🚀 Lab 3-A: Explore Azure Migrate with CLI, Portal, and ARM Template

## 🎯 Objective

- Understand Azure Migrate’s purpose in cloud migration projects
- Explore Azure Migrate via Portal, CLI, and ARM
- Review tools for migrating servers, databases, and web apps
- Perform post-deployment validation

---

## 🧰 Requirements

- **Azure CLI** installed
- **Azure Portal access**
- **Free or Pay-As-You-Go subscription**

---

## 👣 Lab Instructions

### 1️⃣ Explore Azure Migrate via Azure Portal

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. In the search bar, type **Azure Migrate** and open the unified portal
3. Click **+ Create project**
4. In the form:
   - **Project name:** `migrate-lab-project`
   - **Geography:** `Australia East`
   - **Resource group:** Create new: `lab3a-rg`
5. **DO NOT** click final **Create** → this is simulation only

✅ Azure Migrate supports Servers, Databases, Web Apps, and VDI migration workflows.

---

### 2️⃣ Azure Migrate Project via CLI

#### 🔹 Create Resource Group:

```bash
az group create --name lab3a-rg --location australiaeast
```

#### 🔹 Create Azure Migrate Project:

```bash
az migrate project create \
  --resource-group lab3a-rg \
  --location australiaeast \
  --name migrate-lab-project
```

✅ This registers an Azure Migrate project in your subscription.

---

### 3️⃣ Azure Migrate via ARM Template

#### 🔹 `azuremigrate-project.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "projectName": { "type": "string" },
    "location": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.Migrate/projects",
      "apiVersion": "2020-05-01",
      "name": "[parameters('projectName')]",
      "location": "[parameters('location')]",
      "properties": {
        "projectStatus": "Active"
      }
    }
  ]
}
```

#### 🔹 `azuremigrate-project.parameters.json`

```json
{
  "parameters": {
    "projectName": { "value": "migrate-lab-project" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab3a-rg \
  --template-file azuremigrate-project.json \
  --parameters @azuremigrate-project.parameters.json
```

✅ This provisions a functional Azure Migrate project.

---

### 4️⃣ Explore Assessment and Migration Tools (Portal)

1. Go to **Azure Migrate** → Select your project → Review **Tiles**
2. Click **Servers** tab → see migration options for Hyper-V, VMware, and physical servers
3. Click **Databases** tab → see Data Migration Assistant & Azure DMS
4. Click **Web Apps** → view App Service Migration Assistant

---

### 5️⃣ Real-World Migration Scenarios

| Migration Type  | Tool                             |
| --------------- | -------------------------------- |
| On-prem VMs     | Azure Migrate Appliance          |
| SQL Server      | Azure Database Migration Service |
| Legacy Web Apps | App Service Migration Assistant  |

---

### 6️⃣ Post-Deployment Testing (Portal + CLI)

#### ✅ Check Project Exists:

```bash
az migrate project show \
  --resource-group lab3a-rg \
  --name migrate-lab-project \
  --query "name"
```

Expected Output:

```
"migrate-lab-project"
```

#### ✅ Confirm in Portal:

1. Go to **Resource Group** → `lab3a-rg`
2. You should see the Azure Migrate project
3. Open it → Confirm tabs (Servers, Databases, Web Apps) are available

#### ✅ Optional Query Project ID:

```bash
az migrate project show \
  --resource-group lab3a-rg \
  --name migrate-lab-project \
  --query id
```

Use this in scripts or for programmatic operations.

---

## ✅ Lab Complete

You’ve successfully explored Azure Migrate using Portal, CLI, and ARM Templates. You verified setup and explored real-world migration tools and scenarios.

