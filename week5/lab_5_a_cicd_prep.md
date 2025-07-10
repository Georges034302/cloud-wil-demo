# 🚀 Lab 5-A: Prepare GitHub and Azure for Secure CI/CD Deployment

## 🌟 Objectives

By the end of this lab, you will:

- Generate and store a GitHub PAT in a `.env` file  
- Authenticate GitHub CLI using the stored token  
- Create and configure an Azure service principal with proper permissions  
- Generate Azure credentials in JSON format  
- Store the credentials securely in GitHub repository secrets  
- Create an Azure resource group for deployment  

---

## 🧰 Prerequisites

| Requirement         | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| ✅ GitHub repository | Repo with `index.html` or app code (in `main` branch)                      |
| ✅ Azure CLI         | Installed and logged in (`az login`)                                       |
| ✅ GitHub CLI        | Installed (`gh`)                                                           |
| ✅ GitHub PAT        | Personal Access Token with `repo`, `workflow`, `admin:repo_hook` scopes   |
| ✅ Bash shell        | For scripting with env vars and CLI tools                                 |

---

## 👣 Step-by-Step Instructions

### 1️⃣ Generate GitHub PAT and Store in `.env`

1. Visit [https://github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**  
   - Name: `CI/CD Admin Token`
   - Expiration: 90 days
   - ✅ Scopes: `repo`, `workflow`, `admin:repo_hook`
3. Copy the token and store it in a `.env` file:

```bash
echo "ADMIN_TOKEN=ghp_xxxxxxxxxxxxxxxxx" >> .env
echo ".env" >> .gitignore
```

---

### 2️⃣ Install GitHub CLI (if not present)

```bash
sudo apt install gh -y
```

---

### 3️⃣ 🔐 Authenticate GitHub CLI using the PAT

```bash
source .env
unset GH_TOKEN GITHUB_TOKEN
gh auth logout --hostname github.com || true
echo "$ADMIN_TOKEN" | gh auth login --with-token --hostname github.com
```

---

### 4️⃣ 🔧 Prepare Azure Service Principal

#### 🔎 4.1 Get Subscription & Tenant IDs

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)
```

#### 🆔 4.2 Create or Reuse Service Principal

```bash
SP_NAME="gh-actions-sp"
APP_ID=$(az ad sp list --display-name "$SP_NAME" --query "[0].appId" -o tsv || true)

if [[ -z "$APP_ID" ]]; then
  echo "🆕 Creating new service principal: $SP_NAME"
  APP_ID=$(az ad app create --display-name "$SP_NAME" --query appId -o tsv)
  az ad sp create --id "$APP_ID"
else
  echo "✅ Found existing service principal: $APP_ID"
fi
```

#### 🛡️ 4.3 Assign Contributor Role

```bash
az role assignment create \
  --assignee "$APP_ID" \
  --role Contributor \
  --scope "/subscriptions/$SUBSCRIPTION_ID" || echo "ℹ️ Contributor role may already be assigned."
```

#### 🔑 4.4 Reset SP Credentials

```bash
CLIENT_SECRET=$(az ad app credential reset   --id "$APP_ID"   --append   --query password -o tsv)
```

---

### 5️⃣ 🏗️ Register Provider & Create Resource Group

```bash
LOCATION="australiaeast"
RG_NAME="lab5-rg"

echo "LOCATION=$LOCATION" >> .env # store LOCATION in .env
echo "RG_NAME=$RG_NAME" >> .env # store RG_NAME in .env

az provider register --namespace Microsoft.Web

az group create --name "$RG_NAME" --location "$LOCATION"
```

---

### 6️⃣ 🔒 Secure Credentials and Upload to GitHub

#### 📄 6.1 Generate `AZURE_CREDENTIALS` JSON

```bash
AZURE_CREDENTIALS=$(cat <<EOF
{
  "clientId": "$APP_ID",
  "clientSecret": "$CLIENT_SECRET",
  "subscriptionId": "$SUBSCRIPTION_ID",
  "tenantId": "$TENANT_ID",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
EOF
)
```

#### 🚀 6.2 Upload GitHub Secrets

```bash
APP_NAME="lab5app<yourname>" # generate a unique app name

echo "APP_NAME=$APP_NAME" >> .env # store APP_NAME in .env

echo "$APP_NAME" | gh secret set APP_NAME
echo "$AZURE_CREDENTIALS" | gh secret set AZURE_CREDENTIALS
```

✅ Secrets are now ready for use in GitHub Actions workflows.

---

## ✅ Lab Complete

You have:

- 🔐 Secured GitHub CLI access using a PAT  
- 🧩 Created and configured a service principal with Azure  
- 📦 Generated `AZURE_CREDENTIALS` JSON  
- 🔒 Uploaded secrets to GitHub for CI/CD use  
- 🏗️ Created a resource group for deploying applications
- 🔑 Stored important variables in .env for future use
- 🔑 Store important secrets in GitHub Secrets
- 📁 Prepared your environment for app service deployment in Lab 5-B