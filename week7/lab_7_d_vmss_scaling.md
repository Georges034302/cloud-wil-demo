# 🖥️ Lab 7-D: Configure Scaling for Azure Virtual Machine Scale Sets (VMSS)

## 🌟 Objectives

- Understand how Azure VM Scale Sets (VMSS) provide elastic compute
- Deploy a VMSS that auto-scales based on CPU utilization
- Define autoscale rules to adjust VM instances
- Use Azure Portal, CLI, and ARM to configure scaling profiles
- Monitor VMSS activity and instance count


## 🛠️ Requirements

- Azure CLI installed (`az login`)
- Resource group (e.g., `lab7-rg`)
- Permissions to create virtual machines and network resources
- Basic knowledge of VM sizing and regional constraints

---

## ✅ Option 1: Azure Portal

### 🔗 Navigate to Azure VMSS Creation
- Go to [https://portal.azure.com](https://portal.azure.com)
- Search for **"Virtual Machine Scale Sets"**
- Click **+ Create**


### 🧾 Tab 1: Basics

| Field                 | Value                      |
|----------------------|----------------------------|
| **Subscription**     | Azure subscription 1       |
| **Resource group**   | `lab7-rg` (or create new)  |
| **Name**             | `lab7vmss`                 |
| **Region**           | Australia East             |
| **Orchestration**    | Flexible                   |
| **Security type**    | Trusted launch             |



### 🧮 Tab 2: Scaling

| Field                 | Value                            |
|----------------------|----------------------------------|
| **Scaling mode**     | Manually update the capacity     |
| **Instance count**   | 2                                |
| **Zones**            | None (or enable if desired)      |



### 💻 Tab 3: Instance Details

| Field                    | Value                            |
|-------------------------|----------------------------------|
| **Image**               | Ubuntu Pro 22.04 LTS – x64 Gen2 |
| **VM architecture**     | x64                             |
| **Size**                | Standard_D2s_v3                 |



### 🔐 Tab 4: Administrator Account

| Field                   | Value                      |
|------------------------|----------------------------|
| **Authentication type** | Password                  |
| **Username**            | `azureuser`               |
| **Password**            | YourSecurePassword123!    |



### ✅ Final Steps

- Leave **Disks**, **Networking**, **Management**, etc., as default
- Click **Review + Create** → **Create**

---



## 🖥️ Option 2: Azure CLI (Username + Password)

### 📦 Define Variables

```bash
RG="lab7-rg"
VMSS_NAME="lab7vmss"
LOCATION="australiaeast"
IMAGE="Canonical:0001-com-ubuntu-pro-jammy:pro-22_04-lts-gen2:latest"
VM_SIZE="Standard_D2s_v3"
ADMIN_USER="azureuser"
read -s -p "Enter VMSS admin password: " ADMIN_PASS
```


### 🏗️ Create Resource Group

```bash
az group create \
  --name $RG \
  --location $LOCATION
```


### 🏗️ Create the VMSS with Password Auth

```bash
# Create a new Virtual Machine Scale Set (VMSS) with password authentication
# - Uses flexible orchestration mode
# - Deploys 2 Ubuntu Pro 22.04 LTS VMs of size Standard_D2s_v3
# - Sets admin username and prompts for password
az vmss create \
  --resource-group $RG \
  --name $VMSS_NAME \
  --orchestration-mode Flexible \
  --image $IMAGE \
  --instance-count 2 \
  --admin-username $ADMIN_USER \
  --admin-password $ADMIN_PASS \
  --vm-sku $VM_SIZE \
  --location $LOCATION \
  --platform-fault-domain-count 1
```


### 🔍 Verify Deployment

```bash
# Show details of the created VMSS, including instance count
az vmss show \
  --resource-group $RG \
  --name $VMSS_NAME \
  --query "{name:name, location:location, instances:sku.capacity}" \
  --output table
```

---


## 🧱 Option 3: ARM Template (Password Auth)

### 📄 `vmss-deploy.json`

> ⚠️ Replace `<YOUR-SUBNET-ID>` with the correct resource ID of an existing subnet.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachineScaleSets",
      "apiVersion": "2023-09-01",
      "name": "lab7vmss",
      "location": "australiaeast",
      "sku": {
        "name": "Standard_D2s_v3",
        "tier": "Standard",
        "capacity": 2
      },
      "properties": {
        "orchestrationMode": "Flexible",
        "platformFaultDomainCount": 1,
        "virtualMachineProfile": {
          "storageProfile": {
            "imageReference": {
              "publisher": "Canonical",
              "offer": "0001-com-ubuntu-pro-jammy",
              "sku": "pro-22_04-lts-gen2",
              "version": "latest"
            }
          },
          "osProfile": {
            "adminUsername": "azureuser",
            "adminPassword": "YourSecurePassword123!",
            "computerNamePrefix": "lab7vmss",
            "linuxConfiguration": {
              "disablePasswordAuthentication": false
            }
          },
          "hardwareProfile": {
            "vmSize": "Standard_D2s_v3"
          },
          "networkProfile": {
            "networkInterfaceConfigurations": [
              {
                "name": "nic-lab7vmss",
                "properties": {
                  "primary": true,
                  "ipConfigurations": [
                    {
                      "name": "ipconfig1",
                      "properties": {
                        "subnet": {
                          "id": "<YOUR-SUBNET-ID>"
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      }
    }
  ]
}
```

---

### 🚀 Deploy the ARM Template

```bash
az deployment group create \
  --resource-group $RG \
  --template-file vmss-deploy.json
```

---

---

## 📋 Summary Table: VMSS Deployment Options
---

## 📋 Summary Table: VMSS Deployment Options

| Option      | Method           | Orchestration | Instance Count | Notes                                      |
|-------------|------------------|----------------|----------------|--------------------------------------------|
| Option 1    | **Azure Portal** | Flexible       | 2              | Most user-friendly, guided UI              |
| Option 2    | **Azure CLI**    | Flexible       | 2              | Scriptable and automatable                 |
| Option 3    | **ARM Template** | Flexible       | 2              | Infrastructure as Code (IaC); reusable     |

> 💡 All options use Ubuntu Pro 22.04 LTS and `Standard_D2s_v3` (comparable to App Service S1).

---

✅ You now know how to deploy VM Scale Sets using three different methods depending on your preference for manual UI, CLI automation, or declarative templates.




