# 📊 Lab 3-F: Set Up Monitoring & Compliance Insights in Azure

## 🎯 Objective

- Access and interpret Azure Policy compliance dashboards
- Identify non-compliant resources based on assigned policies
- Set up compliance monitoring and remediation tasks
- Use Azure CLI to list and filter policy compliance states
- Understand integration with Azure Monitor and Log Analytics

---

## 🧰 Requirements

- Azure subscription
- One or more Azure Policy assignments (from Lab 3-E)
- Azure Portal access
- Azure CLI installed and logged in (`az login`)
- An existing resource group with deployed resources (e.g., `lab3e-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Access Azure Policy Compliance Dashboard

#### 🔹 Azure Portal:

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. In the top search bar, type **Policy** and open the **Azure Policy** blade
3. In the left-hand menu, click **Compliance**

You’ll see:

- A summary of all policy definitions and assignments
- Compliance state (Compliant / Non-compliant)
- Resources affected by each policy

💡 **Tips:**

- Sort/filter by resource group, policy name, or severity
- Click any policy to view resource-level compliance and reasons

---

### 2️⃣ Investigate a Non-Compliant Resource

1. In the **Compliance** tab, click a policy marked as **Non-compliant**
2. Review the **affected resources**
3. Click on a resource to:
   - View the **non-compliance reason** (e.g., wrong region, missing tag)
   - Navigate to its properties for correction

📝 This builds understanding of real-time enforcement and troubleshooting.

---

### 3️⃣ Use Azure CLI to Query Policy States

#### 🖥️ List All Policy States:

```bash
az policy state list \
  --query "[].{Resource: resourceId, Policy: policyDefinitionName, State: complianceState}" \
  --output table
```

✅ Provides a readable summary of policy evaluations.

#### 🖥️ Filter Non-Compliant Resources:

```bash
az policy state list \
  --filter "complianceState eq 'NonCompliant'" \
  --query "[].{Resource: resourceId, Reason: policyDefinitionName}" \
  --output table
```

✅ Focuses your attention on remediation.

---

### 4️⃣ Enable Continuous Compliance Monitoring

Azure Policy integrates with Azure Monitor to:

- Trigger alerts on new non-compliant resources
- Display dashboards in **Workbooks**
- Connect with **Log Analytics** for in-depth insights

#### 🔹 Azure Portal:

1. In **Azure Policy**, click **Remediation** in the left menu
2. Select a non-compliant policy
3. Click **Create Remediation Task**
4. Choose:
   - **Scope** (e.g., subscription or specific resource group)
   - **Remediation Action** (e.g., assign missing tag, enforce location)
5. Click **Remediate** to apply

✅ Azure will attempt to auto-correct non-compliant resources.

---

✔️ **Lab complete – you reviewed Azure Policy compliance results, used CLI to query and filter compliance states, and created remediation tasks to improve compliance posture.**

