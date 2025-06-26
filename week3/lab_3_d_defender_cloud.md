# 🛡️ Lab 3-D: Configure Microsoft Defender for Cloud (CLI, Portal, ARM)

## 🌟 Objective

- Understand the purpose of Microsoft Defender for Cloud
- Enable Defender for Cloud via Portal, CLI, and ARM
- Explore Secure Score, Recommendations, and Compliance
- Enable Defender plans for VMs, Storage, SQL, Kubernetes, and App Services
- Validate post-deployment configuration

---

## 🧰 Requirements

- Azure Subscription (Owner/Contributor)
- Azure CLI 
- Access to [Azure Portal](https://portal.azure.com)
- Existing resource group with resources (e.g., VM, SQL, AKS)

---

## 👣 Lab Instructions

### 1⃣ Enable Defender for Cloud

#### 🔹 Azure CLI:

```bash
# Enable automatic provisioning of monitoring agents on supported resources
az security auto-provisioning-setting update \
  --name default \
  --auto-provision On
```

> 🔍 This command configures Defender to auto-provision the Log Analytics agent for supported Azure services like VMs.

#### 🚩 Azure Portal:

1. Sign in to [https://portal.azure.com](https://portal.azure.com)
2. In the search bar, type **Microsoft Defender for Cloud**
3. Select it → Click **Get Started** or **Enable** if Defender is not already active
4. Wait for 1–2 minutes for provisioning

> ✅ Secure Score, Recommendations, Inventory, and Environment Settings will now be visible in the left pane.

---

### 2⃣ Enable Defender Plans (per resource type)

#### 🔹 Azure CLI:

```bash
# Enable Defender plans for key resource types
az security pricing create --name VirtualMachines --tier Standard   # Defender for VMs
az security pricing create --name SqlServers --tier Standard        # Defender for SQL
az security pricing create --name AppServices --tier Standard       # Defender for App Services
az security pricing create --name KubernetesService --tier Standard # Defender for Kubernetes
az security pricing create --name StorageAccounts --tier Standard   # Defender for Storage
```

> 🔍 These commands configure each resource type with the **Standard** plan at the subscription level. Run only once per subscription.

#### 🚩 Azure Portal:

1. Go to **Microsoft Defender for Cloud** → **Environment Settings**
2. Select your Subscription
3. Click **Plans** in the top navigation
4. Enable the following:
   - ✅ Defender for VMs
   - ✅ Defender for App Services
   - ✅ Defender for SQL
   - ✅ Defender for Kubernetes
   - ✅ Defender for Storage
5. Click **Save** to apply changes

> ✅ Defender plans will now actively scan and protect associated services.

---

### 3⃣ Explore Recommendations & Secure Score

#### 🔹 Azure CLI:

```bash
# List active Defender recommendations
az security task list --output table
```

> 🔍 This shows security recommendations for misconfigured, unprotected, or vulnerable resources in your subscription.

#### 🚩 Azure Portal:

1. Open **Microsoft Defender for Cloud** from the portal home
2. Click **Secure Score** to review the current state of protection
3. Navigate to **Recommendations** → Filter by High / Medium / Low severity

> ✅ You'll receive actionable guidance for improving your environment’s security posture.

---

### 4⃣ ARM Template Deployment (Optional)

#### 🔹 `defender-deploy.json`

> ℹ️ Verified against 2022-01-01-preview — latest supported API version as of June 2025.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2022-01-01-preview",
      "name": "VirtualMachines",
      "properties": {
        "pricingTier": "Standard"
      }
    },
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2022-01-01-preview",
      "name": "SqlServers",
      "properties": {
        "pricingTier": "Standard"
      }
    },
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2022-01-01-preview",
      "name": "AppServices",
      "properties": {
        "pricingTier": "Standard"
      }
    },
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2022-01-01-preview",
      "name": "KubernetesService",
      "properties": {
        "pricingTier": "Standard"
      }
    },
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2022-01-01-preview",
      "name": "StorageAccounts",
      "properties": {
        "pricingTier": "Standard"
      }
    }
  ]
}
```

#### 🔹 Deploy via CLI:

```bash
# Deploy Defender plans at the subscription scope using ARM template
az deployment sub create \
  --location australiaeast \
  --template-file defender-deploy.json
```

> ✅ This will activate all listed Defender plans for the subscription.
> 💡 Use `az deployment sub show` to verify deployment status.

---

### 5⃣ Post-Deployment Validation

#### ✅ CLI Validation:

```bash
# Confirm pricing tier and security tasks
az security pricing list --output table
az security task list --output table
```

Look for:
- `Pricing tier` = **Standard** for each plan
- `Security tasks` indicating recommendations or alerts

#### ✅ Portal Validation:

1. Go to **Microsoft Defender for Cloud** in Azure Portal
2. Review **Secure Score** and confirm it's populated
3. Open **Environment Settings** → Your Subscription
4. Confirm all Defender plans show **Standard**
5. Click **Recommendations** and review active alerts

> ✅ Defender for Cloud is now actively monitoring and protecting your Azure services.

---

## ✅ Lab Complete

You have successfully configured Microsoft Defender for Cloud using Azure CLI, the Portal, and an ARM template. You explored Secure Score, validated plans for critical services, and confirmed security posture improvements.

> 🔁 Reminder: Defender for Cloud provides ongoing insights, so revisit Secure Score and Recommendations periodically.

