# 🛡️ Lab 3-D: Configure Microsoft Defender for Cloud (CLI, Portal, ARM)

## 🎯 Objective

- Understand the purpose of Microsoft Defender for Cloud
- Enable Defender for Cloud via Portal, CLI, and ARM
- Explore Secure Score, Recommendations, and Compliance
- Enable Defender plans for VMs, Storage, SQL, Kubernetes, and App Services
- Validate post-deployment configuration

---

## 🧰 Requirements

- Azure Subscription (Owner/Contributor)
- Azure CLI v2.38.0+
- Access to [Azure Portal](https://portal.azure.com)
- Existing resource group with resources (e.g., VM, SQL, AKS)

---

## 👣 Lab Instructions

### 1️⃣ Enable Defender for Cloud

#### 🔹 Azure CLI:

```bash
az security auto-provisioning-setting update \
  --name default \
  --auto-provision On
```

#### 🚩 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search **Microsoft Defender for Cloud**
3. Click **Get Started** or **Enable** if not already active
4. Wait for provisioning (1–2 min)

✅ Secure Score, Recommendations, and Inventory should now appear.

---

### 2️⃣ Enable Defender Plans (per resource type)

#### 🔹 Azure CLI:

```bash
az security pricing create --name VirtualMachines --tier Standard
az security pricing create --name SqlServers --tier Standard
az security pricing create --name AppServices --tier Standard
az security pricing create --name KubernetesService --tier Standard
az security pricing create --name StorageAccounts --tier Standard
```

#### 🚩 Azure Portal:

1. Go to **Microsoft Defender for Cloud** → **Environment Settings**
2. Select your Subscription → Click **Plans**
3. Enable:
   - Defender for VMs
   - Defender for App Services
   - Defender for SQL
   - Defender for Kubernetes
   - Defender for Storage
4. Click **Save**

✅ Plans activated and monitored.

---

### 3️⃣ Explore Recommendations & Secure Score

#### 🔹 Azure CLI:

```bash
az security task list --output table
```

#### 🚩 Azure Portal:

1. Go to **Microsoft Defender for Cloud**
2. Click **Secure Score** → Review score
3. Go to **Recommendations** → Filter by High / Medium / Low

✅ Recommendations and guidance appear for unprotected/misconfigured resources.

---

### 4️⃣ ARM Template Deployment

#### 🔹 `defender-deploy.json`

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
az deployment sub create \
  --location australiaeast \
  --template-file defender-deploy.json
```

✅ Enables all Defender plans at the subscription level.

---

### 5️⃣ Post-Deployment Validation

#### ✅ CLI Validation:

```bash
az security pricing list --output table
az security task list --output table
```

Look for:

- **Pricing tier = Standard**
- Tasks showing security recommendations

#### ✅ Portal Validation:

1. Go to **Defender for Cloud** → Secure Score & Recommendations
2. Click into any active alerts or tasks
3. Ensure that pricing tier = **Standard** for protected services

✅ Defender successfully configured and monitoring.

---

## ✅ Lab Complete

You have enabled Microsoft Defender for Cloud via CLI, Portal, and ARM; explored secure score and recommendations; and activated monitoring for VMs, SQL, Kubernetes, and more.

