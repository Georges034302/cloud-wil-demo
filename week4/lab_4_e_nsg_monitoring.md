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

1. Search for **Network Watcher**
2. Select region `Australia East`
3. Click **Enable Network Watcher** (if not already enabled)

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

1. Go to **Virtual machines** → Select VM
2. Click **Networking** → **Effective security rules**

#### 🔤 Azure CLI:

```bash
az network watcher list-effective-nsg \
  --resource-group lab4c-rg \
  --network-interface <nic-name> \
  --output table
```

✅ Replace `<nic-name>` with your VM's NIC name.

---

### 3️⃣ Enable NSG Flow Logs

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → **NSG flow logs**
2. Select `web-nsg` → Click **Configure**
3. Set:
   - **Storage account** for logs
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

✅ Replace `<storage-name>` with your actual storage account.

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

---

### 4️⃣ Validate Flow Log Configuration

#### 🔤 Azure CLI:

```bash
az network watcher flow-log show \
  --resource-group lab4c-rg \
  --nsg-name web-nsg
```

✅ Confirms settings, retention, and storage location.

---

## ✅ Lab Complete

You successfully enabled and configured Azure Network Watcher, verified NSG enforcement on NICs, and activated NSG flow logging using Portal, CLI, and ARM. You also validated the deployment to ensure proper logging and rule visibility.

