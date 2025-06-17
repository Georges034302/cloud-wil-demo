# 📜 Lab 3-E: Create and Assign Azure Policies

## 🎯 Objective

- Understand the purpose of Azure Policy in enforcing governance
- Create a built-in or custom policy definition
- Assign a policy to a resource group
- Validate policy compliance using the Azure Portal and CLI
- Learn how Azure Policy helps with security, cost control, and standardization

---

## 🧰 Requirements

- Active Azure subscription (Owner or Contributor role)
- Access to [https://portal.azure.com](https://portal.azure.com)
- Azure CLI installed and logged in (`az login`)
- An existing resource group (e.g., `lab3e-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Create a Built-In Policy Assignment

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Policy** → Open **Azure Policy** blade
3. In the left menu, click **Definitions**
4. Filter by **Built-in** and search for `Allowed locations`
5. Click the **Allowed locations** policy
6. Click **+ Assign**
7. Fill in:
   - **Scope**: Select your resource group (e.g., `lab3e-rg`)
   - **Assignment Name**: `RestrictLocations`
   - **Parameters**: Select `Australia East` as the only allowed region
8. Click **Review + Create** → **Create**

✅ Now, any new resources created **outside Australia East** will be denied.

---

### 2️⃣ Assign the Same Policy Using Azure CLI

#### 🖥️ Azure CLI:

Fetch your subscription ID:

```bash
az account show --query id --output tsv
```

Assign the policy:

```bash
az policy assignment create \
  --name RestrictLocations \
  --display-name "Restrict resources to Australia East" \
  --policy "/providers/Microsoft.Authorization/policyDefinitions/LOCATION_POLICY_ID" \
  --params '{"listOfAllowedLocations": {"value": ["australiaeast"]}}' \
  --scope "/subscriptions/<subscription-id>/resourceGroups/lab3e-rg"
```

🧠 Replace `LOCATION_POLICY_ID` with the actual policy ID for **Allowed locations**. ✅ Policy is now active on the scope.

---

### 3️⃣ Test the Policy Enforcement

Try deploying a resource outside the allowed region (e.g., West US):

- **Portal or CLI:** Create a Storage Account in `westus`
- ❌ The operation should **fail** due to policy restriction

✅ This confirms your policy works.

---

### 4️⃣ View Compliance State

#### 🔹 Azure Portal:

1. Go to **Azure Policy** → **Compliance**
2. Locate your policy assignment: `RestrictLocations`
3. Click it to view:
   - **Evaluation result**: Compliant / Non-compliant
   - **Affected resources**

#### 🖥️ Azure CLI:

```bash
az policy state list \
  --query "[?policyAssignmentName=='RestrictLocations']"
```

✅ CLI view of evaluation and compliance.

---

✔️ **Lab complete – you successfully assigned an Azure Policy, enforced a governance rule, and verified compliance using both Portal and CLI.**

