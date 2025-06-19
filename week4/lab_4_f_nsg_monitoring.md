# 📊 Lab 4-F: Monitor Network Security Groups with Azure Network Watcher

## 🎯 Objective

- Enable Azure Network Watcher in your region
- Monitor effective NSG rules applied to network interfaces
- Analyze traffic flow using NSG flow logs
- Perform tasks using Portal, CLI, and ARM
- Validate configuration post-deployment

---

## 🧰 Requirements

- Azure subscription
- Azure CLI installed and logged in (`az login`)
- Existing Resource Group: `lab4c-rg`
- Existing NSG: `web-nsg`
- Existing VNet and subnet with NIC (e.g., VM in `web-subnet`)
- Existing storage account for log retention

---

## 👣 Lab Instructions

### 1️⃣ Enable Azure Network Watcher

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Network Watcher**
3. Select the region `Australia East`
4. If disabled, click **Enable Network Watcher**

#### 🔤 Azure CLI:

```bash
az network watcher configure \
  --locations australiaeast \
  --resource-group lab4c-rg \
  --enabled true
```

✅ Network Watcher is now active.

#### 🧱 ARM Template Snippet:

```json
{
  "type": "Microsoft.Network/networkWatchers",
  "apiVersion": "2022-07-01",
  "name": "NetworkWatcher_australiaeast",
  "location": "australiaeast",
  "properties": {}
}
```

Deploy with:

```bash
az deployment group create \
  --resource-group lab4c-rg \
  --template-file networkwatcher-deployment.json
```

---

### 2️⃣ View Effective NSG Rules on a NIC

#### 🔹 Azure Portal:

1. Navigate to **Virtual Machines**
2. Select your VM → Click **Networking**
3. Click **Effective security rules** to view enforced NSG rules

#### 🔤 Azure CLI:

```bash
az network watcher list-effective-nsg \
  --resource-group lab4c-rg \
  --network-interface <nic-name> \
  --output table
```

✅ Replace `<nic-name>` using:
```bash
az vm show \
  --resource-group lab4c-rg \
  --name <vm-name> \
  --query 'networkProfile.networkInterfaces[0].id' \
  --output tsv
```

---

### 3️⃣ Enable NSG Flow Logs

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → Click **NSG flow logs**
2. Select `web-nsg` → Click **Configure**
3. Set:
   - **Storage account**: select existing one
   - **Retention**: 7 days
4. Click **Enable**

#### 🔤 Azure CLI:

```bash
az network watcher flow-log configure \
  --resource-group lab4c-rg \
  --nsg-name web-nsg \
  --enabled true \
  --storage-account <storage-name> \
  --retention 7 \
  --traffic-analytics false
```

✅ Replace `<storage-name>` with your actual Storage Account name.

#### 🧱 ARM Template Snippet:

```json
{
  "type": "Microsoft.Network/networkWatchers/flowLogs",
  "apiVersion": "2022-07-01",
  "name": "NetworkWatcher_australiaeast/flowLog-web-nsg",
  "location": "australiaeast",
  "properties": {
    "enabled": true,
    "storageId": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab4c-rg/providers/Microsoft.Storage/storageAccounts/<storage-name>",
    "targetResourceId": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/lab4c-rg/providers/Microsoft.Network/networkSecurityGroups/web-nsg",
    "retentionPolicy": {
      "days": 7,
      "enabled": true
    }
  }
}
```

Replace `<SUBSCRIPTION_ID>` and `<storage-name>` accordingly.

---

### 4️⃣ Validate Flow Log and Rule Configuration

#### 🔤 Azure CLI:

Check flow log status:

```bash
az network watcher flow-log show \
  --resource-group lab4c-rg \
  --nsg-name web-nsg \
  --output jsonc
```

Verify logs in Storage Account:

```bash
az storage blob list \
  --account-name <storage-name> \
  --container-name insights-logs-networksecuritygroupflowevent \
  --output table
```

✅ Confirms NSG log delivery and policy effectiveness.

---

## ✅ Lab Complete

You successfully enabled Azure Network Watcher, validated effective NSG rules on a NIC, and activated and verified NSG flow logging using Portal, CLI, and ARM. Diagnostics and telemetry now support ongoing network security monitoring.

