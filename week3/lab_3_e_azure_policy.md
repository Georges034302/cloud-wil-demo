# 📜 Lab 3-E: Create and Assign Azure Policies (CLI, Portal, ARM)

## 🎯 Objective

- Understand the purpose of Azure Policy in enforcing governance
- Create built-in/custom policy definitions
- Assign a policy using Portal, CLI, and ARM
- Validate compliance and behavior

---

## 🧰 Requirements

- Azure subscription (Owner/Contributor role)
- Azure CLI (v2.38.0+)
- Access to [Azure Portal](https://portal.azure.com)
- Resource group (e.g., `lab3e-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Create Resource Group

```bash
# Create a new resource group for testing
az group create --name lab3e-rg --location australiaeast
```

---

### 2️⃣ Assign Built-In Policy: Allowed Locations

#### 🔹 Azure Portal:

1. Open **Azure Policy** from the Portal
2. Go to **Definitions** → Filter: **Built-in** → Search: `Allowed locations`
3. Select the **Allowed locations** policy → Click **+ Assign**
4. In the **Basics** tab:
   - **Scope:** Click the ellipsis → Select your subscription and `lab3e-rg`
   - **Assignment name:** `RestrictLocations`
5. Go to the **Parameters** tab:
   - Choose: `Australia East`
6. Click **Review + Create** → **Create**

> ✅ This will restrict future resource deployments in `lab3e-rg` to `Australia East` only.

#### 🔹 Azure CLI:

```bash
# Get the built-in policy ID for "Allowed locations"
az policy definition list \
  --query "[?displayName=='Allowed locations'].{id:id}" \
  -o tsv
```

> 🔎 The output is a policyDefinitionId like: `/providers/Microsoft.Authorization/policyDefinitions/LOCATION_RESTRICTION_POLICY_ID`

```bash
# Assign the policy to a specific resource group
az policy assignment create \
  --name RestrictLocations \
  --display-name "Restrict resources to Australia East" \
  --policy /providers/Microsoft.Authorization/policyDefinitions/<LOCATION_RESTRICTION_POLICY_ID> \
  --params '{"listOfAllowedLocations": {"value": ["australiaeast"]}}' \
  --scope "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab3e-rg"
```

> ⚠️ Replace `<LOCATION_RESTRICTION_POLICY_ID>` and `<SUBSCRIPTION_ID>` with your actual values.

---

### 3️⃣ Assign via ARM Template

#### 🔹 `policy-assignment.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Authorization/policyAssignments",
      "apiVersion": "2021-06-01",
      "name": "RestrictLocations",
      "properties": {
        "displayName": "Restrict resources to Australia East",
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/<LOCATION_RESTRICTION_POLICY_ID>",
        "parameters": {
          "listOfAllowedLocations": {
            "value": ["australiaeast"]
          }
        },
        "scope": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab3e-rg"
      }
    }
  ]
}
```

> 📘 The `apiVersion` 2021-06-01 is the latest stable as of June 2025.

#### 🔹 Deploy:

```bash
# Deploy policy assignment from template
az deployment sub create \
  --location australiaeast \
  --template-file policy-assignment.json
```

---

### 4️⃣ Test Policy Enforcement

Try to create a Storage Account in a **disallowed region** (e.g., `westus`):

```bash
az storage account create \
  --name lab3einvalidsa \
  --resource-group lab3e-rg \
  --location westus \
  --sku Standard_LRS
```

> ❌ This should fail with a `RequestDisallowedByPolicy` error, confirming enforcement.

---

### 5️⃣ View Compliance Results

#### 🔹 Azure Portal:

1. Go to **Azure Policy** → **Compliance**
2. Locate the `RestrictLocations` assignment
3. Review any non-compliant resource attempts

#### 🔹 Azure CLI:

```bash
# Check policy enforcement state
az policy state list \
  --query "[?policyAssignmentName=='RestrictLocations']"
```

> ✅ Compliance results show any violations or enforced actions.

---

### 6️⃣ Clean Up Resources

After testing, remove the resource group to avoid ongoing costs or residual assignments:

```bash
# Delete the test resource group and its contents
az group delete --name lab3e-rg --yes --no-wait
```

> 🧹 This removes the resource group and releases associated policy assignments.

## ✅ Lab Complete

You created and assigned a governance policy using Portal, CLI, and ARM; enforced allowed locations for resource deployment; and verified behavior using real test cases and compliance tools.

> 🔁 Azure Policy runs continuous evaluations—use **Initiatives** to group policies at scale.

