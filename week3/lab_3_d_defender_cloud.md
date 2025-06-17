# 🛡️ Lab 3-D: Configure Microsoft Defender for Cloud

## 🎯 Objective

- Understand the purpose of Microsoft Defender for Cloud (formerly Azure Security Center)
- Enable Defender for Cloud on a subscription or resource group
- Explore secure score, recommendations, compliance, and threat detection
- Enable Defender plans for VMs, Storage, SQL, Kubernetes, and App Services
- Use Azure CLI to configure Defender auto-provisioning and pricing tiers

---

## 🧰 Requirements

- Active Azure Subscription (Owner or Contributor role)
- Access to [https://portal.azure.com](https://portal.azure.com)
- Azure CLI (v2.38.0+)
- A resource group with one or more deployed resources (e.g., VM, Cosmos DB, AKS)

---

## 👣 Lab Instructions

### 1️⃣ Enable Microsoft Defender for Cloud

#### 🔹 Azure Portal:

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search **Microsoft Defender for Cloud** in the top bar
3. Click the result → **Enable** or **Get Started** if prompted
4. Wait \~1–2 minutes for setup

✅ Once active, you’ll see:

- **Secure Score**
- **Recommendations**
- **Inventory**
- **Regulatory Compliance**

#### 🖥️ Azure CLI:

```bash
az security auto-provisioning-setting update \
  --name default \
  --auto-provision On
```

✅ Enables automatic provisioning of monitoring agents for supported resources.

---

### 2️⃣ Explore Secure Score and Recommendations

#### 🔹 Azure Portal:

1. In the Defender for Cloud dashboard, click **Secure Score**
2. Review the overall security posture
3. Click **Recommendations**
4. Filter by severity: High / Medium / Low
5. Explore recommendations like:
   - Unencrypted storage accounts
   - Open management ports
   - Missing OS patches

✅ Clicking each item reveals remediation guidance.

#### 🖥️ Azure CLI:

```bash
az security task list
```

✅ Lists all pending security tasks and recommendations.

---

### 3️⃣ Enable Specific Defender Plans

#### 🔹 Azure Portal:

1. Go to **Environment settings** under Defender for Cloud
2. Select your subscription
3. Click **Plans**
4. Enable:
   - **Defender for App Services**
   - **Defender for SQL**
   - **Defender for Kubernetes**
   - **Defender for Storage**
5. Click **Save**

✅ Defender protection plans activated.

#### 🖥️ Azure CLI:

```bash
az security pricing create \
  --name VirtualMachines \
  --tier Standard
```

✅ Enables Standard tier protection (billed) for VMs.

📌 Repeat with other resource types as needed (e.g., `AppServices`, `StorageAccounts`, `SqlServers`).

---

✔️ **Lab complete – you enabled Microsoft Defender for Cloud, reviewed secure score and recommendations, and applied threat protection to your key Azure services.**

