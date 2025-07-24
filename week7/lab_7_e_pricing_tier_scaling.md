# 💡 Lab 7-E: Test Scaling Limits by Pricing Tier

## 🌟 Objectives

- Understand how Azure App Service pricing tiers limit scaling capacity
- Compare scale-out limits across Free, Basic, Standard, and Premium tiers
- Test how many instances can be provisioned manually or automatically
- Use Azure Portal, CLI, and ARM to evaluate and enforce tier-specific scaling limits
- Learn how pricing decisions affect scalability and cost planning

---

## 🛠️ Requirements

- Azure subscription
- Azure CLI installed and logged in (`az login`)
- App Service Plan deployed (see .env)
- App deployed to App Service (see .env)
- Optional: A second App Service Plan in a different tier for comparison

---

## 🚦 Overview of App Service Tier Limits

Each App Service pricing tier defines the **maximum number of instances** (scale-out capacity). Example:

| Tier       | Max Instances | Notes                    |
|------------|----------------|---------------------------|
| Free (F1)  | 1              | No scaling supported      |
| Basic (B1) | 3              | Limited autoscale         |
| Standard (S1) | 10          | Supports autoscale        |
| Premium (P1v2, P2v2, etc.) | 20–30+       | High scale, better performance |

---

## 🧭 Option 1: Azure Portal

### 1️⃣ Check Current Tier and Limits

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **App Services** → Select ` <Web App name`
3. Click on the linked **App Service Plan**
4. In the left menu, select **Scale up (App Service plan)**
5. Observe current pricing tier and compare available options

✅ You’ll see instance limits (e.g., S1 → max 10 instances)

---

### 2️⃣ Attempt to Scale Out (Up to Tier Limit)

1. Go to **Scale out (App Service plan)**
2. Set instance count within your tier’s supported range
3. Save changes

✅ Scaling succeeds if within tier limits.

---

### 3️⃣ Attempt to Scale Out Beyond Tier Limit

1. Try setting instance count above the max allowed (e.g., 30 for S1)
2. Click Save

❌ You will get a validation error from Azure.

---

### 4️⃣ Upgrade Tier and Scale Again

1. Go to **Scale up**
2. Select a **Premium V2** tier (e.g., P2v2)
3. Apply the change
4. Return to **Scale out** and set instance count to 20+

✅ Scaling succeeds with Premium tiers.

---

## 💻 Option 2: Azure CLI

### 1️⃣ Check Current App Service Plan Tier

```bash
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RG \
  --query "sku.name"

az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RG \
  --query "{Tier:sku.tier, Size:sku.name, MaxInstances:maximumNumberOfWorkers}" \
  --output table
```

---

### 2️⃣ List Scaling Capabilities by SKU

```bash
az graph query -q "
resources
| where type == 'microsoft.web/serverfarms'
| where location == 'australiaeast'
| project name, sku = sku.name, tier = sku.tier, capacity = sku.capacity
" --output table
```

✅ Observe max instance capacity by tier.

---

### 3️⃣ Attempt to Scale Beyond Current Tier

```bash
az appservice plan update \
  --name $PLAN_NAME  \
  --resource-group $RG \
  --number-of-workers 30
```

❌ Expected Error:

```
ERROR: Cannot scale to 30 workers. Tier 'S1' only supports up to 10.
```

---

### 4️⃣ Upgrade Tier and Scale to 20 Workers

```bash
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RG \
  --sku P2v2 \
  --number-of-workers 20
```

✅ App Service Plan is now Premium V2 and running with 20 instances.

---

## 🧱 Option 3: ARM Template

### 1️⃣ Create `scale-tier-update.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "<Lab 7 App Plan>",
      "location": "australiaeast",
      "sku": {
        "name": "P2v2",
        "tier": "PremiumV2",
        "capacity": 20
      },
      "properties": {
        "numberOfWorkers": 20
      }
    }
  ]
}
```

---

### 2️⃣ Deploy the Template

```bash
az deployment group create \
  --resource-group $RG \
  --template-file scale-tier-update.json
```

✅ App Service Plan is updated to Premium V2 with 20 instances via ARM.

---

## 📋 Summary Table: Tier Scaling Test Methods

| Option    | Method         | Scaling Attempted | Outcome                         |
|-----------|----------------|-------------------|----------------------------------|
| Option 1  | Azure Portal   | Manual, UI-based  | Tier blocks >max, upgrade works |
| Option 2  | Azure CLI      | Manual via command | CLI error if exceeding tier     |
| Option 3  | ARM Template   | Declarative IaC   | Scales as long as tier allows   |

---

## ✅ Lab Complete

You validated Azure App Service Plan scaling limits using the Portal, CLI, and ARM template methods. You observed how **pricing tier directly impacts scalability**, and practiced upgrading and scaling App Service Plans across tier boundaries.

