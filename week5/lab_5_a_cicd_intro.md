# 🚀 Lab 5-A: Introduction to CI/CD with Azure

## 🌟 Objectives

- Understand the principles of Continuous Integration (CI) and Continuous Deployment (CD)
- Explore CI/CD tools provided by Azure: GitHub Actions, Azure DevOps, Deployment Center
- Set up a GitHub repository with a simple application
- Create a resource group to manage CI/CD resources
- Explore CI/CD options in Azure App Service Deployment Center
- Deploy using Portal, CLI, and ARM
- Validate App Service and GitHub integration post-deployment

---

## 🧰 Requirements

- GitHub account
- Access to [Azure Portal](https://portal.azure.com)
- Azure CLI installed and authenticated (`az login`)
- Basic Git and command-line knowledge

---

## 👣 Lab Instructions

### 1️⃣ Understand CI/CD in Azure

- **Continuous Integration (CI)**: Automatically builds and tests code on every push to a shared repository
- **Continuous Deployment (CD)**: Automatically deploys the app after successful build/test
- In Azure, CI/CD is supported by:
  - GitHub Actions
  - Azure DevOps Pipelines
  - App Service Deployment Center

---

### 2️⃣ Create a GitHub Repository with Application Code

#### 🌐 GitHub Portal:

1. Log in to [https://github.com](https://github.com)
2. Click **+ New repository**
3. Fill in:
   - **Repository name**: `azure-cicd-sample`
   - **Description**: "Sample app for CI/CD with Azure"
   - Choose **Public** or **Private**
   - ✅ Check **Initialize with a README.md**
4. Click **Create repository**

#### 📋 Local Terminal:

```bash
git clone https://github.com/<your-username>/azure-cicd-sample.git
cd azure-cicd-sample
echo "Hello Azure CI/CD!" > index.html
git add .
git commit -m "Initial commit"
git push origin main
```

✅ GitHub repository is ready for CI/CD integration.

---

### 3️⃣ Create a Resource Group for CI/CD Projects

#### 📋 Azure CLI:

```bash
az group create --name lab5-rg --location australiaeast
```

✅ Resource group created for Lab 5 infrastructure.

---

### 4️⃣ Deploy App Service (Portal, CLI, ARM)

#### 🔢 Azure Portal:

1. Search **App Services** → Click **+ Create**
2. Fill in:
   - **Resource Group**: `lab5-rg`
   - **Name**: `lab5app-<yourname>`
   - **Publish**: Code
   - **Runtime stack**: Node.js 18 LTS
   - **Region**: Australia East
3. Click **Review + Create** → **Create**

#### 📋 Azure CLI:

```bash
az appservice plan create \
  --name lab5-plan \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku B1

az webapp create \
  --resource-group lab5-rg \
  --plan lab5-plan \
  --name lab5app<yourname> \
  --runtime "NODE|18-lts"
```

#### 🪡 ARM Template Snippet:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "lab5-plan",
      "location": "australiaeast",
      "sku": {
        "name": "B1",
        "tier": "Basic",
        "capacity": 1
      },
      "properties": {}
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-03-01",
      "name": "lab5app<yourname>",
      "location": "australiaeast",
      "dependsOn": [
        "Microsoft.Web/serverfarms/lab5-plan"
      ],
      "properties": {
        "serverFarmId": "lab5-plan",
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
  --template-file lab5app-deploy.json
```

---

### 5️⃣ Explore Deployment Center

#### 🔢 Azure Portal:

1. Go to your new **App Service**
2. Select **Deployment Center** in the left menu
3. Review CI/CD integration options:
   - GitHub
   - Azure Repos
   - Bitbucket
   - Local Git/ZIP

✅ These enable automated builds and deployments.

---

### 6️⃣ Post-Deployment Validation

#### 🔢 Azure CLI:

```bash
az webapp show \
  --name lab5app<yourname> \
  --resource-group lab5-rg \
  --query "defaultHostName"
```

Visit: `https://<result>` in your browser ✅

Confirm: App Service is accessible and serving content.

---

## ✅ Lab Complete

You successfully created a GitHub repo, deployed an App Service using Portal/CLI/ARM, explored Deployment Center, and validated post-deployment CI/CD readiness.

