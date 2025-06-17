# 🛠️ Lab 5-B: Create a CI/CD Pipeline with Azure DevOps

## 🎯 Objectives

- Set up a CI/CD pipeline using Azure DevOps Pipelines
- Connect a GitHub repository to the pipeline
- Create a build definition using YAML or Classic Designer
- Deploy a sample application to Azure App Service
- Automatically trigger the pipeline on code pushes

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

#### 🌐 Azure Portal:

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

#### 💻 Azure CLI:

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
4. Select **Starter pipeline** or choose a template
5. Replace YAML with your pipeline config
6. Click **Save and run**
7. Commit the YAML file to your GitHub repo

✅ The pipeline will now trigger and deploy your app.

---

### 4️⃣ Configure Service Connection to Azure

1. In Azure DevOps → Go to **Project Settings** → **Service Connections**
2. Click **+ New service connection** → Choose **Azure Resource Manager**
3. Select **Service Principal (automatic)**
4. Pick your subscription
5. Name it: `AzureCICDConnection`
6. Click **Verify and Save**

✅ Now your pipeline can authenticate with Azure.

---

### 5️⃣ View Pipeline Runs and Logs

1. In Azure DevOps → Go to **Pipelines → Runs**
2. Click your latest run
3. Expand logs:
   - Node.js installation
   - Build
   - Deploy

✅ Confirm all steps passed (green check marks).

---

### 6️⃣ (Optional) Test Access to the Deployed App

#### 💻 Azure CLI:

```bash
az webapp show \
  --name devops-demo-app \
  --resource-group lab5-rg \
  --query defaultHostName \
  --output tsv
```

✅ Visit the output URL in your browser.

---

✔️ **Lab complete – you created a CI/CD pipeline using Azure DevOps that deploys your web app from GitHub to Azure App Service.**

