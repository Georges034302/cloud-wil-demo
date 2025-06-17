# 🚀 Lab 3-A: Explore Azure Migrate

## 🎯 Objective

- Understand Azure Migrate’s purpose in cloud migration projects
- Explore the Azure Migrate portal interface
- Examine tools for migrating servers, databases, and web apps
- Identify real-world migration scenarios and tools used

---

## 🧰 Requirements

- **Microsoft Azure Account**
- **Azure Free Subscription**

---

## 👣 Lab Instructions

### 1️⃣ Access Azure Migrate in the Azure Portal

1. Go to [https://portal.azure.com](https://portal.azure.com)
2. Sign in with your Azure student or institutional account
3. In the search bar at the top, type **Azure Migrate** and select the service
4. Click on **Azure Migrate – Unified migration platform** to launch it

🧠 **Note:** Azure Migrate provides a unified dashboard for assessing and migrating on-premises resources (servers, databases, apps, VDIs).

---

### 2️⃣ Understand the Migration Workflow and Interface

Explore these areas on the Azure Migrate blade:
- **Top-level tabs:** Servers, Databases, Web Apps, VDI
- Hover over each tile under **Discover and Assess** and **Migrate**

🧠 **Three-Phase Migration Model:**
| Phase     | Description                                                                 |
|-----------|-----------------------------------------------------------------------------|
| Discover  | Connect to on-prem systems via agent or appliance                          |
| Assess    | Analyze readiness, estimate costs, map dependencies                        |
| Migrate   | Use guided tools to move workloads (with minimal downtime if possible)     |

---

### 3️⃣ Start the “Create Migration Project” Wizard *(Simulation Only)*

1. Click the **+ Create project** button
2. In the panel:
   - **Project name:** `migrate-lab-project`
   - **Geography:** Select `Australia East`
   - **Resource group:** Click **Create new** → Name it `lab3a-rg`

⚠️ **DO NOT** click the final **Create** button — this lab is exploratory only.

🔒 Real projects allocate storage and may incur cost or need permissions.

---

### 4️⃣ Explore Assessment and Migration Tools

Navigate to the **Tools** section on the Azure Migrate homepage:

- **Servers** → Review options for VMware, Hyper-V, physical servers
- **Databases** → Explore **Data Migration Assistant (DMA)** and **Azure Database Migration Service**
- **Web Apps** → Learn about the **App Service Migration Assistant**

📘 **Reference Table:**
| Migration Type | Tool                           | Description                                        |
|----------------|--------------------------------|----------------------------------------------------|
| Servers        | Azure Migrate Appliance       | Discovers and assesses physical/VM environments    |
| Databases      | Azure Database Migration Svc  | Migrates SQL Server, MySQL, PostgreSQL             |
| Web Apps       | App Service Migration Asst.   | Moves .NET, Java, PHP apps to Azure App Service    |
| Virtual Desktops | Citrix, VMware Horizon       | 3rd-party VDI solutions supported by Azure Migrate |

---

### 5️⃣ Identify a Real-World Migration Scenario

💬 **Discussion Task:**
Answer the following questions:

1. What types of apps might a university or business migrate to Azure?
2. Which Azure Migrate tools would you use for:
   - A **SQL Server database**
   - A **legacy ASP.NET web app**
   - A **set of on-prem virtual machines**

✅ Share responses in class or submit via LMS.

---

✔️ **Lab complete – you’ve explored Azure Migrate, reviewed migration tools, and identified scenarios where it applies.**

