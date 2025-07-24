# 🚀 Lab 7-A: Manual Scaling of an Azure Web App

## 🎯 Objectives

- Understand the difference between scaling up/down (tiers) and out/in (instances)
- Perform manual scaling actions on Azure App Service
- Compare App Service Plan tiers and their scaling limits
- Use Azure CLI and ARM to adjust web app capacity
- Recognize scenarios for manual scaling usage

---

## 🛠️ Requirements

- Azure subscription
- Azure CLI installed (`az login`)
- A deployed Azure Web App (e.g., `refer to lab_5_b and deploy a web app`)
- App Service Plan (Standard or higher tier)

---

## 👣 Lab Instructions

### Step 1: Environment Setup


####  Environment Variables:

> Create env_setup.sh
```bash
touch env_setup.sh
```

> Copy and paste the script into env_setup.sh
```bash
#!/bin/bash

RG=lab7-rg
LOCATION=australiaeast
PLAN_NAME=app-service-plan-$RANDOM
APP_NAME=web-app-$RANDOM

echo "Setting environment variables and saving to .env file..."

# Overwrite .env on each execution
cat > .env <<EOF
export RG=$RG
export LOCATION=$LOCATION
export PLAN_NAME=$PLAN_NAME
export APP_NAME=$APP_NAME
EOF

echo "Done! Environment variables written to .env:"
echo "  RG=$RG"
echo "  LOCATION=$LOCATION"
echo "  PLAN_NAME=$PLAN_NAME"
echo "  APP_NAME=$APP_NAME"
echo "Use 'source .env' to load them into your current shell."

# Add .env to .gitignore if not already ignored
if ! grep -qxF '.env' .gitignore; then
  echo ".env" >> .gitignore
  echo "🛡️  .env file added to .gitignore for safety."
else
  echo "✅ .env already in .gitignore"
fi
```

> Run env_setup.sh
```bash
bash env_setup.sh

```

####  📁 Create Project Structure:

> Create the Python API

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
```

#### 📝 Python App dependencies: `requirements.txt`:

```txt
flask
```

> Deploy a Web App

```bash
touch deploy_app.sh
```

> Copy and paste the script into deploy_app.sh

```bash
#!/bin/bash

# Load environment variables 
source .env

# 0. Create Resource Group if it doesn't exist
echo "Creating resource group: $RG in $LOCATION..."
az group create \
  --name "$RG" \
  --location "$LOCATION"

# 1. Create App Service Plan (Linux, Free tier)
echo "Creating App Service Plan: $PLAN_NAME in $RG..."
az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RG" \
  --sku FREE \
  --is-linux

# 2. Create Web App with Python 3.11 runtime
echo "Creating Web App: $APP_NAME in $RG..."
az webapp create \
  --resource-group "$RG" \
  --plan "$PLAN_NAME" \
  --name "$APP_NAME" \
  --runtime "PYTHON|3.11"

# 3. Zip your app (run this inside the joke-api folder)
echo "Zipping app in joke-api/..."
cd joke-api
zip -r ../app.zip .
cd ..

# 4. Deploy the zipped app to Azure App Service
echo "Deploying app.zip to Azure App Service..."
az webapp deploy \
  --resource-group "$RG" \
  --name "$APP_NAME" \
  --src-path app.zip \
  --type zip

# 5. Get the app's default hostname
echo "Fetching app's default hostname..."
APP_URL=$(az webapp show \
  --name "$APP_NAME" \
  --resource-group "$RG" \
  --query defaultHostName \
  --output tsv)

echo "Deployment complete!"
echo "Visit: https://$APP_URL/joke"
```

> Run the deploy web app script

```bash
bash deploy_app.sh
```

> Verify the Web App

```bash
az webapp list --query "[].{Name:name, Plan:serverFarmId}" --output table
az appservice plan show --name $PLAN_NAME --resource-group $RG
```

✅ Confirms the app's current scale configuration.

---

### Step 2: Attempt Manual Scale-Out on F1 Tier (Expected Failure)

```bash
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --number-of-workers 2
```

> ❌ **Expected Error:**  
> `Number of Web workers exceeds the maximum allowed for the hosting plan.`

🎓 **Explanation:**  
The **Free (F1)** tier only allows **1 instance** and does **not support scaling**. You must upgrade to a higher tier to enable manual scale-out.

---

### App Service Tier Comparison

| Tier | Scaling Supported | Max Instances | Custom Domain | TLS Support |
|------|-------------------|---------------|----------------|--------------|
| F1   | ❌ No              | 1             | ❌ No          | ❌ No         |
| S1   | ✅ Yes             | 10            | ✅ Yes         | ✅ Yes        |

---

### Step 3: Scale Up to Standard Tier (S1)

### 💻 CLI Method

```bash
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --sku S1
```

> ✅ This upgrades the plan from F1 to S1, enabling manual scaling.

---

### 🧱 ARM Method

Create `scale-up.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "Lab7Plan",
      "location": "australiaeast",
      "sku": {
        "name": "S1",
        "tier": "Standard",
        "capacity": 1
      }
    }
  ]
}
```

Deploy with:

```bash
az deployment group create \
  --resource-group $RG \
  --template-file scale-up.json
```

---
### Step 4:  Scale Out - Add Instances

#### ➕ CLI Method: Add 1 Worker (to 2 total)

```bash
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --number-of-workers 2
```

> ✅ App Service is now running on 2 instances.


#### ➕ ARM Method: Add 1 More (to 3 total)

Create `scale-out.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "Lab7Plan",
      "location": "australiaeast",
      "sku": {
        "name": "S1",
        "tier": "Standard",
        "capacity": 3
      },
      "properties": {
        "numberOfWorkers": 3
      }
    }
  ]
}
```

Deploy:

```bash
az deployment group create \
  --resource-group $RG \
  --template-file scale-out.json
```

> ✅ Now running on 3 total instances.

---

### Step 5: Scale In to 1 Instance (CLI)

```bash
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --number-of-workers 1
```

> ✅ App Service is now scaled **in** to a single instance.

---

### 🔍 Verify Scaling Status

```bash
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RG \
  --query "{Tier:sku.tier, Size:sku.name, Instances:sku.capacity}" \
  --output table
```
---

### Downgrade App Service Plan to Free (F1)

You can downgrade your App Service Plan back to the **Free (F1)** tier using the Azure CLI, but certain conditions must be met.

#### Prerequisites Before Downgrading

- ❗ Must be using **only 1 instance**
- ❗ Must **not be using** features unavailable in F1:
  - Custom domains
  - TLS/SSL bindings
  - Deployment slots
  - Always On
  - Daily quotas over 60 minutes

#### Step-by-Step Downgrade (Safe Path)

```bash
# Step 1: Scale down to 1 instance (required for F1)
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --number-of-workers 1

# Step 2: Downgrade to Free (F1) tier
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --sku F1
```

> ✅ Your App Service Plan is now on the **Free (F1)** tier.

---

#### Confirm the Plan Tier and Instance Count

```bash
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RG \
  --query "{Tier:sku.tier, Size:sku.name, Instances:sku.capacity}" \
  --output table
```

### 📌 Tip

If the downgrade command fails, double-check:
- You have no more than 1 instance
- You're not using advanced features from higher tiers

---

## ✅ Summary

- You attempted scale-out on F1 (and it failed)
- You upgraded the plan to S1 (CLI and ARM)
- You scaled out (CLI and ARM)
- You scaled back in
- You confirmed scale status using the Azure CLI