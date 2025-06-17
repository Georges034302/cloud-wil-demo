# 🌐 Lab 4-C: Create and Configure an Azure Virtual Network

## 🎯 Objective

- Understand the purpose of Virtual Networks (VNets) in Azure
- Create a VNet with multiple subnets
- Configure address spaces and subnet boundaries
- Deploy VNets using both Azure Portal and Azure CLI
- Understand VNet integration with Azure services and network security features

---

## 🧰 Requirements

- Azure subscription
- Azure Portal access: [https://portal.azure.com](https://portal.azure.com)
- Azure CLI installed and authenticated (`az login`)
- Existing resource group (e.g., `lab4c-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Resource groups** and click **+ Create**
3. Fill in:
   - **Name**: `lab4c-rg`
   - **Region**: `Australia East`
4. Click **Review + Create** → **Create**

#### 🖥️ Azure CLI:

```bash
az group create --name lab4c-rg --location australiaeast
```

✅ Resource group created.

---

### 2️⃣ Create a Virtual Network with Subnets

#### 🔹 Azure Portal:

1. Search for **Virtual networks** → Click **+ Create**
2. Under **Basics**:
   - **Resource group**: `lab4c-rg`
   - **Name**: `lab4c-vnet`
   - **Region**: `Australia East`
3. Under **IP Addresses**:
   - **IPv4 address space**: `10.1.0.0/16`
   - **Add subnet 1**:
     - **Name**: `web-subnet`
     - **Address range**: `10.1.1.0/24`
   - **Add subnet 2**:
     - **Name**: `db-subnet`
     - **Address range**: `10.1.2.0/24`
4. Click **Review + Create** → **Create**

✅ You now have a VNet with two logically separate subnets.

#### 🖥️ Azure CLI:

Create the VNet with the first subnet:

```bash
az network vnet create \
  --name lab4c-vnet \
  --resource-group lab4c-rg \
  --location australiaeast \
  --address-prefix 10.1.0.0/16 \
  --subnet-name web-subnet \
  --subnet-prefix 10.1.1.0/24
```

Add the second subnet:

```bash
az network vnet subnet create \
  --name db-subnet \
  --resource-group lab4c-rg \
  --vnet-name lab4c-vnet \
  --address-prefix 10.1.2.0/24
```

✅ Both subnets created successfully.

---

### 3️⃣ Verify the VNet and Subnets

#### 🔹 Azure Portal:

1. Go to **Virtual networks** → Select `lab4c-vnet`
2. In the left pane, click **Subnets**
3. Confirm:
   - `web-subnet` (10.1.1.0/24)
   - `db-subnet` (10.1.2.0/24)

#### 🖥️ Azure CLI:

```bash
az network vnet subnet list \
  --resource-group lab4c-rg \
  --vnet-name lab4c-vnet \
  --output table
```

✅ This confirms the configuration and address segmentation.

---

✔️ **Lab complete – you successfully created a Virtual Network with two subnets and validated the setup using both the Portal and Azure CLI.**

