# 🔐 Lab 4-B: Implement Role-Based Access Control (RBAC)

## 🎯 Objective

- Understand how RBAC secures access to Azure resources
- Assign a built-in role (Reader) to a user or group
- Use Azure Portal, CLI, and ARM templates to manage role assignments
- Validate role assignment and scope
- Practice least privilege access

---

## 🧰 Requirements

- Azure subscription with **Owner** or **User Access Administrator** role
- An Entra ID (Azure AD) user or group (e.g., `labuser1` or `lab-users` from Lab 4-A)
- Azure CLI installed and authenticated (`az login`)
- Access to [https://portal.azure.com](https://portal.azure.com)
- Create resource group (e.g., `lab4-rg`). 

  ```bash
    az group create --name lab4-rg --location australiaeast
  ```
  **Note:** This resource group will be use for all week 4 labs
---

## 👣 Lab Instructions

### 1️⃣ Assign Reader Role

#### 🔹 Azure Portal:

1. Go to the **Azure Portal** → Navigate to your **Resource Group** (e.g., `lab4-rg`)
2. Select **Access control (IAM)**
3. Click **+ Add** → **Add role assignment**
4. Set the following:
   - **Role**: `Reader`
   - **Assign access to**: `User`, `Group`, or `Service principal`
   - **Select**: `labuser1` or `lab-users`
5. Click **Review + assign**

✅ Role is applied.

#### 🔤 Azure CLI:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az role assignment create \
  --assignee labuser1@<yourdomain> \
  --role Reader \
  --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/lab4-rg
```

✅ Replace `<yourdomain>` with your Azure AD domain.

---

### 2️⃣ Role Assignment Using ARM Template

#### Get the User object ID (use it in the in ARM template '<USER_OBJECT_ID>')

```bash
  az ad user show --id labuser1@<yourdomain> --query objectId --output tsv
```
🛠 Replace:

- `<SUBSCRIPTION_ID>` with your actual subscription ID
- `<USER_OBJECT_ID>` with the object ID of `labuser1`

#### `rbac-assignment.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "name": "[guid(resourceGroup().id, 'labuser1-reader')]",
      "properties": {
        "roleDefinitionId": "/subscriptions/<SUBSCRIPTION_ID>/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7",
        "principalId": "<USER_OBJECT_ID>",
        "scope": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab4-rg"
      }
    }
  ]
}
```

#### Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab4-rg \
  --template-file rbac-assignment.json
```

✅ Automates Reader role assignment for the target user.

---

### 3️⃣ View and Validate Role Assignment

#### 🔹 Azure Portal:

1. Go to the **Resource Group** → **Access control (IAM)** → **Role assignments**
2. Filter by `User` or `Group` → Confirm `Reader` role for `labuser1` or `lab-users`

#### 🔤 Azure CLI:

```bash
az role assignment list \
  --assignee labuser1@<yourdomain> \
  --query "[].{Scope:scope, Role:roleDefinitionName}" \
  --output table
```

✅ Confirms scope and assigned role.

---

### 🔍 Post-Deployment Validation

#### 🧪 Access Check in Portal:

1. Open the **Resource Group** → **Access control (IAM)**
2. Click **Check access** → Select `labuser1`
3. Confirm Reader-level access appears as effective permissions

#### 🧪 Access Check via CLI:

```bash
az role assignment list \
  --assignee labuser1@<yourdomain> \
  --query "[?roleDefinitionName=='Reader'].[scope]" \
  --output table
```

✅ Verifies the user has the Reader role at the correct scope.

---

## ✅ Lab Complete

You've successfully implemented Role-Based Access Control using Portal, CLI, and ARM. You've also validated the permissions and applied least privilege principles to secure resource access.

