# 🛠️ Lab 2-B: Create and Deploy an ARM Template for Provisioning Resources

## 🎯 Objective

- Define an Azure Web App using native ARM (JSON) templates
- Create a parameterized `azuredeploy.json` template
- Customize environment via `azuredeploy.parameters.json`
- Deploy the template using Azure Portal and CLI
- Verify Web App provisioning via Azure Portal

---

## 🧰 Requirements

- Azure subscription with **Contributor** access
- **Azure CLI** installed (`az version`)
- **Visual Studio Code** or equivalent editor

---

## 👣 Lab Instructions

### 1️⃣ Author `azuredeploy.json` for Web App

This is the ARM template that defines the infrastructure.

#### 🔹 `azuredeploy.json` (ARM Template):

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "webAppName": {
      "type": "string",
      "metadata": {
        "description": "Name of the Web App."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "australiaeast",
      "metadata": {
        "description": "Azure location"
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "[concat(parameters('webAppName'), '-plan')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "F1",
        "tier": "Free"
      },
      "properties": {}
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-03-01",
      "name": "[parameters('webAppName')]",
      "location": "[parameters('location')]",
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', concat(parameters('webAppName'), '-plan'))]"
      }
    }
  ]
}
```

---

### 2️⃣ Create `azuredeploy.parameters.json`

#### 🔹 Sample `azuredeploy.parameters.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "parameters": {
    "webAppName": {
      "value": "hms-web-portal-1234"
    },
    "location": {
      "value": "australiaeast"
    }
  }
}
```

📝 Ensure `webAppName` is globally unique (lowercase, no spaces).

---

### 3️⃣ Deploy via Azure Portal

#### 🔹 Steps:

1. Visit [Azure Portal](https://portal.azure.com)
2. Search: **Deploy a custom template** → Select **Template deployment (Deploy using custom template)**
3. Click **Build your own template in the editor**
4. Paste the contents of `azuredeploy.json`
5. Click **Save**
6. Fill in the form:
   - **Resource Group**: Create/select `lab2b-rg`
   - **Web App Name**: Provide unique name
   - **Location**: `Australia East`
7. Click **Review + Create** → **Create**

✅ Wait for deployment to complete.

---

### 4️⃣ Deploy via Azure CLI

#### 🔹 Ensure you are logged in:

```bash
az login
```

#### 🔹 Create Resource Group:

```bash
az group create --name lab2b-rg --location australiaeast
```

#### 🔹 Deploy ARM Template:

```bash
az deployment group create \
  --resource-group lab2b-rg \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

✅ Successful deployment will return `"provisioningState": "Succeeded"`

---

### 5️⃣ Verify in Azure Portal

#### 🔍 Check:

- Navigate to **Resource groups** → `lab2b-rg`
- Confirm:
  - App Service Plan named like `hms-web-portal-1234-plan`
  - Web App named like `hms-web-portal-1234`

#### 🧪 Test Web App:

1. Click the Web App
2. Copy the URL (e.g., `https://hms-web-portal-1234.azurewebsites.net`)
3. Open in browser

---

## 📂 Recommended Folder Structure

```
lab-2b-arm-deployment/
├── azuredeploy.json
├── azuredeploy.parameters.json
└── deploy.sh    # Optional script
```

#### 🔹 `deploy.sh` Script (Optional):

```bash
#!/bin/bash
RG="lab2b-rg"
PARAMS="azuredeploy.parameters.json"

az group create --name $RG --location australiaeast
az deployment group create \
  --resource-group $RG \
  --template-file azuredeploy.json \
  --parameters @$PARAMS
```

---

## ✅ Lab Complete

You've created and deployed Azure infrastructure using native JSON ARM templates through both CLI and Portal. Excellent work!

