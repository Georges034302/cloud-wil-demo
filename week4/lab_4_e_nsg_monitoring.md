# 📊 Lab 4-F: Monitor Network Security Groups with Azure Network Watcher

## 🎯 Objective

- Enable Azure Network Watcher in your region
- Monitor effective NSG rules applied to network interfaces
- Analyze traffic flow using NSG flow logs
- Use both Portal and CLI for monitoring tasks

---

## 🧰 Requirements

- Azure subscription
- Azure CLI installed and logged in (`az login`)
- Existing Resource Group: `lab4c-rg`
- Existing VNet and NSG setup (from Lab 4-D)
- Existing subnet with a VM or NIC for monitoring (e.g. `web-subnet`)

---

## 👣 Lab Instructions

### 1️⃣ Enable Azure Network Watcher

#### 🔹 Azure Portal:

1. Search **Network Watcher** → Select your region (e.g. `Australia East`)
2. Click **Enable Network Watcher** for that region if not already enabled

#### 🖥️ Azure CLI:

```bash
az network watcher configure \
  --locations australiaeast \
  --resource-group lab4c-rg \
  --enabled true
```

✅ Network Watcher is now active.

---

### 2️⃣ List Effective NSG Rules on a NIC

#### 🔹 Azure Portal:

1. Go to **Virtual machines** → Select your VM → **Networking**
2. Click **Effective security rules** to see enforced NSG rules

#### 🖥️ Azure CLI:

```bash
az network watcher list-effective-nsg \
  --resource-group lab4c-rg \
  --network-interface <nic-name> \
  --output table
```

✅ Replace `<nic-name>` with the NIC attached to the VM.

---

### 3️⃣ Enable NSG Flow Logs

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → **NSG flow logs**
2. Select the NSG (e.g. `web-nsg`) → Click **Configure**
3. Choose a **Storage account** to store logs
4. Set **Retention** to 7 days
5. Click **Enable**

#### 🖥️ Azure CLI:

```bash
az network watcher flow-log configure \
  --resource-group lab4c-rg \
  --nsg-name web-nsg \
  --enabled true \
  --storage-account <storage-name> \
  --retention 7 \
  --traffic-analytics false
```

✅ Replace `<storage-name>` with an existing storage account name.

---

### 4️⃣ Verify Flow Log Settings

#### 🖥️ Azure CLI:

```bash
az network watcher flow-log show \
  --resource-group lab4c-rg \
  --nsg-name web-nsg
```

✅ Returns status, storage details, retention period.

---

✔️ **Lab complete – you monitored NSGs with Azure Network Watcher, verified effective rules on NICs, and enabled flow logs using both the Portal and CLI.**

