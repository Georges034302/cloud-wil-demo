# 🧱 Lab 5-D: Define Infrastructure with ARM Templates

## 🌟 Objectives

- Understand the structure and purpose of ARM (Azure Resource Manager) templates
- Define Azure infrastructure declaratively using JSON
- Deploy resources using Portal, CLI, and ARM
- Parameterize templates for reusability
- Validate and troubleshoot deployments using outputs and logs

---

## 🛠️ Requirements

- Azure CLI installed and authenticated (`az login`)
- Access to [Azure Portal](https://portal.azure.com)
- Code editor (e.g., VS Code)
- Existing Resource Group: `lab5-rg`

---

## 👣 Lab Instructions

### 1️⃣ Understand ARM Template Structure

An ARM template is a JSON file with:

- `$schema`: ARM schema definition
- `contentVersion`: Template version
- `parameters`: Dynamic inputs
- `resources`: Resources to provision
- `outputs`: Return values (optional)

---

### 2️⃣ Create a Sample ARM Template

Save this as `azuredeploy.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "minLength": 3,
      "maxLength": 24
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2022-09-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {}
    }
  ]
}
```

---

### 3️⃣ (Optional) Create a Parameters File

Save this as `azuredeploy.parameters.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "lab5storage1234"
    }
  }
}
```

---

### 4️⃣ Deploy Using Azure Portal

1. Visit [Azure Portal](https://portal.azure.com)
2. Search for **Deploy a custom template**
3. Click **Build your own template in the editor**
4. Paste `azuredeploy.json` contents
5. Click **Save**
6. Choose **Resource Group**: `lab5-rg`
7. Set **storageAccountName** to `lab5storage1234`
8. Click **Review + Create** → **Create**

✅ Resource deployed via portal

---

### 5️⃣ Deploy Using Azure CLI

```bash
az deployment group create \
  --resource-group lab5-rg \
  --template-file azuredeploy.json \
  --parameters azuredeploy.parameters.json
```

✅ CLI confirms provisioning status

---

### 6️⃣ Validate the Deployment

#### 📃 Azure CLI:

```bash
az resource list \
  --resource-group lab5-rg \
  --output table
```

✅ Should show `lab5storage1234`

#### 🌐 Azure Portal:

1. Go to **Resource groups** → `lab5-rg`
2. Find the Storage Account
3. Confirm name and configuration

---

## ✅ Lab Complete

You created a reusable ARM template, deployed it using Portal and CLI, and verified infrastructure using multiple tools.

