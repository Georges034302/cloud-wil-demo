# 🚀 Lab 7-A: Manual Scaling of an Azure Web App

## 🎯 Objectives

- Understand the difference between scaling up/down (tiers) and out/in (instances)
- Perform manual scaling actions on Azure App Service
- Compare App Service Plan tiers and their scaling limits
- Use Azure Portal, CLI, and ARM to adjust web app capacity
- Recognize scenarios for manual scaling usage

---

## 🛠️ Requirements

- Azure subscription
- Azure CLI installed (`az login`)
- A deployed Azure Web App (e.g., `lab7app`)
- App Service Plan (Standard or higher tier)

---

## 👣 Lab Instructions

### 1️⃣ Check Current App Service Plan

#### 🌐 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **App Services** → Select your app (e.g., `lab7app`)
3. Under **App Service plan**, click the linked plan (e.g., `Lab7Plan`)
4. Review:
   - **Pricing tier**
   - **Number of instances**
   - **Region**

#### 💻 Azure CLI:

```bash
az webapp list --query "[].{Name:name, Plan:serverFarmId}" --output table
az appservice plan show --name Lab7Plan --resource-group <resource-group>
```

✅ Confirms the app's current scale configuration.

---

### 2️⃣ Manually Scale Out (Increase Instances)

#### 🌐 Azure Portal:

1. From App Service Plan view → Click **Scale out (App Service plan)**
2. Increase **Instance count** to 2 or more
3. Click **Save**

✅ Adds more worker instances for higher availability.

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --number-of-workers 3
```

✅ Your app is now running on 3 instances.

#### 🧱 ARM Template:

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
      "properties": {
        "numberOfWorkers": 3
      },
      "sku": {
        "name": "S1",
        "tier": "Standard",
        "capacity": 3
      }
    }
  ]
}
```

Deploy:

```bash
az deployment group create \
  --resource-group <resource-group> \
  --template-file scale-out.json
```

---

### 3️⃣ Manually Scale Up (Change Pricing Tier)

#### 🌐 Azure Portal:

1. From App Service Plan → Click **Scale up (App Service plan)**
2. Choose a higher tier (e.g., `S2`)
3. Click **Apply**

✅ Allocates more CPU, memory, and features.

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --sku S2
```

✅ App Service Plan upgraded.

#### 🧱 ARM Template:

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
        "name": "S2",
        "tier": "Standard",
        "capacity": 1
      },
      "properties": {
        "reserved": true
      }
    }
  ]
}
```

Deploy:

```bash
az deployment group create \
  --resource-group <resource-group> \
  --template-file scale-up.json
```

---

### 4️⃣ Confirm Scaling Changes

#### 🌐 Azure Portal:

- Return to **App Service Plan overview**
- Verify pricing tier and instance count

#### 💻 Azure CLI:

```bash
az appservice plan show \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --query "{Tier:sku.tier, Size:sku.name, Workers:maximumNumberOfWorkers}" \
  --output table
```

✅ Scaling changes successfully applied.

---

## ✅ Lab Complete

You manually scaled an Azure Web App by changing its pricing tier and instance count using Azure Portal, CLI, and ARM templates.

