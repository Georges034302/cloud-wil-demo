# 👥 Lab 4-A: Configure Microsoft Entra ID (Azure Active Directory)

## 🌟 Objective

- Understand the purpose of Microsoft Entra ID (Azure AD) for identity management
- Create a new user and group in Azure AD
- Assign the user to a group using Portal, CLI, and ARM
- Explore directory roles, groups, and authentication logs
- Validate the user-to-group relationship post-deployment

---

## 🧰 Requirements

- Azure subscription with **Global Administrator** or **Contributor** role
- Access to [https://portal.azure.com](https://portal.azure.com)
- Azure CLI installed and authenticated (`az login`)
- An Azure AD tenant linked to your subscription

---

## 👣 Lab Instructions

### 1️⃣ Create a New User

#### 🔹 Azure Portal:

1. Go to **Microsoft Entra ID** → **Users** → **+ New user**
2. Choose **Create user**
3. Enter:
   - **User name**: `labuser1`
   - **Name**: `Lab User One`
   - **Password**: Auto-generate or set manually
4. Click **Create**

#### 🔤 Azure CLI:

```bash
az ad user create \
  --display-name "Lab User One" \
  --user-principal-name labuser1@<yourdomain> \
  --password "TempP@ssword123" \
  --force-change-password-next-login true
```

✅ Replace `<yourdomain>` with your tenant's domain (e.g., `contoso.onmicrosoft.com`).

---

### 2️⃣ Create a Security Group

#### 🔹 Azure Portal:

1. Go to **Microsoft Entra ID** → **Groups** → **+ New group**
2. Fill in:
   - **Group type**: Security
   - **Group name**: `lab-users`
   - **Membership type**: Assigned
3. Click **Create**

#### 🔤 Azure CLI:

```bash
az ad group create \
  --display-name "lab-users" \
  --mail-nickname "labusers"
```

✅ Group created successfully.

---

### 3️⃣ Add User to Group

#### 🔹 Azure Portal:

1. Go to **Groups** → `lab-users`
2. Select **Members** → **+ Add members**
3. Search `labuser1` → Click **Select**

#### 🔤 Azure CLI:

```bash
az ad group member add \
  --group "lab-users" \
  --member-id $(az ad user show --id labuser1@<yourdomain> --query objectId -o tsv)
```

---

### 4️⃣ ARM Template to Automate Setup

#### `entra-id-setup.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "name": "[guid(resourceGroup().id, 'Lab User Role Assignment')]",
      "properties": {
        "principalId": "<USER_OBJECT_ID>",
        "roleDefinitionId": "/subscriptions/<SUBSCRIPTION_ID>/providers/Microsoft.Authorization/roleDefinitions/<ROLE_ID>",
        "scope": "/subscriptions/<SUBSCRIPTION_ID>"
      }
    }
  ]
}
```

🛠 Replace:

- `<USER_OBJECT_ID>` with output from `az ad user show`
- `<ROLE_ID>` with a role like **Reader**: `acdd72a7-3385-48ef-bd42-f606fba81ae7`
- `<SUBSCRIPTION_ID>` with your subscription ID

#### Deploy via CLI:

```bash
az deployment sub create \
  --location australiaeast \
  --template-file entra-id-setup.json
```

✅ Automates role assignment and identity management.

---

### 🔍 Post-Deployment Validation

#### Azure Portal:

- Go to **lab-users** group → Check **Members** tab → Confirm `labuser1` is listed
- Go to **Users** → Select `labuser1` → Confirm group membership under **Groups** tab

#### Azure CLI:

```bash
az ad group member check --group lab-users --member-id $(az ad user show --id labuser1@<yourdomain> --query objectId -o tsv)
```

You should get `{ "value": true }`

✅ Identity and group configuration successfully validated.

---

## ✅ Lab Complete

You have configured Microsoft Entra ID by creating a user and group, assigning group membership via CLI and Portal, and validated it using both interfaces and ARM. You are now ready to apply Entra ID to access control scenarios across Azure.

