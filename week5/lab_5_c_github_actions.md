# ⚙️ Lab 5-C: Automate Python App Deployment with GitHub Actions

## 🌟 Objectives

- Create a GitHub Actions CI/CD workflow for a Python app
- Automatically deploy on push to `main` using Azure App Service
- Use secrets for secure authentication
- Validate deployment using CLI

---

## 🛠️ Requirements

| Requirement         | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| ✅ GitHub repository | Same repo used in Lab 5-B, containing `joke-api.py`          |
| ✅ Azure CLI         | Installed and authenticated (`az login`)                     |
| ✅ GitHub CLI        | Installed and authenticated using PAT (see Lab A)            |
| ✅ `.env` file       | Contains `APP_NAME`, `RG_NAME`, and is added to `.gitignore` |
| ✅ GitHub Secrets    | Contains `APP_NAME`, `AZURE_CREDENTIALS`                     |

---

## 👣 Lab Instructions

### 1️⃣ Create GitHub Actions Workflow

```bash
# From the root of your GitHub repo
mkdir -p .github/workflows
touch .github/workflows/deploy.yml
```

Paste the following:

```yaml
name: Deploy Python App to Azure App Service

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

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Zip application
        run: zip -r app.zip .

      - name: Log in to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Web App
        uses: azure/webapps-deploy@v2
        with:
          app-name: ${{ secrets.APP_NAME }}
          package: app.zip

```

Commit and push:

```bash
git add .
git commit -m "GitHub Actions workflow for Python App"
git push origin main
```

---

### 2️⃣ Monitor GitHub Actions Workflow

1. Go to your repo → **Actions** tab
2. Click the latest run
3. Inspect steps: Checkout → Setup Python → Install → Deploy

✅ Confirm that all steps complete successfully.

---

### 3️⃣ Validate the Deployed App

```bash
az webapp show \
  --name "$APP_NAME" \
  --resource-group "$RG_NAME" \
  --query defaultHostName \
  --output tsv
```

✅ Visit `https://$APP_NAME.azurewebsites.net/joke` in your browser. You should see a random joke in JSON format.

---

## ✅ Lab Complete

- ⚙️ Created a GitHub Actions CI/CD workflow for Python app deployment
- 📥 Checked out code and installed Python dependencies via GitHub Actions
- 🗜️ Packaged the app using zip before deployment
- 🚀 Deployed the Python app to Azure App Service automatically on push to main
- 🔐 Used GitHub Secrets (AZURE_CREDENTIALS, APP_NAME) to authenticate securely
- 🧪 Validated the deployed app at the /joke
