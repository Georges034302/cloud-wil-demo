# 👥 Lab 4-A: Configure Microsoft Entra ID (Azure Active Directory)

## 🎯 Objective

- Understand the purpose of Microsoft Entra ID (Azure AD) for identity management
- Create a new user and group in Azure AD
- Assign the user to a group using both Azure Portal and Azure CLI
- Explore key directory settings and roles
- Learn how Entra ID integrates with access control in Azure

---

## 🧰 Requirements

- Azure subscription with Global Administrator or Contributor role
- Access to [https://portal.azure.com](https://portal.azure.com)
- Azure CLI installed and authenticated via `az login`

---

## 👣 Lab Instructions

### 1️⃣ Create a New User

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Microsoft Entra ID** or **Azure Active Directory**
3. In the left-hand menu, click **Users** → **+ New user**
4. Choose **Create user** (not Invite user)
5. Enter the following:
   - **User name**: `labuser1`
   - **Name**: `Lab User One`
   - **Password**: Auto-generate and copy it for login
6. Click **Create**

✅ User `labuser1` created successfully.

#### 🖥️ Azure CLI:

```bash
az ad user create \
  --display-name "Lab User One" \
  --user-principal-name labuser1@<yourdomain> \
  --password "TempP@ssword123" \
  --force-change-password-next-login true
```

🧠 Replace `<yourdomain>` with your actual Azure AD domain name.

---

### 2️⃣ Create a New Security Group

#### 🔹 Azure Portal:

1. From **Microsoft Entra ID**, click **Groups** → **+ New group**
2. Fill in:
   - **Group type**: Security
   - **Group name**: `lab-users`
   - **Membership type**: Assigned
3. Click **Create**

✅ Group `lab-users` is created.

#### 🖥️ Azure CLI:

```bash
az ad group create \
  --display-name "lab-users" \
  --mail-nickname "labusers"
```

✅ Security group created.

---

### 3️⃣ Add the User to the Group

#### 🔹 Azure Portal:

1. Open **lab-users** group → Click **Members** → **+ Add members**
2. Search and select `labuser1` → Click **Select**

✅ User is now a member of the group.

#### 🖥️ Azure CLI:

```bash
az ad group member add \
  --group "lab-users" \
  --member-id $(az ad user show --id labuser1@<yourdomain> --query objectId -o tsv)
```

🧠 Replace `<yourdomain>` with your Azure AD domain.

---

### 4️⃣ Explore Microsoft Entra Settings and Security Features

#### 🔹 Azure Portal:

1. In **Microsoft Entra ID**, review:
   - **Roles and administrators**: Explore roles like Global Admin, User Admin
   - **Enterprise applications**: View apps, SSO, and app registrations
   - **Security** → Check **Authentication methods**, **Sign-in logs**, **Audit logs**

✅ These features help manage identity, security, and access governance in Azure.

---

✔️ **Lab complete – you successfully created a user and group in Microsoft Entra ID, assigned group membership, and explored core identity features using both Azure Portal and CLI.**

