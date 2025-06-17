# 🚀 Lab 5-A: Introduction to CI/CD with Azure

## 🎯 Objectives

- Understand the principles of Continuous Integration (CI) and Continuous Deployment (CD)
- Explore CI/CD tools provided by Azure: GitHub Actions, Azure DevOps, Deployment Center
- Set up a GitHub repository with a simple application
- Create a resource group to manage CI/CD resources
- Explore CI/CD options in Azure App Service Deployment Center
- Prepare foundational components for Labs 5-B to 5-F

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

#### 💻 Local Terminal:

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

#### 💻 Azure CLI:

```bash
az group create --name lab5-rg --location australiaeast
```

✅ Resource group created for Lab 5 infrastructure.

---

### 4️⃣ Deploy App and Explore Deployment Center

#### 🌐 Azure Portal:

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. Search **App Services** → Click **+ Create**
3. In the **Basics** tab:
   - **Subscription**: Choose your active subscription
   - **Resource Group**: `lab5-rg`
   - **Name**: `lab5app-<yourname>`
   - **Publish**: Code
   - **Runtime stack**: Node.js 18 LTS (or your preference)
   - **Region**: Australia East
4. Click **Next → Deployment → Next → Review + Create → Create**

✅ App Service deployed.

#### Explore Deployment Center:

1. Go to your new **App Service**
2. Click **Deployment Center** from the left menu
3. Review available options:
   - GitHub
   - Azure Repos
   - Bitbucket
   - Local Git/ZIP

🔁 Each option enables:

- Automated builds on code push
- Optional custom build steps
- Continuous delivery to App Service

✅ You’ve explored how App Service integrates with CI/CD workflows.

---

### 5️⃣ (Optional) Set Up Azure DevOps Organization

1. Navigate to [https://dev.azure.com](https://dev.azure.com)
2. Sign in with your Microsoft account
3. Click **+ New Organization** (if needed)
4. Choose a name like `AzureCICDOrg`
5. Create a project:
   - **Name**: `CI-CD-Demo`
   - **Version control**: Git
   - **Work item process**: Basic

✅ Azure DevOps environment is now ready.

---

✔️ **Lab complete – you’ve created a GitHub repo, deployed an App Service, and explored Azure-native CI/CD tools to support modern DevOps workflows.**

