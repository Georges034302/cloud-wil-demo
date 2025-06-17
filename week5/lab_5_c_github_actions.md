# ⚙️ Lab 5-C: Automate Deployment with GitHub Actions

## 🎯 Objectives

- Understand GitHub Actions for CI/CD
- Build and deploy a web app to Azure App Service using GitHub Actions
- Securely store publish profile credentials as secrets
- Automate deployment on every push to `main` branch
- Compare GitHub Actions with Azure DevOps Pipelines

---

## 🧰 Requirements

- GitHub account and local Git installed
- Azure CLI and access to [Azure Portal](https://portal.azure.com)
- Existing or new App Service (e.g., `gh-actions-demo-app`)

---

## 👣 Lab Instructions

### 1️⃣ Create Azure App Service (If Not Already Created)

#### 🌐 Azure Portal:

1. Go to Azure Portal → **Create a resource**
2. Search: **Web App**
3. Configure:
   - **Name**: `gh-actions-demo-app`
   - **Runtime**: Node.js 18 LTS (or your preferred stack)
   - **Region**: Australia East
   - **Resource Group**: `lab5-rg`
4. Click **Review + Create** → **Create**

#### 💻 Azure CLI:

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

✅ Web App is ready for deployment.

---

### 2️⃣ Get and Store the Publish Profile

#### 🌐 Azure Portal:

1. Go to **App Services** → `gh-actions-demo-app`
2. Click **Deployment Center**
3. Scroll to **Get publish profile** → Click to **Download**
4. Open the downloaded `.PublishSettings` file
5. Copy all contents

#### 🌐 GitHub:

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
4. Value: Paste contents of the `.PublishSettings` file
5. Click **Add secret**

✅ Deployment credentials stored securely.

---

### 3️⃣ Add GitHub Actions Workflow

#### 💻 Local Terminal:

```bash
mkdir -p .github/workflows
nano .github/workflows/deploy.yml
```

Paste this content:

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

#### 💻 Commit and Push:

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions deployment"
git push origin main
```

✅ Workflow is now triggered on every push to `main`.

---

### 4️⃣ Monitor Workflow Run

#### 🌐 GitHub:

1. Go to your repo → **Actions** tab
2. Click the latest workflow run
3. Review logs for:
   - Code checkout
   - Build
   - Azure deployment

✅ Confirm status: ✅ Success

---

### 5️⃣ Confirm App Deployment

Visit: `https://gh-actions-demo-app.azurewebsites.net`

You should see the deployed app (e.g., your `index.html` content).

---

### 6️⃣ (Optional) Test CI/CD Trigger

1. Edit any file (e.g., `index.html`)
2. Commit and push:

```bash
git commit -am "Update home page"
git push
```

✅ This triggers another workflow and redeploys the app.

---

✔️ **Lab complete – GitHub Actions now builds and deploys your app automatically to Azure App Service on every code push.**

