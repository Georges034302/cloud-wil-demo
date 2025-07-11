# 🛠️ Lab 5-B: Deploy Python App to Azure App Service 

## 🎯 Objectives

- Create and configure a Python App Service environment using CLI and Portal
- Deploy a basic Python web app manually (no CI pipeline yet)
- Prepare environment for CI/CD in Lab 5-C

---

## 🧰 Requirements

| Requirement         | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| ✅ GitHub repository | Repo with `joke-api.py` in root directory                    |
| ✅ Azure CLI         | Installed and authenticated (`az login`)                     |
| ✅ GitHub CLI        | Installed and authenticated using PAT (see Lab A)            |
| ✅ Microsoft.Web     | Registered Microsoft.Web Provide to enable App Service access|
| ✅ `.env` file       | Contains `APP_NAME`, `RG_NAME`, and is added to `.gitignore` |
| ✅ GitHub Secrets    | Contains `APP_NAME`, `AZURE_CREDENTIALS` |


---

## 👣 Lab Instructions

### 🏗️ Prepare Python App Project

#### 📁 Create Project Structure

```bash
mkdir joke-api
cd joke-api
touch app.py requirements.txt
```

#### 🐍 Python App `app.py` 

```python
from flask import Flask, jsonify
import random

app = Flask(__name__)

jokes = [
    "Why don’t developers like nature? It has too many bugs.",
    "Why did the developer go broke? Because he used up all his cache.",
    "Why do programmers prefer dark mode? Because light attracts bugs.",
    "What is a programmer’s favorite hangout place? The Foo Bar."
]

@app.route("/joke")
def joke():
    return jsonify({"joke": random.choice(jokes)})

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=8000)
```

#### 📝 Python App dependencies: `requirements.txt`:

```txt
flask
```

---

## 🧪 CLI Deployment Steps

### 🔹 Step 1: Create App Service Plan

```bash
# Load enviroment variables
source .env
```
```bash
PLAN_NAME=app-service-plan-python

az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RG_NAME" \
  --sku FREE \
  --is-linux
```

### 🔹 Step 2: Create App Service Web App

```bash

az webapp create \
  --resource-group "$RG_NAME" \
  --plan "$PLAN_NAME" \
  --name "$APP_NAME" \
  --runtime "PYTHON|3.11"
```

### 🔹 Step 3: Deploy App to Azure

You can use `zip deploy` method:

```bash
zip -r app.zip .   # Zip the current directory content - ensure that you are inside joke-api folder

az webapp deploy \
  --resource-group "$RG_NAME" \
  --name "$APP_NAME" \
  --src-path app.zip \
  --type zip
```

### 🔹 Step 4: Validate the Deployment

```bash
az webapp show \
  --name "$APP_NAME" \
  --resource-group "$RG_NAME" \
  --query defaultHostName \
  --output tsv
```

Visit: `https://$APP_NAME.azurewebsites.net/joke`

✅ You should see a joke returned in JSON.

---

## 🧪 Portal Deployment Steps

### 🔸 Step 1: Create App Service Plan

1. Go to [Azure Portal](https://portal.azure.com)
2. Search **App Service Plans** → **+ Create**
3. Use:
   - Resource group: `lab5-rg`
   - Name: `app-service-plan-python`
   - Region: Australia East
   - OS: Linux
   - SKU: Free (F1)
4. Click **Review + Create** → **Create**

### 🔸 Step 2: Create Web App

1. Go to **App Services** → **+ Create**
2. Use:
   - Name: `$APP_NAME`  (`APP_NAME is localed in .env`)
   - Publish: Code
   - Runtime stack: Python 3.11
   - Region: Australia East
   - Plan: `app-service-plan-python`
3. Click **Review + Create** → **Create**

### 🔸 Step 3: Deploy Code

1. Go to the App Service
2. Click **Deployment Center** → **Zip Deploy**
3. Upload your zipped repo (`app.zip`)

✅ App will be deployed and accessible at `https://$APP_NAME.azurewebsites.net/joke`

---

## ✅ Lab Complete

- 🐍 Created a Python Flask app (`joke-api.py`) with `requirements.txt`
- 🏗️ Created an App Service Plan and Web App using Azure CLI and Portal
- 🗜️ Packaged the Python app using ZIP for deployment
- 🚀 Deployed the app manually to Azure App Service (no CI/CD yet)
- 🌐 Verified the deployed API via the `/joke` endpoint
- 📁 Prepared your environment for automated deployment in Lab 5-C
