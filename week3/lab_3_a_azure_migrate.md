# 🚀 Lab 3-A: Explore Azure Migrate with CLI, Portal, and ARM Template

## 🌟 Objective

- Understand Azure Migrate’s purpose in cloud migration projects
- Explore Azure Migrate via Portal, CLI, and ARM
- Review tools for migrating servers, databases, and web apps
- Perform post-deployment validation

---

## 🧰 Requirements

- **Azure CLI** installed
- **Azure Portal access**
- **Free or Pay-As-You-Go subscription**

---

## 👣 Lab Instructions

### 1⃣ Explore Azure Migrate via Azure Portal

1. Sign in to [https://portal.azure.com](https://portal.azure.com) with your Azure credentials.
2. In the **Search** bar at the top, type **Azure Migrate** and select **Azure Migrate: Discovery and assessment** from the results.
3. On the Azure Migrate overview page, click **+ Create project**.
4. In the **Create Azure Migrate Project** form:
   - **Subscription:** Select your active Azure subscription.
   - **Resource group:** Click **Create new** → enter `lab3a-rg` → click **OK**.
   - **Project name:** Enter `migrate-lab-project`.
   - **Geography:** Choose `Australia East` (or any geography close to your workloads).
5. Click **Next: Tags** (optional) → add tags if needed → click **Next: Review + create**.
6. On the Review + Create page, ensure validation passes.
7. Click **Create** to provision the project.
8. Wait until deployment completes → click **Go to resource**.

> ✅ You now have a functional Azure Migrate project set up in your resource group. This portal workflow supports further configuration for server, database, and web app migrations.

> ✅ Azure Migrate supports Servers, Databases, Web Apps, and VDI migration workflows.

---

### 2⃣ Azure Migrate Project via CLI

#### 🔹 Create Resource Group

```bash
# Create a resource group in Australia East
az group create --name lab3a-rg --location australiaeast
```

> ⚠️ As of now, Azure CLI does not support direct creation of Azure Migrate projects. Use the Azure Portal to create the project.

---

### 3⃣ Azure Migrate via ARM Template

> ⚠️ As of June 2025, **Azure Migrate resources are not supported** via ARM templates. Attempting to deploy using `Microsoft.Migrate/projects` will result in an `InvalidResourceType` error.
>
> ✅ Use the Azure Portal only to create Azure Migrate projects.

---

### 4⃣ Explore Assessment and Migration Tools (Portal)

1. Go to **Azure Migrate** → Select your project → Review **Tiles**
2. Click **Servers** tab → see migration options for Hyper-V, VMware, and physical servers
3. Click **Databases** tab → see Data Migration Assistant & Azure DMS
4. Click **Web Apps** → view App Service Migration Assistant

---

### 5⃣ Real-World Migration Scenarios

| Migration Type  | Tool                             |
| --------------- | -------------------------------- |
| On-prem VMs     | Azure Migrate Appliance          |
| SQL Server      | Azure Database Migration Service |
| Legacy Web Apps | App Service Migration Assistant  |

---

### 6⃣ Post-Deployment Testing (Portal)

#### ✅ Confirm in Portal

1. Go to **Resource Group** → `lab3a-rg`
2. You should see the Azure Migrate project
3. Open it → Confirm tabs (Servers, Databases, Web Apps) are available

---

### 📊 Clean Up Resources

```bash
# Delete the resource group and all resources
az group delete --name lab3a-rg --yes --no-wait
```

---

## ✅ Lab Complete

You’ve successfully explored Azure Migrate using the Azure Portal. You verified setup and explored real-world migration tools and scenarios.

> 🔁 Note: Programmatic deployment (CLI or ARM) for Azure Migrate projects is currently not supported.

