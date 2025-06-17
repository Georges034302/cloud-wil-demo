# ⚙️ Lab 2-A: Define Azure Resources Using Bicep and Deploy with ARM Templates

## 🎯 Objective

- Understand Bicep syntax and ARM template structure
- Define Azure App Service and Azure SQL Database using modular Bicep files
- Transpile Bicep to ARM JSON templates
- Use a parameters file for deployment customization
- Deploy templates with Azure CLI and verify in the portal

---

## 🧰 Requirements

- Azure subscription with **Contributor** access
- **Bicep CLI** installed (`bicep --version`)
- **Azure CLI** installed
- **Visual Studio Code** with **Bicep extension** (recommended)

---

## 👣 Lab Instructions

### 1️⃣ Environment Setup

🛠️ **Toolchain Setup:**
- Open **VS Code** → Go to **Extensions** → Install `Bicep`
- (Optional) Also install:
  - Azure CLI Tools
  - ARM Template Viewer
  - Azure Resource Manager Snippets

🖥️ **Open Terminal** (Ctrl + ~)

✅ **Install Azure CLI:**  
Follow [official guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
Check version:
```bash
az version
```

✅ **Install Bicep CLI:**
```bash
az bicep install
bicep --version
```

---

### 2️⃣ Create a Resource Group

🔸 **CLI Command:**
```bash
az group create --name lab2a-rg --location australiaeast
```

---

### 3️⃣ Assign IAM Role (Contributor)

🔸 **CLI - Check Access:**
```bash
az role assignment list --assignee <your-user-email> --output table
```

🔸 **CLI - Assign Role:**
```bash
az role assignment create \
  --assignee <your-user-email> \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>/resourceGroups/lab2a-rg
```

🔸 **Portal:**
1. Go to **lab2a-rg** → **Access control (IAM)**
2. Click **View my access**
3. If missing, click **+ Add** → **Add role assignment**
4. Role: **Contributor** → Assign access to: **User**
5. Select yourself/student → **Review + assign**

✅ You are now ready to define and deploy templates.

---

### 4️⃣ Understand ARM Templates

🔍 Explore structure of ARM templates and how Bicep simplifies them:
- Visit: [ARM Samples Gallery](https://learn.microsoft.com/en-us/samples/browse/?expanded=azure&products=azure-resource-manager)
- Focus: App Service + SQL Templates
- Sections to observe: `parameters`, `variables`, `resources`, `outputs`

📌 Bicep Benefits:
- No deep nesting
- No quotes
- Easier reuse and readability

📝 **Reflection Prompt:** Why are ARM templates important for provisioning?

---

### 5️⃣ Define Resources in Bicep

🔹 **Create modular Bicep files:**
- `web.bicep` → Define Web App
- `sql.bicep` → Define SQL Database

🧠 Keep templates clean, modular, and param-driven.

---

### 6️⃣ Transpile Bicep to ARM JSON

🔹 **Commands:**
```bash
bicep build web.bicep
bicep build sql.bicep
```
🔄 Output:
- `web.json`
- `sql.json`

📦 These are deployable ARM templates.

---

### 7️⃣ Use a Parameters File

🧾 A `.json` file with `parameters` that match the Bicep param blocks.

✅ **Why use it?**
- Separates logic from config
- Reusable across dev/test/prod
- Keeps infrastructure consistent

🔑 **Tips:**
- Names must match the Bicep param blocks exactly
- Quote all strings
- Use `@secure()` for sensitive fields like `sqlPassword`
- Use globally unique names (e.g., for Web App)

📌 Use with deployment:
```bash
--parameters @parameters.json
```

---

### 8️⃣ Deploy Templates

🔹 **Deploy with Azure CLI:** *(example shown – edit paths/names as needed)*
```bash
az deployment group create \
  --resource-group lab2a-rg \
  --template-file web.json \
  --parameters @parameters.json

az deployment group create \
  --resource-group lab2a-rg \
  --template-file sql.json \
  --parameters @parameters.json
```

---

### 9️⃣ Verify in Azure Portal

🔍 **Check:**
- Navigate to **Resource groups** → `lab2a-rg`
- Confirm:
  - App Service Plan and Web App are deployed
  - SQL Server and SQL Database are provisioned
- Test Web App via URL
- View **Deployments tab** → Activity logs

---

✅ **Lab complete – you’ve used Bicep and ARM to define, customize, and deploy Azure infrastructure!**

