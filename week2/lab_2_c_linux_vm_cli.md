# 🐧 Lab 2-C: Create and Manage a Linux Virtual Machine Using Azure CLI, Portal, and ARM Templates

## 🎯 Objective

- Create a Linux VM using Azure CLI, Portal, and ARM template
- Understand default network setup (VNet, NSG, NIC)
- Connect to the VM using SSH
- Perform lifecycle operations (start, stop, restart, resize)
- Retrieve VM public IP and status

---

## 🧰 Requirements

- Azure subscription with **Contributor** access
- **Azure CLI** installed (`az version`)
- (Optional) **Visual Studio Code** for editing ARM templates

---

## 👣 Lab Instructions

### 1️⃣ Create a Linux VM Using Azure CLI

#### 🔹 Create Resource Group:

```bash
az group create --name lab2c-rg --location australiaeast
```

#### 🔹 Create Linux VM (Ubuntu2204):

```bash
az vm create \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --admin-password 'MySecurePassword123!' \
  --authentication-type password \
  --output json
```

✅ Provisions:

- VNet, Subnet, NIC, NSG (opens port 22)
- Public IP and DNS name

🔑 Save the **publicIpAddress** shown in the output.

---

### 2️⃣ Connect to the Linux VM via SSH

#### 🔹 Terminal Command:

```bash
VM_IP=$(az vm list-ip-addresses \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" \
  --output tsv)
ssh azureuser@<"$VM_IP"
```

✅ Accept SSH key prompt and enter the password to connect.

---

### 3️⃣ View VM Details

#### 🔹 Get VM Info:

```bash
az vm show \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --output table
```

#### 🔹 Get Public IP:

```bash
az vm list-ip-addresses \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --output table
```

#### 🔹 Get VM Status:

```bash
az vm get-instance-view \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --query instanceView.statuses[1] \
  --output table
```

---

### 4️⃣ Resize the Virtual Machine

#### 🔹 Stop (Deallocate) VM:

```bash
az vm deallocate \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm
```

#### 🔹 Resize VM:

```bash
az vm resize \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm \
  --size Standard_B2s
```

#### 🔹 Start VM:

```bash
az vm start \
  --resource-group lab2c-rg \
  --name lab2c-ubuntu-vm
```

---

### 5️⃣ Perform Power Operations

#### 🔹 Stop VM:

```bash
az vm deallocate --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

#### 🔹 Start VM:

```bash
az vm start --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

#### 🔹 Restart VM:

```bash
az vm restart --resource-group lab2c-rg --name lab2c-ubuntu-vm
```

---

### 6️⃣ Deploy Linux VM via Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **+ Create a resource** → **Ubuntu Server**
3. Set:
   - **Resource Group**: `lab2c-rg`
   - **VM Name**: `lab2c-ubuntu-vm`
   - **Region**: `Australia East`
   - **Authentication type**: Password
   - **Username**: `azureuser`
   - **Password**: `MySecurePassword123!`
4. Accept defaults for other settings
5. Click **Review + create** → **Create**

✅ Deployment includes VNet, NIC, NSG, and public IP.

---

### 7️⃣ Deploy Linux VM Using ARM Template

#### 🔹 `vmdeploy.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": { "type": "string" },
    "adminUsername": { "type": "string" },
    "adminPassword": { "type": "securestring" },
    "location": { "type": "string", "defaultValue": "australiaeast" }
  },
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2022-08-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_B1s"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "Canonical",
            "offer": "UbuntuServer",
            "sku": "18.04-LTS",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'), '-nic'))]"
            }
          ]
        }
      },
      "dependsOn": [
        "[concat('Microsoft.Network/networkInterfaces/', parameters('vmName'), '-nic')]"
      ]
    }
  ]
}
```

#### 🔹 Parameters (`vmdeploy.parameters.json`):

```json
{
  "parameters": {
    "vmName": { "value": "lab2c-ubuntu-vm" },
    "adminUsername": { "value": "azureuser" },
    "adminPassword": { "value": "MySecurePassword123!" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 Deploy ARM Template via CLI:

```bash
az deployment group create \
  --resource-group lab2c-rg \
  --template-file vmdeploy.json \
  --parameters @vmdeploy.parameters.json
```

---

## ✅ Lab Complete

You’ve created and managed a Linux VM using Azure CLI, Portal, and ARM templates — including provisioning, SSH access, lifecycle management, and resource inspection.

