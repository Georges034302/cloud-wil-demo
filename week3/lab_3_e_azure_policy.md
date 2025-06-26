# 📜 Lab 3-E: Create and Assign Azure Policies (CLI, Portal, ARM)

## 🎯 Objective

- Understand the purpose of Azure Policy in enforcing governance
- Assign a built-in policy using Portal, CLI, and ARM
- Validate compliance enforcement and clean up

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
3. Click the **Allowed locations** policy → **+ Assign**  
4. In the **Basics** tab:  
   - Scope: Select your subscription and `lab3e-rg`  
   - Assignment name: `RestrictLocations`  
5. In the **Parameters** tab, choose `Australia East`  
6. Click **Review + Create** → **Create**

---

### 3️⃣ Assign Policy via CLI

#### 🔹 Step 1: Get the Policy Definition ID

```bash
az policy definition list \
  --query "[?displayName=='Allowed locations'].id" \
  -o tsv
```

> 📋 Copy the returned value, e.g.:
>
> `/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c`

---

#### 🔹 Step 2: Assign Using CLI

```bash
az policy assignment create \
  --name RestrictLocations \
  --display-name "Restrict resources to Australia East" \
  --policy <POLICY_DEFINITION_ID> \
  --params '{"listOfAllowedLocations": {"value": ["australiaeast"]}}' \
  --scope "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab3e-rg"
```

> 🔁 Replace `<POLICY_DEFINITION_ID>` and `<SUBSCRIPTION_ID>` with your actual values.

---

### 4️⃣ Assign Policy via ARM Template

#### 🔹 Step 1: Insert Policy Definition into Template

Create `policy-assignment.json` and **replace** `<POLICY_DEFINITION_ID>` with your copied value:

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
        "policyDefinitionId": "<POLICY_DEFINITION_ID>",
        "parameters": {
          "listOfAllowedLocations": {
            "value": ["australiaeast"]
          }
        }
      }
    }
  ]
}
```

---

#### 🔹 Step 2: Deploy the Template

```bash
az deployment group create \
  --resource-group lab3e-rg \
  --template-file policy-assignment.json
```

---

### 5️⃣ Test Policy Enforcement

Try to create a resource in a disallowed region:

```bash
az storage account create \
  --name lab3einvalidsa \
  --resource-group lab3e-rg \
  --location westus \
  --sku Standard_LRS
```

> ❌ Should fail with `RequestDisallowedByPolicy`.

---

### 6️⃣ View Compliance

#### 🔹 Azure CLI:

```bash
az policy state list \
  --query "[?policyAssignmentName=='RestrictLocations']"
```

#### 🔹 Azure Portal:

- Go to **Azure Policy** → **Compliance**
- Locate `RestrictLocations` assignment and view status

---

### 7️⃣ Clean Up Resources

```bash
az group delete --name lab3e-rg --yes --no-wait
```

---

## ✅ Lab Complete

You created, assigned, and validated a built-in Azure Policy using CLI and Portal, and deployed the same using an ARM template.
