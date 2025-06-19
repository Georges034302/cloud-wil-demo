# 💡 Lab 7-E: Test Scaling Limits by Pricing Tier

## 🌟 Objectives

- Understand how Azure App Service pricing tiers limit scaling capacity
- Compare scale-out limits across Free, Basic, Standard, and Premium tiers
- Test how many instances can be manually or automatically provisioned
- Use Azure Portal, CLI, and ARM to evaluate and enforce tier-specific scaling limits
- Learn how pricing decisions affect availability and cost planning

---

## 🛠️ Requirements

- Azure Portal access
- Azure CLI installed (`az login`)
- App Service Plan deployed (e.g., `Lab7Plan`)
- App deployed to App Service (e.g., `lab7app`)
- Optional: A second App Service Plan in a different tier for comparison

---

## 👣 Lab Instructions

### 1️⃣ Review Current App Service Tier

#### 🌐 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **App Services** → Select `lab7app`
3. In the left menu, click **Scale up (App Service plan)**
4. Review your current pricing tier (e.g., Free, Basic, Standard, Premium)
5. Click **View all tiers** to compare available plans

✅ Note how each tier defines max instances (e.g., Standard S1 supports up to 10 instances).

#### 💻 Azure CLI:

```bash
az webapp show \
  --name lab7app \
  --resource-group lab7-rg \
  --query "serverFarmId"

az appservice plan show \
  --name Lab7Plan \
  --resource-group lab7-rg \
  --query sku.name
```

✅ Confirms current tier for capacity assessment.

---

### 2️⃣ List Scaling Capabilities for All Tiers

#### 💻 Azure CLI:

```bash
az appservice list-skus \
  --location australiaeast \
  --output table
```

✅ Output includes:

- `skuName`: Name of the SKU (e.g., F1, S1, P1v2)
- `capacity`: Max number of instances supported
- `tier`: Pricing tier name
- `enabled`: Availability in region

---

### 3️⃣ Attempt to Scale Beyond Tier Limit

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group lab7-rg \
  --number-of-workers 30
```

✅ Expected Error:

```
ERROR: Cannot scale to 30 workers. Tier 'S1' only supports up to 10.
```

Azure enforces instance limits per tier.

---

### 4️⃣ Change Tier and Retest Scaling

#### 🌐 Azure Portal:

1. Navigate to **App Service Plan** → Click **Scale up**
2. Select a Premium v2 tier (e.g., `P2v2`)
3. Click **Apply** to confirm
4. Go to **Scale out** → Set instance count to 20+

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group lab7-rg \
  --sku P2v2 \
  --number-of-workers 20
```

✅ Premium tiers allow for higher scalability.

---

### 5️⃣ ARM Template for Scaling Tier

Create `scale-tier-update.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-03-01",
      "name": "Lab7Plan",
      "location": "australiaeast",
      "properties": {
        "numberOfWorkers": 20
      },
      "sku": {
        "name": "P2v2",
        "tier": "PremiumV2",
        "capacity": 20
      }
    }
  ]
}
```

#### 💻 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab7-rg \
  --template-file scale-tier-update.json
```

✅ ARM confirms App Service Plan update with new capacity.

---

## ✅ Lab Complete

You tested and compared App Service scaling limits across pricing tiers using Azure Portal, CLI, and ARM templates to understand how SKU selection impacts scalability and cost.

