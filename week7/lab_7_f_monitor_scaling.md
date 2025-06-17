# 📊 Lab 7-F: Monitor and Diagnose Scaling Events

## 🎯 Objectives

- Use Azure Monitor to view autoscale activities for App Services and VM Scale Sets
- Identify scale-in and scale-out events and understand what triggered them
- Analyze logs and performance metrics related to CPU, memory, and instance count
- Create alert rules based on scaling behavior
- Use CLI and Portal to retrieve scaling history and diagnostics

---

## 🧰 Requirements

- Azure CLI installed (`az login`)
- Autoscaling already configured on either:
  - App Service Plan (`Lab7Plan`) or
  - VM Scale Set (`lab7-vmss`)
- Log Analytics Workspace (optional, for diagnostics)

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

### 3️⃣ Enable Diagnostic Logs (Optional)

#### 🌐 Azure Portal:

1. Navigate to your **App Service Plan** or **VMSS**
2. Click **Diagnostics settings**
3. Click **+ Add diagnostic setting**
4. Enable:
   - `AuditLogs`
   - `Metrics`
   - `AutoscaleEvaluations`
5. Send logs to a **Log Analytics Workspace**

✅ You can now review autoscale decisions and infrastructure diagnostics.

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

✅ You’ll be notified whenever a scaling event occurs.

---

### 5️⃣ Use Azure CLI to View Scaling Events

```bash
az monitor activity-log list \
  --resource-group <resource-group> \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Retrieves recent autoscaling actions and results.

---

### 6️⃣ (Optional) Investigate Autoscale Reasons via Kusto Query

If using Log Analytics Workspace:

```kusto
AzureDiagnostics
| where Category == "AutoscaleEvaluations"
| project TimeGenerated, Resource, AutoscaleRuleName_s, Condition_s, ResultType_s
| sort by TimeGenerated desc
```

✅ Shows autoscale rule that triggered, thresholds, and action outcomes.

---

✔️ **Lab complete – you monitored and diagnosed Azure scaling behavior using run history, metrics, logs, and alert rules.**

