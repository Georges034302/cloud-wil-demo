# 🏭 Azure Orientation: Exploring Azure Portal and Cloud Foundations

## 🎯 Objective

Familiarize yourself with core components of Azure by navigating the Azure Portal, exploring cloud service models, and identifying key services and monitoring tools.

---

## 🧰 Requirements

- Microsoft Azure Account
- Azure Free Subscription

---

## 👣 Step-by-Step Instructions (Azure Portal)

### 1️⃣ Sign in and Explore the Azure Portal

🔹 **Instructions:**

1. Go to [https://portal.azure.com](https://portal.azure.com)  
2. Sign in with your Azure account  
3. Explore the **Home Dashboard**  
4. Use the **Global Search Bar** to locate services  
5. Pin 3 services (e.g., Virtual Machines, Storage, App Services) to the left navigation bar  
6. Understand how services are organized by **region** and **resource type**

---

### 2️⃣ Create a Resource Group (No Deployment)

🔹 **Instructions:**

1. Go to **Resource groups**  
2. Click **+ Create**  
3. Set the following:
   - **Subscription**: Your default or assigned subscription  
   - **Resource Group Name**: `lab1-intro-rg`  
   - **Region**: Australia East  
4. Click **Review + Create**, then **Create**  

📝 **Reflection Prompt:**  
Why is grouping resources important in different deployment models (IaaS, PaaS, SaaS)?

---

### 3️⃣ Navigate Core Azure Services

🔹 **Instructions:**

1. Use the search bar to locate the following services:
   - **Virtual Machines**
   - **Storage Accounts**
   - **App Services**
2. For each service:
   - Read the **service description**
   - Note available **pricing tiers**
   - Click **Pin to Dashboard**

📝 **Task:**  
Identify one real-world use case per service.

---

### 4️⃣ Cloud Service Models Exploration

🔹 **Instructions:**

1. Go to [https://azure.microsoft.com/en-us/services](https://azure.microsoft.com/en-us/services)  
2. Classify these services:
   - **Virtual Machines** → IaaS  
   - **App Service** → PaaS  
   - **Microsoft 365** → SaaS  

📝 **Task:**  
List two more Azure services per category (IaaS, PaaS, SaaS)

---

### 5️⃣ Explore Monitoring and Logs

🔹 **Instructions:**

1. Open **Monitor** from the left-hand menu  
2. Navigate to:
   - **Activity Log** → View historical activity  
   - **Metrics** → Explore charts by selecting subscription/resource  

📝 **Prompt:**  
What default metrics does Azure collect, and why are they important?

---

### 6️⃣ Azure Migrate Overview

🔹 **Instructions:**

1. Use search to locate **Azure Migrate**  
2. Click **+ Project** (no need to complete setup)  
3. Review migration options:
   - Server Migration  
   - Database Migration  
   - Web App Migration  

📝 **Prompt:**  
Which types of apps or systems can Azure Migrate support?

---

### 7️⃣ View Azure Subscription and IAM Role

🔹 **Instructions:**

1. Go to **Subscriptions** → Select your active subscription  
2. Under **Access Control (IAM)**:
   - View your role (Reader, Contributor, Owner)  
   - Explore predefined roles under **Role Assignments**  

📝 **Prompt:**  
What access does your current role provide?

---

### 8️⃣ Explore Infrastructure as Code (IaC)

🔹 **Instructions:**

1. Visit [Azure Resource Manager Templates Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)  
2. Optional: Search for **Template Specs** in the portal  

📝 **Prompt:**  
What are the key benefits of defining infrastructure with code in Azure?

---

✅ **Lab complete – you’ve explored the foundations of Azure, including the portal, services, monitoring tools, IAM roles, and IaC!**

