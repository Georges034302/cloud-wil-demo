# 🛠️ Lab 5-B: Create a CI/CD Pipeline with Azure DevOps

## 🎯 Objectives

- Set up a CI/CD pipeline using Azure DevOps Pipelines
- Connect a GitHub repository to the pipeline
- Create a build definition using YAML or Classic Designer
- Deploy a sample application to Azure App Service
- Automatically trigger the pipeline on code pushes
- Implement steps using Portal, CLI, and ARM (where applicable)
- Validate pipeline execution and deployment

---

## 🧰 Requirements

- Azure CLI installed and logged in (`az login`)
- GitHub repo with sample app code (`azure-cicd-sample`)
- Deployed App Service or permission to create one
- Access to [Azure Portal](https://portal.azure.com)
- Azure DevOps account ([https://dev.azure.com](https://dev.azure.com))

---

## 👣 Lab Instructions

### 1️⃣ Create an Azure App Service to Deploy To

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **Create a resource** → Search: **Web App**
3. Fill in the form:
   - **Subscription**: Your active subscription
   - **Resource group**: `lab5-rg`
   - **Name**: `devops-demo-app`
   - **Publish**: Code
   - **Runtime stack**: Node.js 18 LTS
   - **Region**: Australia East
4. Click **Review + Create** → **Create**

✅ App Service ready for deployment.

#### 📋 Azure CLI:

```bash
az appservice plan create \
  --name devops-plan \
  --resource-group lab5-rg \
  --sku FREE \
  --is-linux

az webapp create \
  --resource-group lab5-rg \
  --plan devops-plan \
  --name devops-demo-app \
  --runtime "NODE|18-lts"
```

✅ App Service created via CLI.

#### 🪡 ARM Template Snippet:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "devops-plan",
      "location": "australiaeast",
      "sku": {
        "name": "F1",
        "tier": "Free",
        "capacity": 1
      },
      "properties": {
        "reserved": true
      }
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-03-01",
      "name": "devops-demo-app",
      "location": "australiaeast",
      "dependsOn": [
        "Microsoft.Web/serverfarms/devops-plan"
      ],
      "properties": {
        "serverFarmId": "devops-plan",
        "siteConfig": {
          "linuxFxVersion": "NODE|18-lts"
        }
      }
    }
  ]
}
```

Deploy with:

```bash
az deployment group create \
  --resource-group lab5-rg \
  --template-file appservice-devops.json
```

---

### 2️⃣ Set Up Azure DevOps Project

1. Go to [https://dev.azure.com](https://dev.azure.com)
2. Create a new organization if prompted
3. Click **+ New Project**
   - **Name**: `CI-CD-Demo`
   - **Visibility**: Private
   - **Version control**: Git
4. Click **Create Project**

✅ DevOps project ready.

---

### 3️⃣ Link GitHub Repository to Azure Pipelines

1. In Azure DevOps project, go to **Pipelines** → Click **Create Pipeline**
2. Choose **GitHub** and authorize access
3. Select your repo: `azure-cicd-sample`
4. Choose **Starter pipeline** or **YAML file from repo**
5. Replace YAML content with:

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '18.x'
    displayName: 'Install Node.js'

  - script: |
      echo "Building app"
      ls
    displayName: 'Build Script'

  - task: AzureWebApp@1
    inputs:
      azureSubscription: 'AzureCICDConnection'
      appName: 'devops-demo-app'
      package: '.'
```

6. Click **Save and run** → Commit to `main`

✅ Pipeline will execute.

---

### 4️⃣ Configure Azure Service Connection in DevOps

1. In Azure DevOps → Go to **Project Settings** → **Service Connections**
2. Click **+ New service connection** → Choose **Azure Resource Manager**
3. Select **Service Principal (automatic)**
4. Pick your subscription and scope
5. Name it: `AzureCICDConnection`
6. Click **Verify and Save**

✅ Pipeline has Azure access.

---

### 5️⃣ View Pipeline Execution & Logs

1. Azure DevOps → Pipelines → Runs
2. Click latest run
3. Review logs for:
   - Node install
   - App build
   - Web App deploy

✅ All steps should pass with green check marks.

---

### 6️⃣ Post-Deployment Validation

#### 📋 Azure CLI:

```bash
az webapp show \
  --name devops-demo-app \
  --resource-group lab5-rg \
  --query defaultHostName \
  --output tsv
```

✅ Visit the resulting URL to confirm app is running.

---

## ✅ Lab Complete

You successfully created a CI/CD pipeline using Azure DevOps, linked it with GitHub, configured Azure access, deployed an App Service using Portal, CLI, and ARM, and validated deployment via pipeline logs and app availability.

