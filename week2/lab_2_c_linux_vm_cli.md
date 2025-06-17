# 🐧 Lab 2-C: Create and Manage a Linux Virtual Machine Using Azure CLI

## 🎯 Objective

- Create a Linux VM using Azure CLI with password authentication
- Understand default network setup (VNet, NSG)
- Connect to the VM using SSH
- Perform lifecycle operations: start, stop, restart, resize
- Retrieve public IP and VM status

---

## 🧰 Requirements

- **Azure CLI** installed
- **Visual Studio Code** with Bicep extension (recommended)

---

## 👣 Lab Instructions

### 1️⃣ Create a Linux VM Using Azure CLI

🔹 **Command:**

```bash
az group create --name lab2c-rg --location australiaeast
```

✅ Creates a resource group for the VM.

🔹 **Create VM:**

```bash
az vm create \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --image UbuntuLTS \
  --admin-username azureuser \
  --admin-password MySecurePassword123! \
  --authentication-type password
```

✅ Provisions:

- Resource group, VNet, Subnet
- NIC, NSG (port 22 open)
- Public IP address

📝 **Note** the `publicIpAddress` in the output — you'll use it to connect in Step 2.

---

### 2️⃣ Connect to the Linux VM via SSH

🔹 **From Terminal or PowerShell:**

```bash
ssh azureuser@<public-ip-address>
```

- Type `yes` if prompted
- Enter the admin password

✅ You are now connected to the Linux VM.

---

### 3️⃣ View VM Information

🔹 **Get VM Details:**

```bash
az vm show \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --output table
```

✅ View location, size, status, and resource ID.

---

### 4️⃣ Resize the Virtual Machine

🔹 **Stop VM (deallocate):**

```bash
az vm deallocate --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

🔹 **Resize to a different SKU:**

```bash
az vm resize \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --size Standard_B2s
```

🔹 **Restart VM:**

```bash
az vm start --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

---

### 5️⃣ Power Operations (Start/Stop/Restart)

🔹 **Stop VM:**

```bash
az vm deallocate --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

🔹 **Start VM:**

```bash
az vm start --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

🔹 **Restart VM:**

```bash
az vm restart --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

✅ Each operation returns a provisioning status.

---

### 6️⃣ Retrieve VM Details

🔹 **Get Public IP:**

```bash
az vm list-ip-addresses \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --output table
```

🔹 **Check VM Status:**

```bash
az vm get-instance-view \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --query instanceView.statuses[1] --output table
```

✅ You've successfully created and managed a Linux VM using Azure CLI!

---

✔️ **Lab complete – you’ve created, accessed, and managed a Linux virtual machine using command-line operations.**

