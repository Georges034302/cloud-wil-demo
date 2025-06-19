# 🖥️ Lab 7-D: Configure Scaling for Azure Virtual Machine Scale Sets (VMSS)

## 🌟 Objectives

- Understand how Azure VM Scale Sets (VMSS) provide elastic compute
- Deploy a VMSS that auto-scales based on CPU utilization
- Define autoscale rules to adjust VM instances
- Use Azure Portal, CLI, and ARM to configure scaling profiles
- Monitor VMSS activity and instance count

---

## 🛠️ Requirements

- Azure CLI installed (`az login`)
- Resource group (e.g., `lab7-rg`)
- Permissions to create virtual machines and network resources
- Basic knowledge of VM sizing and regional constraints

---

## 👣 Lab Instructions

### 1️⃣ Create a Virtual Machine Scale Set

#### 🌐 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **Create a resource** → Search: *Virtual Machine Scale Set*
3. Fill in:
   - **Resource group**: `lab7-rg`
   - **Name**: `lab7-vmss`
   - **Region**: Australia East
   - **Orchestration mode**: Uniform
   - **Image**: Ubuntu Server 20.04 LTS
   - **Admin username/password**: Your choice
   - **Instance count**: 2
   - **Scaling**: Enabled
   - **Autoscale settings**: Skip (configured later)
   - **Networking**: Accept defaults
4. Click **Review + Create** → **Create**

✅ A VMSS with default networking and load balancing will be deployed.

#### 💻 Azure CLI:

```bash
az vmss create \
  --resource-group lab7-rg \
  --name lab7-vmss \
  --image UbuntuLTS \
  --admin-username azureuser \
  --admin-password <your-password> \
  --upgrade-policy-mode automatic \
  --vm-sku Standard_B1s \
  --instance-count 2
```

✅ Creates a VMSS with 2 Ubuntu VMs and automatic upgrade policy.

---

### 2️⃣ Configure Autoscaling for the VMSS

#### 🌐 Azure Portal:

1. Go to **Virtual Machine Scale Sets** → Select `lab7-vmss`
2. In the left pane, click **Scaling**
3. Click **Custom autoscale**
4. Set:
   - **Minimum**: 2
   - **Maximum**: 5
   - **Default**: 2
5. Add Rule 1 – **Scale Out**:
   - Metric: CPU Percentage
   - Condition: Greater than 70% for 5 minutes
   - Action: Increase instance count by 1
6. Add Rule 2 – **Scale In**:
   - Metric: CPU Percentage
   - Condition: Less than 30% for 5 minutes
   - Action: Decrease instance count by 1
7. Click **Save**

✅ Autoscaling is now enabled based on CPU thresholds.

#### 💻 Azure CLI:

```bash
az monitor autoscale create \
  --resource-group lab7-rg \
  --resource lab7-vmss \
  --resource-type Microsoft.Compute/virtualMachineScaleSets \
  --name lab7-vmss-autoscale \
  --min-count 2 \
  --max-count 5 \
  --count 2

az monitor autoscale rule create \
  --resource-group lab7-rg \
  --autoscale-name lab7-vmss-autoscale \
  --condition "Percentage CPU > 70 avg 5m" \
  --scale out 1

az monitor autoscale rule create \
  --resource-group lab7-rg \
  --autoscale-name lab7-vmss-autoscale \
  --condition "Percentage CPU < 30 avg 5m" \
  --scale in 1
```

✅ CLI rules match Portal configuration for scale-out and scale-in.

#### 📄 ARM Template (autoscale-vmss.json):

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/autoscalesettings",
      "apiVersion": "2015-04-01",
      "name": "lab7-vmss-autoscale",
      "location": "australiaeast",
      "properties": {
        "targetResourceUri": "/subscriptions/<sub-id>/resourceGroups/lab7-rg/providers/Microsoft.Compute/virtualMachineScaleSets/lab7-vmss",
        "enabled": true,
        "profiles": [
          {
            "name": "AutoScaleProfile",
            "capacity": {
              "minimum": "2",
              "maximum": "5",
              "default": "2"
            },
            "rules": [
              {
                "metricTrigger": {
                  "metricName": "Percentage CPU",
                  "metricNamespace": "Microsoft.Compute/virtualMachineScaleSets",
                  "timeGrain": "PT1M",
                  "statistic": "Average",
                  "timeWindow": "PT5M",
                  "timeAggregation": "Average",
                  "operator": "GreaterThan",
                  "threshold": 70,
                  "dimensions": []
                },
                "scaleAction": {
                  "direction": "Increase",
                  "type": "ChangeCount",
                  "value": "1",
                  "cooldown": "PT5M"
                }
              },
              {
                "metricTrigger": {
                  "metricName": "Percentage CPU",
                  "metricNamespace": "Microsoft.Compute/virtualMachineScaleSets",
                  "timeGrain": "PT1M",
                  "statistic": "Average",
                  "timeWindow": "PT5M",
                  "timeAggregation": "Average",
                  "operator": "LessThan",
                  "threshold": 30,
                  "dimensions": []
                },
                "scaleAction": {
                  "direction": "Decrease",
                  "type": "ChangeCount",
                  "value": "1",
                  "cooldown": "PT5M"
                }
              }
            ]
          }
        ]
      }
    }
  ]
}
```

📦 Deploy the template:

```bash
az deployment group create \
  --resource-group lab7-rg \
  --template-file autoscale-vmss.json
```

🔁 Replace `<sub-id>` with your Azure subscription ID.

---

### 3️⃣ Monitor VMSS Instances and Scaling History

#### 🌐 Azure Portal:

- Go to `lab7-vmss` → **Instances** to view VMs
- Navigate to **Scaling** → View **Run history** and triggers

#### 💻 Azure CLI:

```bash
az vmss list-instances \
  --name lab7-vmss \
  --resource-group lab7-rg \
  --output table

az monitor activity-log list \
  --resource-group lab7-rg \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Use these to verify scaling events and VM count.

---

## ✅ Lab Complete

You successfully deployed a VMSS and configured CPU-based autoscaling using Azure Portal, CLI, and ARM templates.

