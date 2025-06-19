# ⚙️ Lab 7-B: Configure Autoscale Rules for App Service

## 🌟 Objectives

- Understand how Azure App Service supports automatic scaling
- Create CPU-based autoscale rules for scaling out and in
- Apply autoscale settings to an App Service Plan
- Monitor autoscale conditions using Azure Monitor
- Configure and validate autoscaling using Portal, CLI, and ARM

---

## 🛠️ Requirements

- Azure CLI installed (`az login`)
- A running App Service in a Standard or higher tier (e.g., `lab7app`)
- App Service Plan associated with the app (e.g., `Lab7Plan`)
- A resource group (e.g., `lab7-rg`)

---

## 👣 Lab Instructions

### 1️⃣ Confirm App Plan Supports Autoscale

#### 🌐 Azure Portal:

1. Go to Azure Portal
2. Navigate to **App Services** → select your app
3. Under **Settings**, click **Scale out (App Service plan)**
4. Ensure autoscale is supported and enabled (Standard tier or higher)

#### 💻 Azure CLI:

```bash
az appservice plan show \
  --name Lab7Plan \
  --resource-group lab7-rg \
  --query sku.tier
```

✅ Output must be `Standard` or higher.

---

### 2️⃣ Configure Autoscale via Azure Portal

1. Go to **App Service Plan** → **Scale out (App Service plan)**
2. Toggle **Enable autoscale** to `On`
3. Click **+ Add a rule**

**Scale-out rule:**

- Metric: `CPU Percentage`
- Operator: `Greater than`
- Threshold: `70`
- Duration: `5 minutes`
- Action: `Increase count by 1`
- Cooldown: `5 minutes`

**Scale-in rule:**

- Metric: `CPU Percentage`
- Operator: `Less than`
- Threshold: `30`
- Duration: `5 minutes`
- Action: `Decrease count by 1`

**Instance limits:**

- Minimum: 1
- Maximum: 5
- Default: 2

4. Click **Save**

✅ Autoscale is active.

---

### 3️⃣ Configure Autoscale via Azure CLI

#### Create Autoscale Profile:

```bash
az monitor autoscale create \
  --resource-group lab7-rg \
  --resource Lab7Plan \
  --resource-type Microsoft.Web/serverfarms \
  --name lab7-autoscale \
  --min-count 1 \
  --max-count 5 \
  --count 2
```

#### Add Scale-Out Rule:

```bash
az monitor autoscale rule create \
  --resource-group lab7-rg \
  --autoscale-name lab7-autoscale \
  --condition "Percentage CPU > 70 avg 5m" \
  --scale out 1
```

#### Add Scale-In Rule:

```bash
az monitor autoscale rule create \
  --resource-group lab7-rg \
  --autoscale-name lab7-autoscale \
  --condition "Percentage CPU < 30 avg 5m" \
  --scale in 1
```

✅ Autoscale is configured.

---

### 4️⃣ Configure Autoscale via ARM Template

Create `autoscale-settings.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "type": "Microsoft.Insights/autoscalesettings",
      "apiVersion": "2015-04-01",
      "name": "lab7-autoscale",
      "location": "australiaeast",
      "properties": {
        "targetResourceUri": "/subscriptions/<sub-id>/resourceGroups/lab7-rg/providers/Microsoft.Web/serverfarms/Lab7Plan",
        "enabled": true,
        "profiles": [
          {
            "name": "AutoScaleProfile",
            "capacity": {
              "minimum": "1",
              "maximum": "5",
              "default": "2"
            },
            "rules": [
              {
                "metricTrigger": {
                  "metricName": "Percentage CPU",
                  "metricNamespace": "Microsoft.Web/serverfarms",
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
                  "metricNamespace": "Microsoft.Web/serverfarms",
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

Deploy it:

```bash
az deployment group create \
  --resource-group lab7-rg \
  --template-file autoscale-settings.json
```

🔁 Replace `<sub-id>` with your subscription ID.

---

### 5️⃣ Monitor Autoscale Activity

#### 🌐 Azure Portal:

1. Go to **Monitor** → **Autoscale**
2. Select `lab7-autoscale`
3. View:
   - Evaluation results
   - Triggered actions
   - Rule history

#### 💻 Azure CLI:

```bash
az monitor activity-log list \
  --resource-group lab7-rg \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Confirms autoscale actions were triggered.

---

## ✅ Lab Complete

You successfully configured CPU-based autoscaling for Azure App Service using Azure Portal, CLI, and ARM templates, and monitored the activity to validate the results.

