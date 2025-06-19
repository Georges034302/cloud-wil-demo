# 🛡️ Lab 5-E: Integrate Azure Policy in CI/CD

## 🎯 Objectives

- Understand Azure Policy as a governance-as-code tool
- Assign policies to enforce rules during deployments
- Integrate policy enforcement in a CI/CD pipeline
- Remediate existing resources to meet policy
- Validate compliance using Azure CLI, Portal, and ARM

---

## 🛠️ Requirements

- Azure CLI installed (`az login`)
- Azure Portal access
- Resource group: `lab5-rg` with existing deployments
- Optional: GitHub Actions or Azure DevOps pipeline
- Familiarity with resource deployment and ARM templates

---

## 👣 Lab Instructions

### 1️⃣ Review Built-In Azure Policy Definitions

#### 🌐 Azure Portal:

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search and select **Policy**
3. Go to **Definitions**
4. Filter by **Type = Built-in**
5. Review definitions like:
   - **Require a tag on resources**
   - **Allowed locations**
   - **Audit VMs without managed disks**

📝 Note the **Definition ID** of any policy you want to use.

---

### 2️⃣ Assign "Require a tag on resources" Policy

#### 🌐 Azure Portal:

1. Go to **Policy → Assignments**
2. Click **+ Assign Policy**
3. **Scope**: Select `lab5-rg`
4. **Policy definition**: Choose `Require a tag on resources`
5. **Assignment name**: `EnforceEnvironmentTag`
6. Under **Parameters**:
   - **Tag name**: `environment`
7. Click **Review + Create → Create**

✅ Policy is now active on `lab5-rg`

#### 💻 Azure CLI:

```bash
# Get definition ID
az policy definition list --query "[?displayName=='Require a tag on resources'].{Name:displayName, ID:policyDefinitionId}" -o table

# Assign the policy
az policy assignment create \
  --name EnforceEnvironmentTag \
  --policy <definition-id> \
  --resource-group lab5-rg \
  --params '{"tagName": {"value": "environment"}}'
```

🔁 Replace `<definition-id>` with the exact ID from the query.

---

### 3️⃣ Deploy a Non-Compliant Resource (Expected Failure)

```bash
az storage account create \
  --name nostoragetag1234 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS
```

❌ Deployment will fail due to missing `environment` tag.

---

### 4️⃣ Redeploy with Compliant Tag

```bash
az storage account create \
  --name tagstoragedev01 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS \
  --tags environment=dev
```

✅ Deployment succeeds.

---

### 5️⃣ Deploy Policy Assignment with ARM

Create `policy-assignment.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "type": "Microsoft.Authorization/policyAssignments",
      "apiVersion": "2021-06-01",
      "name": "EnforceEnvironmentTag",
      "properties": {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/"  
          "c2b0429a-7fc1-4471-9bd6-5ebc8198b5d0",
        "scope": "/subscriptions/<subscription-id>/resourceGroups/lab5-rg",
        "parameters": {
          "tagName": { "value": "environment" }
        }
      }
    }
  ]
}
```

```bash
az deployment sub create \
  --location australiaeast \
  --template-file policy-assignment.json
```

🔁 Replace `<subscription-id>` with your actual ID.

---

### 6️⃣ Validate Compliance

#### 💻 Azure CLI:

```bash
az policy state list \
  --resource-group lab5-rg \
  --query "[?complianceState=='NonCompliant']" -o table
```

#### 🌐 Azure Portal:

1. Go to **Policy → Compliance**
2. Select assignment `EnforceEnvironmentTag`
3. View non-compliant resources and history

✅ Use in CI/CD pipeline as a pre-check gate.

---

### 7️⃣ Remediate Non-Compliant Resources

#### 🌐 Azure Portal:

1. Go to **Azure Policy → Compliance**
2. Select `EnforceEnvironmentTag`
3. Click **Create remediation task**
4. Provide tag value: `environment=dev`
5. Click **Remediate**

✅ Azure will attempt auto-remediation.

---

## ✅ Lab Complete

You assigned an Azure Policy using Portal, CLI, and ARM, tested enforcement, remediated violations, and validated compliance – integrating governance into your CI/CD process.

