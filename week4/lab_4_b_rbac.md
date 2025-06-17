# 🔐 Lab 4-B: Implement Role-Based Access Control (RBAC)

## 🎯 Objective

- Understand how RBAC secures access to Azure resources
- Assign a built-in role (Reader) to a user or group
- Use both Azure Portal and Azure CLI to manage role assignments
- Validate role assignment and scope
- Practice least privilege access

---

## 🧰 Requirements

- Azure subscription with **Owner** or **User Access Administrator** role
- An Entra ID (Azure AD) user or group (e.g., `labuser1` or `lab-users` from Lab 4-A)
- Azure CLI installed and authenticated via `az login`
- Access to [https://portal.azure.com](https://portal.azure.com)
- Existing resource group (e.g., `lab4b-rg` or `lab3e-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Assign a Role to a User or Group

#### 🔹 Azure Portal:

1. Open [Azure Portal](https://portal.azure.com)
2. Navigate to the target **Resource Group** (e.g., `lab4b-rg`)
3. In the left pane, click **Access control (IAM)**
4. Click **+ Add** → **Add role assignment**
5. In the wizard:
   - **Role**: Select `Reader` (can view but not change resources)
   - **Assign access to**: Choose `User`, `Group`, or `Service principal`
   - **Select**: Choose `labuser1` or `lab-users`
6. Click **Review + assign**

✅ This grants read-only access to the resource group.

#### 🖥️ Azure CLI:

```bash
# Get subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Assign Reader role to the user or group
az role assignment create \
  --assignee labuser1@<yourdomain> \
  --role Reader \
  --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/lab4b-rg
```

🧠 Replace `<yourdomain>` with your Azure AD domain. ✅ Role assigned successfully.

---

### 2️⃣ View Role Assignments and Scope

#### 🔹 Azure Portal:

1. Navigate to the **Resource Group** → **Access control (IAM)**
2. Click **Role assignments** tab
3. Filter by **User** or **Group**
4. Click the entry to inspect:
   - **Role name**
   - **Scope**
   - Whether it is directly assigned or inherited

#### 🖥️ Azure CLI:

```bash
az role assignment list \
  --assignee labuser1@<yourdomain> \
  --output table
```

✅ Lists all roles assigned to the user, including scope and role name.

---

### 3️⃣ Validate Access Using Access Check

#### 🔹 Azure Portal:

1. Navigate to the **Resource Group** → **Access control (IAM)**
2. Click **Check access**
3. Search and select `labuser1` or `lab-users`
4. Click **View effective permissions**

✅ Portal will visually display effective access, including inherited permissions.

#### 🖥️ Azure CLI:

```bash
az role assignment list \
  --assignee labuser1@<yourdomain> \
  --query "[].{Scope: scope, Role: roleDefinitionName}" \
  --output table
```

✅ Shows scoped access and confirms least privilege.

---

✔️ **Lab complete – you successfully applied RBAC using the Reader role, verified access via portal and CLI, and practiced assigning least privilege permissions.**

