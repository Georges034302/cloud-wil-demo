# 🔐 Lab 4-D: Create and Apply a Network Security Group (NSG)

## 🎯 Objective

- Understand the purpose of Network Security Groups (NSGs)
- Create an NSG and define inbound/outbound rules
- Associate an NSG with a subnet
- Deploy and manage NSGs via Azure Portal and CLI
- Enforce network access control and segmentation

---

## 🧰 Requirements

- Azure subscription with Owner/Contributor role
- Existing Resource Group (e.g., `lab4c-rg`)
- Virtual Network `lab4c-vnet` with subnets `web-subnet` and `db-subnet`
- Azure CLI installed and authenticated (`az login`)

---

## 👣 Lab Instructions

### 1️⃣ Create a Network Security Group (NSG)

#### 🔹 Azure Portal:

1. Open [Azure Portal](https://portal.azure.com)
2. Search for **Network security groups** → Click **+ Create**
3. Under **Basics**:
   - **Resource group**: `lab4c-rg`
   - **Name**: `web-nsg`
   - **Region**: `Australia East`
4. Click **Review + Create** → **Create**

✅ `web-nsg` created successfully.

#### 🖥️ Azure CLI:

```bash
az network nsg create \
  --resource-group lab4c-rg \
  --name web-nsg \
  --location australiaeast
```

✅ NSG created via CLI.

---

### 2️⃣ Create an Inbound Rule to Allow HTTP (Port 80)

#### 🔹 Azure Portal:

1. Go to **Network security groups** → Select `web-nsg`
2. Click **Inbound security rules** → **+ Add**
3. Configure:
   - **Source**: Any
   - **Source port ranges**: `*`
   - **Destination**: Any
   - **Destination port ranges**: `80`
   - **Protocol**: TCP
   - **Action**: Allow
   - **Priority**: `100`
   - **Name**: `Allow-HTTP`
4. Click **Add**

✅ Port 80 is now allowed.

#### 🖥️ Azure CLI:

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

✅ Inbound rule created.

---

### 3️⃣ Associate NSG to a Subnet

#### 🔹 Azure Portal:

1. In **web-nsg**, go to **Subnets** → Click **+ Associate**
2. Select:
   - **Virtual network**: `lab4c-vnet`
   - **Subnet**: `web-subnet`
3. Click **OK**

✅ NSG is now attached to the subnet.

#### 🖥️ Azure CLI:

```bash
az network vnet subnet update \
  --vnet-name lab4c-vnet \
  --name web-subnet \
  --resource-group lab4c-rg \
  --network-security-group web-nsg
```

✅ NSG associated successfully.

---

### 4️⃣ Confirm Effective NSG Rules

#### 🔹 Azure Portal:

1. Go to any **VM or NIC** connected to `web-subnet`
2. Under **Networking**, click **Effective security rules**
3. Review applied NSG rules and inherited policies

💡 Use **Network Watcher** for additional NSG diagnostics.

#### 🖥️ Azure CLI:

```bash
az network watcher list-effective-nsg \
  --resource-group lab4c-rg \
  --network-interface <nic-name>
```

✅ Replace `<nic-name>` with your actual NIC name to verify applied rules.

---

✔️ **Lab complete – you created an NSG, added a rule to allow HTTP traffic, and associated it with a subnet using both Azure Portal and CLI.**

