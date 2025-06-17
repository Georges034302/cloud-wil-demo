# 🚀 Lab 7-A: Manual Scaling of an Azure Web App

## 🎯 Objectives

- Understand the difference between scaling up/down (tiers) and out/in (instances)
- Perform manual scaling actions on Azure App Service
- Compare App Service Plan tiers and their scaling limits
- Use Azure Portal and CLI to adjust web app capacity
- Recognize scenarios for manual scaling usage

---

## 🧰 Requirements

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
3. In the **App Service plan** section, click the linked plan (e.g., `Lab7Plan`)
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
2. Increase **Instance count** to 2 or 3
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

---

### 3️⃣ Manually Scale Up (Change Pricing Tier)

Scaling up means moving to a more powerful App Service Plan.

#### 🌐 Azure Portal:

1. From App Service Plan → Click **Scale up (App Service plan)**
2. Choose a higher tier (e.g., `S2`)
   - **F1**: Free (1 instance only)
   - **B1-B3**: Basic (no autoscaling)
   - **S1-S3**: Standard (multi-instance support)
3. Click **Apply**

✅ Allocates more CPU, memory, and features.

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --sku S2
```

✅ Your app has been upgraded to a higher pricing tier.

---

### 4️⃣ Confirm Scaling Changes

#### 🌐 Azure Portal:

- Return to the App Service Plan overview
- Verify new pricing tier and instance count

#### 💻 Azure CLI:

```bash
az appservice plan show \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --query "{Tier:sku.tier, Size:sku.name, Workers:maximumNumberOfWorkers}" --output table
```

✅ Ensures your scale operations succeeded.

---

✔️ **Lab complete – you've manually scaled an Azure Web App by adjusting instance count and pricing tier using both the Portal and CLI.**

