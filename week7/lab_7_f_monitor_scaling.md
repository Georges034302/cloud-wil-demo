# 📊 Lab 7-F: Monitor and Diagnose Scaling Events

## 🎯 Objectives

- Use Azure Monitor to view autoscale activities for App Services and VM Scale Sets
- Identify scale-in and scale-out events and understand what triggered them
- Analyze logs and performance metrics related to CPU, memory, and instance count
- Create alert rules based on scaling behavior
- Use Azure Portal, CLI, and ARM templates to retrieve scaling history and diagnostics

---

## 🛠️ Requirements

- Azure CLI installed (`az login`)
- Autoscaling already configured on either:
  - App Service Plan (`Lab7Plan`) or
  - VM Scale Set (`lab7-vmss`)
- Log Analytics Workspace (for diagnostics)
- Azure Portal access

---

## 👣 Lab Instructions

### 1️⃣ View Autoscale Events in Azure Monitor

#### 🌐 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Monitor** and open it
3. In the left pane, select **Autoscale**
4. Choose your App Service Plan (`Lab7Plan`) or VMSS (`lab7-vmss`)
5. Under your autoscale profile, click **Run history**

✅ View:
- Timestamps of scale actions
- Direction (Scale in / Scale out)
- Trigger reason (e.g., CPU threshold)

---

### 2️⃣ Review Metrics and Instance Behavior

#### 🌐 Azure Portal:

1. From **Monitor**, go to **Metrics**
2. Set **Scope** to `Lab7Plan` or `lab7-vmss`
3. Choose **Metric Namespace**:
   - For App Service: *App Service Plan metrics*
   - For VMSS: *Virtual Machine Scale Sets*
4. Select metrics like **Percentage CPU** and **Instance count**
5. Configure:
   - Time range: Last 24 hours
   - Aggregation: Average

✅ Use graphs to correlate CPU spikes with scaling behavior.

---

### 3️⃣ Enable Diagnostic Logs

#### 🌐 Azure Portal:

1. Navigate to your **App Service Plan** or **VMSS**
2. Click **Diagnostics settings**
3. Click **+ Add diagnostic setting**
4. Enable:
   - `AuditLogs`
   - `Metrics`
   - `AutoscaleEvaluations`
5. Send logs to your **Log Analytics Workspace**

✅ Logs will now flow into the workspace for analysis.

#### 💻 Azure CLI:

```bash
RESOURCE_ID=$(az resource show \
  --resource-group lab7-rg \
  --name Lab7Plan \
  --resource-type "Microsoft.Web/serverfarms" \
  --query id --output tsv)

az monitor diagnostic-settings create \
  --name AutoscaleDiagnostics \
  --resource "$RESOURCE_ID" \
  --logs '[{"category": "AuditLogs", "enabled": true}, {"category": "AutoscaleEvaluations", "enabled": true}, {"category": "Metrics", "enabled": true}]' \
  --workspace /subscriptions/<sub-id>/resourceGroups/<workspace-rg>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>
```

✅ Enables streaming autoscale and diagnostic logs to the workspace.

#### 🧱 ARM Template:

Create a file `autoscale-diagnostics.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceId": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "2021-05-01-preview",
      "name": "AutoscaleDiagnostics",
      "properties": {
        "workspaceId": "[parameters('workspaceId')]",
        "logs": [
          { "category": "AuditLogs", "enabled": true },
          { "category": "AutoscaleEvaluations", "enabled": true },
          { "category": "Metrics", "enabled": true }
        ]
      }
    }
  ]
}
```

##### Deploy:

```bash
az deployment group create \
  --resource-group lab7-rg \
  --template-file autoscale-diagnostics.json \
  --parameters workspaceId="/subscriptions/<sub-id>/resourceGroups/<workspace-rg>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>"
```

✅ Deploys diagnostic settings using an ARM template.

---

### 4️⃣ Create Alert for Autoscale Events

#### 🌐 Azure Portal:

1. Go to **Monitor** → **Alerts** → **+ Create** → **Alert rule**
2. **Scope**: Select `Lab7Plan` or `lab7-vmss`
3. **Condition**: Choose signal for **Scale out success** or **Scale in success**
4. **Action Group**: Add email notification (e.g., `ScalingAlertGroup`)
5. **Alert Rule Name**: `NotifyOnAutoscale`
6. **Severity**: 2 (High)
7. Click **Create alert rule**

✅ You’ll be notified when scaling events occur.

---

### 5️⃣ View Scaling Events Using CLI

```bash
az monitor activity-log list \
  --resource-group lab7-rg \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Retrieves recent autoscaling actions.

---

### 6️⃣ Investigate Autoscale Logic with KQL (if using Log Analytics)

```kusto
AzureDiagnostics
| where Category == "AutoscaleEvaluations"
| project TimeGenerated, Resource, AutoscaleRuleName_s, Condition_s, ResultType_s
| sort by TimeGenerated desc
```

✅ Helps trace scale triggers and evaluation outcomes.

---

## ✅ Lab Complete

You monitored and diagnosed Azure App Service and VMSS scaling using Portal, CLI, and ARM. You configured logging, alerting, and diagnostics to track autoscale behavior reliably.

