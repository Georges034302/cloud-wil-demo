# 📊 Lab 3-F: Set Up Monitoring & Compliance Insights in Azure (CLI, Portal, ARM)

## 🎯 Objective

- Access and interpret Azure Policy compliance dashboards
- Identify non-compliant resources based on assigned policies
- Set up compliance monitoring and remediation tasks
- Use Azure CLI to list and filter policy compliance states
- Understand integration with Azure Monitor and Log Analytics
- Automate policy evaluation and remediation with ARM templates

---

## 🧰 Requirements

- Azure subscription
- One or more Azure Policy assignments (e.g., from Lab 3-E)
- Azure Portal access
- Azure CLI installed and logged in (`az login`)
- Existing resource group (e.g., `lab3e-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Access Azure Policy Compliance Dashboard

#### 🔹 Azure Portal:

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. In the search bar, type **Policy** → Open **Azure Policy** blade
3. Click **Compliance** in the left menu

✅ View policy assignments, compliance states, and non-compliant resources

---

### 2️⃣ Investigate a Non-Compliant Resource

1. Click a **Non-compliant** policy in the dashboard
2. View **Affected Resources**
3. Click a resource to inspect why it's non-compliant

📝 Understand real-time enforcement and resolution paths

---

### 3️⃣ Use CLI to Query Compliance States

#### 🖥️ List All Policy States:

```bash
az policy state list \
  --query "[].{Resource: resourceId, Policy: policyDefinitionName, State: complianceState}" \
  --output table
```

#### 🖥️ Filter Non-Compliant Resources:

```bash
az policy state list \
  --filter "complianceState eq 'NonCompliant'" \
  --query "[].{Resource: resourceId, Reason: policyDefinitionName}" \
  --output table
```

✅ Focus on remediation by targeting non-compliant resources

---

### 4️⃣ Create a Remediation Task

#### 🔹 Azure Portal:

1. Go to **Azure Policy** → **Remediation**
2. Select a **Non-compliant** policy assignment
3. Click **Create Remediation Task**
4. Fill in scope and actions → Click **Remediate**

#### 🖥️ Azure CLI:

```bash
az policy remediation create \
  --name restrict-remediate \
  --policy-assignment "RestrictLocations" \
  --resource-group lab3e-rg
```

✅ Triggers auto-correction on existing non-compliant resources

---

### 5️⃣ ARM Template for Policy Remediation

#### 🔹 `remediation-task.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.PolicyInsights/remediations",
      "apiVersion": "2022-06-01",
      "name": "restrict-remediate",
      "properties": {
        "policyAssignmentId": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab3e-rg/providers/Microsoft.Authorization/policyAssignments/RestrictLocations"
      }
    }
  ]
}
```

#### 🔹 Deploy:

```bash
az deployment sub create \
  --location australiaeast \
  --template-file remediation-task.json
```

✅ Executes remediation for non-compliant resources under assignment scope

---

### 🔍 Post-Remediation Validation

#### ✅ Confirm Resources Are Now Compliant

**Azure Portal:**

1. Go to **Azure Policy** → **Compliance**
2. Locate your policy assignment (e.g., `RestrictLocations`)
3. Confirm that previously non-compliant resources now show **Compliant** status

**Azure CLI:**

```bash
az policy state list \
  --query "[?policyAssignmentName=='RestrictLocations'].[resourceId, complianceState]" \
  --output table
```

You should now see `Compliant` for all evaluated resources.

#### 📈 Optional: Monitor with Azure Monitor or Log Analytics

If diagnostic settings or integration with Log Analytics is enabled:

```bash
az monitor diagnostic-settings list --resource "/providers/Microsoft.PolicyInsights"
```

You can also use Kusto Query Language (KQL) in Log Analytics to query historical policy compliance trends.

---

## ✅ Lab Complete

You monitored Azure Policy compliance, queried results with CLI, triggered remediation in Portal and CLI, automated it via ARM, and validated policy enforcement post-remediation. You're now equipped to enforce and maintain governance across your Azure environment.

