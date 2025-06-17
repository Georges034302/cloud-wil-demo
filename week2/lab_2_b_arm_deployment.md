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
- **Bicep CLI** installed (`bicep --version`)
- **Azure CLI** installed
- **Visual Studio Code** with **Bicep extension** (recommended)

---

## 👣 Lab Instructions

### 1️⃣ Author `azuredeploy.json` for Web App

📝 **What is it?** An ARM template (JSON format) that defines the structure and configuration of your Azure resources.

🔹 **Resources defined:**

- **App Service Plan**
  - Controls pricing tier (e.g., Free, Premium)
  - Allocates compute resources
- **Web App**
  - Hosting platform for websites and APIs
  - Auto-linked to App Service Plan

💡 **Why important?**

- Enables **Infrastructure as Code (IaC)**
- Avoids manual portal setup
- Makes deployments repeatable and version-controlled
- Familiarizes you with Azure's native JSON syntax

---

### 2️⃣ Create `azuredeploy.parameters.json`

📁 This file defines values like `location` and `webAppName` to pass into the ARM template.

📝 **Tip:** Replace the default value (e.g., `hms-web-portal-1234`) with a **globally unique name**:

- Lowercase
- No spaces
- Alphanumeric only

✅ Required for parameterized, reusable deployment templates.

---

### 3️⃣ Deploy via Azure Portal

🔸 **Steps:**

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. Search for **"Deploy a custom template"**
3. Select **Template deployment (Deploy using custom template)**
4. Click **Build your own template in the editor**
5. Paste in content from `azuredeploy.json`
6. Click **Save**
7. Enter:
   - **Resource Group**: Create or select one (e.g., `lab2b-rg`)
   - **Location**: Australia East
   - **Web App Name**: Globally unique
8. Click **Review + Create → Create**

✅ Wait for confirmation on deployment screen.

---

### 4️⃣ Deploy via Azure CLI

🧪 Ensure you are signed in:

```bash
az login
```

🔸 **Create Resource Group:**

```bash
az group create --name lab2b-rg --location australiaeast
```

🔸 **Deploy ARM Template:**

```bash
az deployment group create \
  --resource-group lab2b-rg \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

✅ CLI will confirm with `"provisioningState": "Succeeded"`

---

### 5️⃣ Verify in Azure Portal

🔍 **Check Resource Group:**

- Navigate to **Resource groups** → `lab2b-rg`

✅ You should see:

- **App Service Plan** named like `hms-web-portal-1234-plan`
- **Web App** named like `hms-web-portal-1234`

🧪 **Test the Web App:**

1. Click on the Web App
2. Visit its default URL (e.g., `https://hms-web-portal-1234.azurewebsites.net`)
3. Explore tabs: **Configuration**, **SSL**, **Logs**

✅ You've successfully deployed a Web App using an ARM template!

---

✔️ **Lab complete – you’ve used native JSON ARM templates to define and deploy cloud infrastructure using both the Portal and CLI.**

