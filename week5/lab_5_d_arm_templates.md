# 🧱 Lab 5-D: Deploy Python App with ARM Template via GitHub Actions

## 🌟 Objectives

- Define Azure infrastructure using an ARM template for App Service
- Deploy a Python web app using GitHub Actions
- Use `AZURE_CREDENTIALS` secret to authenticate CI pipeline
- Validate end-to-end CI/CD using Infrastructure as Code (IaC)

---

## 🛠️ Requirements

| Requirement         | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| ✅ GitHub repository | Python app from Lab 5-B (with `joke-api.py`)                |
| ✅ Azure CLI         | Installed and authenticated (`az login`)                    |
| ✅ GitHub CLI        | Installed and authenticated using PAT (Lab 5-A)             |
| ✅ `.env` file       | Contains `APP_NAME`, `RG_NAME`, and is in `.gitignore`      |
| ✅ GitHub Secrets    | Includes `APP_NAME` and `AZURE_CREDENTIALS` for CI          |

---

## 📁 Project Structure

```bash
# From the root of your GitHub repo
mkdir -p .github/workflows
nano .github/workflows/deploy-arm.yml
```

Final file layout:

```bash
📁 your-repo/
├── joke-api/
│   ├── joke-api.py
│   ├── requirements.txt
│   └── azuredeploy.json
└── .github/
    └── workflows/
        └── deploy-arm.yml
```

---

## 📄 ARM Template (joke-api/azuredeploy.json)

Save this inside the `joke-api` folder:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appName": {
      "type": "string"
    },
    "planName": {
      "type": "string"
    },
    "location": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "[parameters('planName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "F1",
        "tier": "Free"
      },
      "properties": {
        "reserved": true
      }
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-03-01",
      "name": "[parameters('appName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', parameters('planName'))]"
      ],
      "properties": {
        "serverFarmId": "[parameters('planName')]",
        "siteConfig": {
          "linuxFxVersion": "PYTHON|3.11"
        }
      }
    }
  ]
}
```

---

## 🤖 GitHub Actions Workflow (.github/workflows/deploy-arm.yml)

Save this to `.github/workflows/deploy-arm.yml`:

```yaml
name: Deploy Python App using ARM

on:
  push:
    branches: ["main"]

jobs:
  deploy-python-app:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r joke-api/requirements.txt

      - name: Login to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy Infrastructure with ARM
        uses: azure/arm-deploy@v1
        with:
          scope: resourceGroup
          resourceGroupName: ${{ secrets.RG_NAME }}
          template: joke-api/azuredeploy.json
          parameters: >-
            appName=${{ secrets.APP_NAME }} 
            planName=plan-${{ secrets.APP_NAME }} 
            location=australiaeast

      - name: Zip Python App
        run: zip -r app.zip joke-api

      - name: Deploy App Code
        uses: azure/webapps-deploy@v2
        with:
          app-name: ${{ secrets.APP_NAME }}
          publish-profile: ${{ secrets.AZURE_CREDENTIALS }}
          package: app.zip
```

---

## ✅ Lab Complete

You have:

- 🧱 Defined infrastructure using a parameterized ARM template
- 🤖 Created a GitHub Actions workflow to deploy App Service
- 🐍 Packaged and deployed a Python web app via CI
- 🔐 Authenticated using secure GitHub Secrets
- ✅ Achieved full infrastructure and application automation

