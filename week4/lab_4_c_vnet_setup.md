# 🌐 Lab 4-C: Create and Configure an Azure Virtual Network

## 🎯 Objective

- Understand the purpose of Virtual Networks (VNets) in Azure
- Create a VNet with multiple subnets
- Configure address spaces and subnet boundaries
- Deploy VNets using Portal, CLI, and ARM templates
- Validate the configuration with post-deployment verification

---

## 🧰 Requirements

- Azure subscription
- Azure Portal access: [https://portal.azure.com](https://portal.azure.com)
- Azure CLI installed and authenticated (`az login`)
- Existing resource group (e.g., `lab4-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Create a Resource Group

#### 🔹 Azure Portal:

1. Navigate to **Resource groups** → **+ Create**
2. Fill in:
   - **Name**: `lab4-rg`
   - **Region**: `Australia East`
3. Click **Review + Create** → **Create**

#### 🔤 Azure CLI:

```bash
az group create --name lab4-rg --location australiaeast
```

✅ Resource group created.

---

### 2️⃣ Create a Virtual Network with Subnets

#### 🔹 Azure Portal:

1. Go to **Virtual networks** → **+ Create**
2. **Basics** tab:
   - **Resource group**: `lab4-rg`
   - **Name**: `lab4-vnet`
   - **Region**: `Australia East`
3. **IP Addresses** tab:
   - **Address space**: `10.1.0.0/16`
   - **Subnets**:
     - `web-subnet`: `10.1.1.0/24`
     - `db-subnet`: `10.1.2.0/24`
4. Click **Review + Create** → **Create**

#### 🔤 Azure CLI:

```bash
az network vnet create \
  --name lab4-vnet \
  --resource-group lab4-rg \
  --location australiaeast \
  --address-prefix 10.1.0.0/16 \
  --subnet-name web-subnet \
  --subnet-prefix 10.1.1.0/24

az network vnet subnet create \
  --name db-subnet \
  --resource-group lab4-rg \
  --vnet-name lab4-vnet \
  --address-prefix 10.1.2.0/24
```

✅ VNet and subnets created.

---

### 3️⃣ Deploy VNet with ARM Template

#### `vnet-deployment.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-02-01",
      "name": "lab4-vnet",
      "location": "australiaeast",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["10.1.0.0/16"]
        },
        "subnets": [
          {
            "name": "web-subnet",
            "properties": {
              "addressPrefix": "10.1.1.0/24"
            }
          },
          {
            "name": "db-subnet",
            "properties": {
              "addressPrefix": "10.1.2.0/24"
            }
          }
        ]
      }
    }
  ]
}
```

#### 🔤 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab4-rg \
  --template-file vnet-deployment.json
```

✅ VNet and subnets deployed using ARM.

---

### 4️⃣ Validate VNet Configuration

#### 🔹 Azure Portal:

1. Go to **Virtual networks** → Select `lab4-vnet`
2. Click **Subnets**
3. Confirm:
   - `web-subnet` → `10.1.1.0/24`
   - `db-subnet` → `10.1.2.0/24`

#### 🔤 Azure CLI:

```bash
az network vnet subnet list \
  --resource-group lab4-rg \
  --vnet-name lab4-vnet \
  --output table
```

✅ Lists subnet names and ranges for confirmation.

---

## ✅ Lab Complete

You have successfully created an Azure Virtual Network with two subnets using the Portal, CLI, and ARM template. You also validated the deployment through both the Azure Portal and CLI.

