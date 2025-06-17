# 📊 Lab 4-F: Use Azure Network Watcher for Diagnostics

## 🎯 Objective

- Understand the role of Azure Network Watcher in monitoring and diagnostics
- Enable Network Watcher in a region
- Use connection troubleshooting tools like IP Flow Verify, Connection Troubleshoot, and NSG Diagnostics
- Capture and view network traffic logs
- Execute all diagnostics from both the Portal and Azure CLI

---

## 🧰 Requirements

- Azure subscription
- Azure CLI installed and logged in (`az login`)
- Existing VNet and NSG setup (e.g., from Lab 4-C and 4-D)
- Deployed VM or subnet with NSG rules

---

## 👣 Lab Instructions

### 1️⃣ Enable Azure Network Watcher

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Network Watcher** → Click **Regions**
3. If `Australia East` is not enabled, click **Enable**

#### 🖥️ Azure CLI:

```bash
az network watcher configure \
  --locations australiaeast \
  --resource-group lab4c-rg \
  --enabled true
```

✅ Ensures Network Watcher tools are available in the selected region.

---

### 2️⃣ Verify IP Flow (NSG Evaluation)

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → Select **IP Flow Verify**
2. Choose:
   - **Subscription**, **Resource Group**, **VM name**
   - **Direction**: Inbound
   - **Protocol**: TCP
   - **Local IP**: VM's private IP
   - **Local Port**: 22 or 80
   - **Remote IP**: any public IP (e.g. 8.8.8.8)
   - **Remote Port**: * or 54321
3. Click **Check**

✅ View Allowed/Denied status and matching NSG rule.

#### 🖥️ Azure CLI:

```bash
az network watcher test-ip-flow \
  --resource-group lab4c-rg \
  --direction Inbound \
  --protocol TCP \
  --local <vm-private-ip> \
  --local-port 22 \
  --remote-ip 8.8.8.8 \
  --remote-port 54321 \
  --vm-name lab-vm
```

✅ Replace `<vm-private-ip>` with your actual VM IP using:
```bash
az vm list-ip-addresses --name lab-vm --output table
```

---

### 3️⃣ Run Connection Troubleshoot

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → Click **Connection Troubleshoot**
2. Fill in:
   - **Source VM**: lab-vm
   - **Destination IP/FQDN**: www.microsoft.com
   - **Destination Port**: 443
3. Click **Check**

✅ Displays whether the connection is successful and where it may be blocked.

#### 🖥️ Azure CLI:

```bash
az network watcher connection-monitor test \
  --source-resource lab-vm \
  --dest-address www.microsoft.com \
  --dest-port 443
```

✅ Returns connection success/failure and path trace.

---

### 4️⃣ Run NSG Diagnostics

#### 🔹 Azure Portal:

1. Go to **Network Watcher** → Select **NSG Diagnostics**
2. Choose the NSG (e.g., `web-nsg`)
3. Review rules and traffic impact

#### 🖥️ Azure CLI:

```bash
az network watcher list-effective-nsg \
  --resource-group lab4c-rg \
  --network-interface <nic-name>
```

✅ Displays NSG rules applied to NIC or subnet.

---

✔️ **Lab complete – you enabled Network Watcher, ran IP Flow Verify, Connection Troubleshoot, and NSG Diagnostics using Azure Portal and CLI.**

