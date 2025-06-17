# 🧱 Lab 5-D: Define Infrastructure with ARM Templates

## 🎯 Objectives

- Understand the structure and purpose of ARM (Azure Resource Manager) templates
- Define Azure infrastructure declaratively using JSON
- Deploy resources using both Azure Portal and Azure CLI
- Parameterize templates for reuse across environments
- Validate and troubleshoot deployments using CLI and Portal output

---

## 🧰 Requirements

- Azure CLI installed and authenticated (`az login`)
- Code editor (VS Code recommended)
- Azure subscription
- Resource group: `lab5-rg`

---

## 👣 Lab Instructions

### 1️⃣ Understand ARM Template Structure

An ARM template is a declarative JSON file with the following sections:

- **\$schema**: URL for ARM schema definition
- **contentVersion**: Template version
- **parameters**: Dynamic input values (e.g., names)
- **resources**: Azure resources to create
- **outputs** *(optional)*: Values returned after deployment (e.g., IP, URLs)

---

### 2️⃣ Create a Sample ARM Template

Create a file named `azuredeploy.json` with the following contents:

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

✅ This template creates a Storage Account using a parameterized name.

---

### 3️⃣ (Optional) Create Parameters File

Create a file named `azuredeploy.parameters.json`:

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

✅ This allows flexible deployments by separating logic and values.

---

### 4️⃣ Deploy Template Using Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Deploy a custom template**
3. Click **Build your own template in the editor**
4. Paste the contents of `azuredeploy.json`
5. Click **Save**, then configure:
   - **Resource Group**: `lab5-rg`
   - **Storage Account Name**: `lab5storage1234`
6. Click **Review + Create** → **Create**

✅ Storage Account will be deployed based on the template.

---

### 5️⃣ Deploy Template Using Azure CLI

Run the following command from your working directory:

```bash
az deployment group create \
  --resource-group lab5-rg \
  --template-file azuredeploy.json \
  --parameters azuredeploy.parameters.json
```

✅ Deployment output will show provisioning status and results.

---

### 6️⃣ Verify the Deployment

#### 💻 Azure CLI:

```bash
az resource list \
  --resource-group lab5-rg \
  --output table
```

✅ Confirms the deployed storage account exists and matches parameters.

#### 🌐 Azure Portal:

1. Go to **Resource groups** → `lab5-rg`
2. Locate the Storage Account created
3. Confirm name, region, and configuration

---

✔️ **Lab complete – you defined and deployed Azure infrastructure using ARM templates with reusability and validation in mind.**

