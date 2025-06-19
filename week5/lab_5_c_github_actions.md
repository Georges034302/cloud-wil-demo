# ⚙️ Lab 5-C: Automate Deployment with GitHub Actions

## 🌟 Objectives

- Understand GitHub Actions for CI/CD
- Build and deploy a web app to Azure App Service using GitHub Actions
- Securely store publish profile credentials as secrets
- Automate deployment on every push to `main` branch
- Compare GitHub Actions with Azure DevOps Pipelines
- Implement steps using Portal, CLI, and ARM (where applicable)
- Validate GitHub Actions deployment

---

## 🛠️ Requirements

- GitHub account and local Git installed
- Azure CLI installed and authenticated (`az login`)
- Access to [Azure Portal](https://portal.azure.com)
- Existing or new App Service (e.g., `gh-actions-demo-app`)

---

## 👣 Lab Instructions

### 1️⃣ Create Azure App Service (Portal, CLI, ARM)

#### 🔢 Azure Portal:

1. Go to Azure Portal → **Create a resource**
2. Search: **Web App**
3. Configure:
   - **Name**: `gh-actions-demo-app`
   - **Runtime**: Node.js 18 LTS
   - **Region**: Australia East
   - **Resource Group**: `lab5-rg`
4. Click **Review + Create** → **Create**

#### 📋 Azure CLI:

```bash
az group create --name lab5-rg --location australiaeast

az appservice plan create \
  --name ghactions-plan \
  --resource-group lab5-rg \
  --sku FREE \
  --is-linux

az webapp create \
  --resource-group lab5-rg \
  --plan ghactions-plan \
  --name gh-actions-demo-app \
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
      "name": "ghactions-plan",
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
      "name": "gh-actions-demo-app",
      "location": "australiaeast",
      "dependsOn": [
        "Microsoft.Web/serverfarms/ghactions-plan"
      ],
      "properties": {
        "serverFarmId": "ghactions-plan",
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
  --template-file ghactions-appservice.json
```

---

### 2️⃣ Get and Store the Publish Profile

#### 🔢 Azure Portal:

1. Go to **App Services** → `gh-actions-demo-app`
2. Click **Deployment Center**
3. Scroll to **Get publish profile** → Download
4. Open `.PublishSettings` file
5. Copy full content

#### 👁️ GitHub Secrets:

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
4. Value: Paste the publish profile content

---

### 3️⃣ Add GitHub Actions Workflow

#### 📋 Create workflow file:

```bash
mkdir -p .github/workflows
nano .github/workflows/deploy.yml
```

Paste:

```yaml
name: Deploy Node App to Azure

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Build app
        run: npm run build || echo "No build script"

      - name: Deploy to Azure Web App
        uses: azure/webapps-deploy@v2
        with:
          app-name: gh-actions-demo-app
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
          package: .
```

Commit and push:

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions workflow"
git push origin main
```

---

### 4️⃣ Monitor Workflow

#### 🔢 GitHub:

1. Go to your repo → **Actions** tab
2. Click the latest run
3. Inspect logs: checkout, build, deploy

✅ Confirm workflow success.

---

### 5️⃣ Validate Deployed App

```bash
az webapp show \
  --name gh-actions-demo-app \
  --resource-group lab5-rg \
  --query defaultHostName \
  --output tsv
```

✅ Visit the resulting URL. App should load successfully.

---

### 6️⃣ Test CI/CD Trigger

```bash
echo "<h1>Updated!</h1>" >> index.html
git commit -am "Test GitHub Actions"
git push
```

✅ A new deployment should occur automatically.

---

## ✅ Lab Complete

You implemented a GitHub Actions CI/CD pipeline with secure secret storage, automated Azure App Service deployment via Portal, CLI, and ARM, and verified end-to-end automation on `main` pushes.

