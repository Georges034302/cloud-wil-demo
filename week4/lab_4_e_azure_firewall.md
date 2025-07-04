# 🔥 Lab 4-E: Deploy and Configure Azure Firewall

---

## 🎯 Objective

- Deploy Azure Firewall into a dedicated subnet (`AzureFirewallSubnet`)
- Create a public IP and bind it to the firewall
- Add a rule to allow outbound HTTP (TCP port 80)
- Practice both Azure Portal and Azure CLI for each step

---

## 🧰 Requirements

- Azure subscription
- Azure CLI installed and logged in (`az login`)
- Existing Resource Group: `lab4-rg`
- Existing Virtual Network: `lab4-vnet` (must include 10.1.3.0/26 in its address space)

---

## 👣 Step-by-Step Lab Instructions

### 1️⃣ Create the AzureFirewallSubnet

**Azure Portal:**
1. Go to **Virtual Networks** → `lab4-vnet`
2. Under **Subnets**, click **+ Subnet**
3. Fill in:
   - **Name:** `AzureFirewallSubnet` (must match exactly)
   - **Address range:** `10.1.3.0/26`
4. Click **Save**

**Azure CLI:**
```bash
az network vnet subnet create \
  --resource-group lab4-rg \
  --vnet-name lab4-vnet \
  --name AzureFirewallSubnet \
  --address-prefixes 10.1.3.0/26
```

---

### 2️⃣ Deploy Azure Firewall

**Azure Portal:**
1. In the Azure Portal, search **Firewalls** and click **+ Create**
2. Under **Basics**:
   - **Name:** `lab4-fw`
   - **Region:** `Australia East`
   - **Resource Group:** `lab4-rg`
3. Under **Firewall management**:
   - **Virtual network:** `lab4-vnet`
   - Leave other IP configuration defaults
4. Click **Review + Create** → **Create**
   - ⏳ *Provisioning may take 5–10 minutes*

**Azure CLI:**
```bash
# Create a public IP address for the firewall
az network public-ip create \
  --resource-group lab4-rg \
  --name lab4-fw-pip \
  --sku Standard \
  --location australiaeast

# Deploy the Azure Firewall
az network firewall create \
  --name lab4-fw \
  --resource-group lab4-rg \
  --location australiaeast

# Bind the public IP and VNet to the firewall
az network firewall ip-config create \
  --firewall-name lab4-fw \
  --resource-group lab4-rg \
  --name lab4-fw-config \
  --public-ip-address lab4-fw-pip \
  --vnet-name lab4-vnet
```

---

### 3️⃣ Create Firewall Rule to Allow Outbound HTTP

**Azure Portal:**
1. Go to your **lab4-fw** firewall resource
2. Click **Rules (Classic)** → **+ Add rule collection**
3. In **Network Rule Collection**:
   - **Name:** `AllowWebOut`
   - **Priority:** `100`
   - **Action:** `Allow`
   - **Rule:**
     - **Name:** `AllowHTTP`
     - **Protocol:** `TCP`
     - **Source address:** `*`
     - **Destination address:** `*`
     - **Destination port:** `80`
4. Click **Add**

**Azure CLI:**
```bash
az network firewall network-rule create \
  --firewall-name lab4-fw \
  --resource-group lab4-rg \
  --collection-name AllowWebOut \
  --priority 100 \
  --action Allow \
  --name AllowHTTP \
  --protocols TCP \
  --source-addresses '*' \
  --destination-addresses '*' \
  --destination-ports 80
```
---

### 4️⃣ Test Azure Firewall with a Test VM

#### Create a Test Subnet

Create a new subnet (not `AzureFirewallSubnet`) in your VNet, e.g., `test-subnet`:

```bash
az network vnet subnet create \
  --resource-group lab4-rg \
  --vnet-name lab4-vnet \
  --name test-subnet \
  --address-prefixes 10.1.5.0/24
```

#### Deploy a Test VM into the Test Subnet

```bash
ADMIN_PASSWORD=P@ssword@$RANDOM

az vm create \
  --resource-group lab4-rg \
  --name lab2c-ubuntu-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --admin-password "$ADMIN_PASSWORD" \
  --authentication-type password \
  --output json
```

#### Find Azure Firewall’s Private IP

```bash
az network firewall show \
  --name lab4-fw \
  --resource-group lab4-rg \
  --query "ipConfigurations[0].privateIPAddress" \
  --output tsv
```

> Save this as `<FirewallPrivateIP>`

#### Create a Route Table and Add Default Route via the Firewall

```bash
# Create route table
az network route-table create \
  --name lab4-fw-rt \
  --resource-group lab4-rg \
  --location australiaeast

# Add default route via the firewall
az network route-table route create \
  --resource-group lab4-rg \
  --route-table-name lab4-fw-rt \
  --name DefaultRoute \
  --address-prefix 0.0.0.0/0 \
  --next-hop-type VirtualAppliance \
  --next-hop-ip-address <FirewallPrivateIP>
```

> Replace `<FirewallPrivateIP>` with your firewall’s private IP.

#### Associate the Route Table with the Test Subnet

```bash
az network vnet subnet update \
  --vnet-name lab4-vnet \
  --name test-subnet \
  --resource-group lab4-rg \
  --route-table lab4-fw-rt
```

---

### 5️⃣ Test Outbound HTTP and HTTPS from the VM

**SSH into your test VM:**

```bash
az vm ssh -g lab4-rg -n testvm
```

- **Test HTTP (Should Succeed):**

  ```bash
  curl -I http://example.com
  ```

  *Should return **`HTTP/1.1 200 OK`*

- **Test HTTPS (Should Fail):**

  ```bash
  curl -I https://example.com
  ```

  *Should timeout or fail, because only port 80 is allowed by your rule.*
---

### 6️⃣ Test Azure Firewall with a Test VM (Azure Portal - Optional)

---

#### **Create a Test Subnet**

1. In the Azure Portal, search for **Virtual networks** and select `lab4-vnet`.
2. In the left menu, click **Subnets**, then click **+ Subnet**.
3. Fill in:
   - **Name:** `test-subnet`
   - **Subnet address range:** `10.1.1.0/24`
4. Click **Save**.

#### **Deploy a Test VM into the Test Subnet**

1. In the Portal, search for **Virtual machines** and click **+ Create** > **Azure virtual machine**.
2. On the **Basics** tab, fill in:
   - **Subscription:** Your subscription
   - **Resource group:** `lab4-rg`
   - **Virtual machine name:** `testvm`
   - **Region:** `Australia East`
   - **Image:** *Ubuntu Server 22.04 LTS* (or similar)
   - **Size:** Standard_B1s (or any available)
   - **Authentication type:** Password  
   - **Username:** `azureuser`
   - **Password:** (choose a strong password, e.g., `P@ssword@1234`)
3. On the **Disks** tab, leave defaults.
4. On the **Networking** tab:
   - **Virtual network:** `lab4-vnet`
   - **Subnet:** `test-subnet`
   - **Public IP:** Enable if you want to SSH from outside (recommended for lab)
5. Leave all other settings as default.
6. Click **Review + create**, then **Create**.
7. After deployment, copy the **Public IP address** of the VM for SSH access.

#### **Find Azure Firewall’s Private IP**

1. In the Portal, search for **Firewalls** and select your `lab4-fw` firewall.
2. In the **Overview** or **IP configurations** tab, find the **Private IP address** listed for the firewall.
3. Note this IP address—you will need it for the next step.

#### **Create a Route Table and Add Default Route via the Firewall**

1. In the Portal, search for **Route tables** and click **+ Create**.
2. On the **Basics** tab:
   - **Subscription:** Your subscription
   - **Resource group:** `lab4-rg`
   - **Region:** `Australia East`
   - **Name:** `lab4-fw-rt`
3. Click **Review + Create**, then **Create**.
4. After creation, open the **lab4-fw-rt** route table.
5. In the left menu, click **Routes** > **+ Add**.
6. Enter:
   - **Route name:** `DefaultRoute`
   - **Address prefix:** `0.0.0.0/0`
   - **Next hop type:** `Virtual appliance`
   - **Next hop address:** (Paste your firewall’s private IP address here)
7. Click **Add**.

#### **Associate the Route Table with the Test Subnet**

1. In the Portal, go to **Virtual networks** > `lab4-vnet` > **Subnets**.
2. Click on `test-subnet` from the subnet list.
3. Under **Route table**, select `lab4-fw-rt`.
4. Click **Save**.


**Your VM in `test-subnet` now routes outbound internet traffic through Azure Firewall for inspection and filtering.**

**NOTE:** use the testing process in step 5 to test the firewall rules

---

## ✅ Lab Complete

- Deployed Azure Firewall in a dedicated subnet
- Configured outbound HTTP rule
- Validated setup using Portal and CLI
- Deployed a test VM in a separate subnet
- Verified firewall enforcement by testing HTTP (allowed) and HTTPS (blocked) outbound traffic from the VM

---



