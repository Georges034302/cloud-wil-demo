# 💡 Lab 7-E: Test Scaling Limits by Pricing Tier

## 🎯 Objectives

- Understand how Azure App Service pricing tiers limit scaling capacity
- Compare scale-out limits across Free, Basic, Standard, and Premium tiers
- Test how many instances can be manually or automatically provisioned
- Use CLI to retrieve and analyze tier-specific scaling capabilities
- Learn how pricing decisions affect availability and cost planning

---

## 🧰 Requirements

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
  --resource-group <resource-group> \
  --query "serverFarmId"

az appservice plan show \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --query sku.name
```

✅ Confirms current tier for capacity assessment.

---

### 2️⃣ List Scaling Capabilities for All Tiers

#### 💻 Azure CLI:

```bash
az appservice list-skus --location australiaeast --output table
```

Columns:

- `skuName`: Name of the SKU (e.g., F1, S1, P1v2)
- `capacity`: Max number of instances supported
- `tier`: Pricing tier name (Free, Basic, Standard, Premium)
- `enabled`: Whether the tier is available in the region

✅ This command helps you compare supported scale-out limits by SKU.

---

### 3️⃣ Attempt to Scale Beyond Tier Limit (Optional)

Test if the tier enforces its limits.

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --number-of-workers 30
```

✅ Expected Error:

```
ERROR: Cannot scale to 30 workers. Tier 'S1' only supports up to 10.
```

✅ Azure enforces the scaling boundaries based on the tier definition.

---

### 4️⃣ Change Tier and Retest Scaling

#### 🌐 Azure Portal:

1. Go to **App Service Plan** → **Scale up**
2. Select a Premium v2 tier (e.g., `P1v2` or `P2v2`)
3. Click **Apply** to confirm
4. Once updated, go to **Scale out** → Try increasing to 20+ instances

#### 💻 Azure CLI:

```bash
az appservice plan update \
  --name Lab7Plan \
  --resource-group <resource-group> \
  --sku P2v2 \
  --number-of-workers 20
```

✅ Premium tiers allow for significantly higher scale-out.

---

✔️ **Lab complete – you've tested App Service scaling boundaries across different pricing tiers using both Portal and CLI.**

