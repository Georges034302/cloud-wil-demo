# 📊 Lab 4-F: Monitor Network Security Groups with Azure Network Watcher

## 🎯 Objective

- Enable Azure Network Watcher in your region  
- Create and associate a Network Interface (NIC) and Virtual Machine (VM) with an NSG  
- Monitor effective NSG rules applied to the NIC  
- Analyze traffic flow using NSG flow logs  
- Perform all tasks using Azure Portal and CLI  
- Validate configuration post-deployment

---

## 🧰 Requirements

- Azure subscription  
- Azure CLI installed and logged in (`az login`)  
- Resource Group: `lab4-rg`  
- VNet: `lab4-vnet`
- Subnet: `web-subnet`
- Network Security Group: `web-nsg`  

---

## 1️⃣ Create NIC and Associate NSG

### **Azure Portal**

1. Go to **Network interfaces** → **Create**  
2. Name: `lab4-nic`, Resource Group: `lab4-rg`  
3. Virtual network: `lab4-vnet`, Subnet: `web-subnet`  
4. Network security group: Select `web-nsg`  
5. Complete the wizard.

### **Azure CLI**

```bash
az network nic create \
  --resource-group lab4-rg \
  --name lab4-nic \
  --vnet-name lab4-vnet \
  --subnet web-subnet \
  --network-security-group web-nsg
```

---

## 2️⃣ Create VM and Attach NIC

### **Azure Portal**

1. Go to **Virtual machines** → **Create**  
2. Name: `lab4-vm`, Resource Group: `lab4-rg`  
3. Select an image (e.g., Ubuntu LTS), Size: Standard_B1s  
4. Under **Networking**, select **lab4-nic** as the network interface  
5. Complete the wizard.

### **Azure CLI**

```bash
ADMIN_PASSWORD=P@ssword@$RANDOM

az vm create \
  --resource-group lab4-rg \
  --name lab4-vm \
  --nics lab4-nic \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --admin-password "$ADMIN_PASSWORD" \
  --authentication-type password \
  --output json
```

---

## 3️⃣ Enable Azure Network Watcher

### **Azure Portal**

1. Go to **Network Watcher**
2. Select region `Australia East`
3. Click **Enable Network Watcher** if not already enabled

### **Azure CLI**

```bash
az network watcher configure \
  --locations australiaeast \
  --resource-group lab4-rg \
  --enabled true
```

---

## 4️⃣ View Effective NSG Rules on the NIC

### **Azure Portal**

1. Navigate to **Virtual Machines**  
2. Select `lab4-vm` → **Networking** tab  
3. Click **Effective security rules** next to `lab4-nic`

### **Azure CLI**

```bash
az network watcher list-effective-nsg \
  --resource-group lab4-rg \
  --network-interface lab4-nic \
  --output
```
---

## 5️⃣ Create Storage Account for NSG Flow Logs

### **Azure CLI**

Use the following commands to create a unique storage account in your resource group:

```bash
STORAGE_NAME=lab4storage$RANDOM

az storage account create \
  --name $STORAGE_NAME \
  --resource-group lab4-rg \
  --location australiaeast \
  --sku Standard_LRS \
  --kind StorageV2 \
  --enable-hierarchical-namespace false
```

### 🔑 Assign Contributor Role to Storage Account (Azure Portal)

To allow a user, group, or service principal to manage your storage account (for example, to enable NSG flow logs or allow automation access), assign the **Contributor** role as follows:

### **Azure Portal Steps**

1. **Go to** Storage Accounts in the Azure Portal.
2. Click the storage account you want to assign permissions to (e.g., `lab4storage...`).
3. In the left menu, select **Access control (IAM)**.
4. Click **+ Add** (or **Add role assignment**).
5. In the **Role** dropdown, search for and select **Contributor**.
6. In the **Assign access to** dropdown, choose one of:
    - **User, group, or service principal** (for specific Azure AD users or apps)
    - **Managed identity** (if you want to assign to an Azure resource)
7. Click **Select members**.
8. Search for and select the user, group, or service principal you want to assign.
9. Click **Review + assign** (twice to confirm).

**Result:**  
The selected entity will have Contributor permissions to the storage account, allowing full management except access management.

---

## 6️⃣ Enable NSG Flow Logs

### **Azure Portal**

1. Go to **Network Watcher** → **NSG flow logs**
2. Select `web-nsg` → Click **Configure**
3. Set:
   - **Storage account**: select your Storage Account (e.g., `lab4storage<unique>`)
   - **Retention**: 7 days
4. Click **Enable**

### **Azure CLI**

```bash
az network watcher flow-log configure \
  --resource-group lab4-rg \
  --nsg-name web-nsg \
  --enabled true \
  --storage-account $STORAGE_NAME \
  --retention 7 \
  --traffic-analytics false
```

---

## 7️⃣ Validate Flow Log and Rule Configuration

### **Azure CLI**

Check flow log status:
```bash
az network watcher flow-log show \
  --resource-group lab4-rg \
  --nsg-name web-nsg \
  --output jsonc
```

List generated flow logs in storage:
```bash
az storage blob list \
  --account-name $STORAGE_NAME \
  --container-name insights-logs-networksecuritygroupflowevent \
  --output table
```

### 📊 Clean Up Resources (Important to delete week 4 resources)

```bash
# Delete the resource group and all resources
az group delete --name lab4-rg --yes --no-wait
```

---

## ✅ Lab Complete

- Deployed and configured Network Security Group (NSG) and associated it with a NIC and VM
- Enabled Azure Network Watcher in the target region
- Viewed effective NSG rules applied to the NIC using Portal and CLI
- Enabled and validated NSG flow logs, storing them in a storage account
- Listed and verified flow log data in Azure Storage
- Used both Portal and CLI for all major configuration and validation
