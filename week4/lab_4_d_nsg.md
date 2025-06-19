# 🔐 Lab 4-D: Create and Apply a Network Security Group (NSG)

## 🌟 Objective

- Understand the purpose of Network Security Groups (NSGs)
- Create an NSG and define inbound/outbound rules
- Associate an NSG with a subnet
- Deploy and manage NSGs via Portal, CLI, and ARM
- Enforce network access control and segmentation
- Validate configuration using post-deployment tests

---

## 🧰 Requirements

- Azure subscription with Owner/Contributor role
- Existing Resource Group: `lab4c-rg`
- Virtual Network `lab4c-vnet` with subnets `web-subnet` and `db-subnet`
- Azure CLI installed and authenticated (`az login`)

---

## 👣 Lab Instructions

### 1️⃣ Create a Network Security Group (NSG)

#### 🔹 Azure Portal:

1. Go to **Network security groups** → Click **+ Create**
2. Under **Basics**:
   - Resource group: `lab4c-rg`
   - Name: `web-nsg`
   - Region: `Australia East`
3. Click **Review + Create** → **Create**

#### 🔤 Azure CLI:

```bash
az network nsg create \
  --resource-group lab4c-rg \
  --name web-nsg \
  --location australiaeast
```

---

### 2️⃣ Add Inbound Rule to Allow HTTP (Port 80)

#### 🔹 Azure Portal:

1. Go to **web-nsg** → **Inbound security rules** → **+ Add**
2. Set:
   - Source: `Any`
   - Source port ranges: `*`
   - Destination: `Any`
   - Destination port ranges: `80`
   - Protocol: `TCP`
   - Action: `Allow`
   - Priority: `100`
   - Name: `Allow-HTTP`
3. Click **Add**

#### 🔤 Azure CLI:

```bash
az network nsg rule create \
  --resource-group lab4c-rg \
  --nsg-name web-nsg \
  --name Allow-HTTP \
  --priority 100 \
  --source-address-prefixes '*' \
  --destination-port-ranges 80 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --description "Allow HTTP traffic"
```

---

### 3️⃣ Associate NSG with Subnet

#### 🔹 Azure Portal:

1. Go to **web-nsg** → **Subnets** → **+ Associate**
2. Select:
   - Virtual Network: `lab4c-vnet`
   - Subnet: `web-subnet`
3. Click **OK**

#### 🔤 Azure CLI:

```bash
az network vnet subnet update \
  --vnet-name lab4c-vnet \
  --name web-subnet \
  --resource-group lab4c-rg \
  --network-security-group web-nsg
```

---

### 4️⃣ Deploy NSG Using ARM Template

#### `nsg-deployment.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-02-01",
      "name": "web-nsg",
      "location": "australiaeast",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-HTTP",
            "properties": {
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "80",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*",
              "access": "Allow",
              "priority": 100,
              "direction": "Inbound"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks/subnets",
      "apiVersion": "2023-02-01",
      "name": "lab4c-vnet/web-subnet",
      "dependsOn": ["Microsoft.Network/networkSecurityGroups/web-nsg"],
      "properties": {
        "addressPrefix": "10.1.1.0/24",
        "networkSecurityGroup": {
          "id": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab4c-rg/providers/Microsoft.Network/networkSecurityGroups/web-nsg"
        }
      }
    }
  ]
}
```

> Replace `<SUBSCRIPTION_ID>` with your actual subscription ID.

#### 🔤 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab4c-rg \
  --template-file nsg-deployment.json
```

---

### 🔍 Post-Deployment Validation

#### 🔹 Azure Portal:

1. Navigate to **Virtual networks** → `lab4c-vnet` → **Subnets**
2. Confirm `web-subnet` is linked to `web-nsg`
3. Go to **Network security groups** → `web-nsg` → **Inbound rules** → Ensure `Allow-HTTP` is listed

#### 🔤 Azure CLI:

```bash
az network vnet subnet show \
  --vnet-name lab4c-vnet \
  --name web-subnet \
  --resource-group lab4c-rg \
  --query "networkSecurityGroup.id"

az network nsg rule list \
  --resource-group lab4c-rg \
  --nsg-name web-nsg \
  --output table
```

✅ Verifies NSG is linked to subnet and rules are applied.

---

## ✅ Lab Complete

You successfully created and applied an NSG using Portal, CLI, and ARM. You also validated NSG rules and subnet association to enforce traffic control in Azure networking.

