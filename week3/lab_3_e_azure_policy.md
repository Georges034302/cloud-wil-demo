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
az group create --name lab3e-rg --location australiaeast
```

---

### 2️⃣ Assign Built-In Policy: Allowed Locations

#### 🔹 Azure Portal:

1. Open **Azure Policy** from the Portal
2. Go to **Definitions** → Filter: **Built-in** → Search: `Allowed locations`
3. Click policy → **+ Assign**
4. Scope: Select `lab3e-rg`
5. Name: `RestrictLocations` → Parameter: `Australia East`
6. Review + Create → Confirm

#### 🔹 Azure CLI:

Get policy definition ID:

```bash
az policy definition list --query "[?displayName=='Allowed locations'].{id:id}" -o tsv
```

Assign policy:

```bash
az policy assignment create \
  --name RestrictLocations \
  --display-name "Restrict resources to Australia East" \
  --policy <POLICY_ID_FROM_ABOVE> \
  --params '{"listOfAllowedLocations": {"value": ["australiaeast"]}}' \
  --scope "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab3e-rg"
```

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
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/<POLICY_ID>",
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

#### 🔹 Deploy:

```bash
az deployment sub create \
  --location australiaeast \
  --template-file policy-assignment.json
```

---

### 4️⃣ Test Policy Enforcement

Try creating a Storage Account in `westus`:

```bash
az storage account create \
  --name lab3einvalidsa \
  --resource-group lab3e-rg \
  --location westus \
  --sku Standard_LRS
```

❌ It should fail with a policy error.

---

### 5️⃣ View Compliance Results

#### 🔹 Azure Portal:

- Go to **Azure Policy** → **Compliance**
- Locate `RestrictLocations` → Review non-compliant resources

#### 🔹 Azure CLI:

```bash
az policy state list \
  --query "[?policyAssignmentName=='RestrictLocations']"
```

---

## ✅ Lab Complete

You created and assigned a governance policy using Portal, CLI, and ARM; enforced location rules; and validated policy behavior using test resources and compliance insights.

