# 📈 Lab 5-F: Monitor CI/CD Pipelines with Azure Monitor

## 🎯 Objectives

- Connect CI/CD pipeline activity to Azure Monitor for visibility and alerting
- Use Log Analytics to query deployment and resource activity
- Create an Alert Rule to notify when deployments fail
- View CI/CD telemetry such as pipeline triggers, errors, and policy violations
- Understand how monitoring improves delivery reliability

---

## 🛠️ Requirements

- Azure CLI installed (`az login`)
- Azure Portal access
- Azure subscription
- Resource group: `lab5-rg` with existing deployments
- Log Analytics Workspace (created via CLI, Portal, or ARM)
- Optional: CI/CD pipeline in GitHub Actions or Azure DevOps

---

## 👣 Lab Instructions

### 1️⃣ Create Log Analytics Workspace

#### 🌐 Azure Portal:

1. Go to **Azure Portal** → Search: **Log Analytics workspaces**
2. Click **+ Create**
3. Under **Basics**:
   - **Resource Group**: `lab5-rg`
   - **Name**: `lab5-logs`
   - **Region**: `Australia East`
4. Click **Review + Create** → **Create**

#### 💻 Azure CLI:

```bash
az monitor log-analytics workspace create \
  --resource-group lab5-rg \
  --workspace-name lab5-logs \
  --location australiaeast
```

#### 🧱 ARM Template:

Create `loganalytics-template.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string"
    },
    "location": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2021-06-01",
      "name": "[parameters('workspaceName')]",
      "location": "[parameters('location')]",
      "properties": {
        "sku": {
          "name": "PerGB2018"
        },
        "retentionInDays": 30
      }
    }
  ]
}
```

Deploy it:

```bash
az deployment group create \
  --resource-group lab5-rg \
  --template-file loganalytics-template.json \
  --parameters workspaceName=lab5-logs location=australiaeast
```

---

### 2️⃣ Enable Diagnostic Settings on Resource Group

#### 🌐 Azure Portal:

1. Go to **Resource Groups** → `lab5-rg`
2. Select **Diagnostic settings**
3. Click **+ Add diagnostic setting**
4. Name: `rg-diag-logs`
5. Check logs: ✅ **AllLogs**, ✅ **Policy**
6. Select destination: ✅ **Send to Log Analytics**
7. Choose workspace: `lab5-logs`
8. Click **Save**

#### 💻 Azure CLI:

```bash
RG_ID=$(az group show --name lab5-rg --query id --output tsv)
WS_ID=$(az monitor log-analytics workspace show --resource-group lab5-rg --workspace-name lab5-logs --query id --output tsv)

az monitor diagnostic-settings create \
  --name rg-diag-logs \
  --resource "$RG_ID" \
  --logs '[{"category": "AllLogs", "enabled": true}, {"category": "Policy", "enabled": true}]' \
  --workspace "$WS_ID"
```

#### 🧱 ARM Template:

Create `diagnostic-settings-template.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceId": {
      "type": "string"
    },
    "resourceId": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "2021-05-01-preview",
      "name": "rg-diag-logs",
      "properties": {
        "workspaceId": "[parameters('workspaceId')]",
        "logs": [
          {
            "category": "AllLogs",
            "enabled": true
          },
          {
            "category": "Policy",
            "enabled": true
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
  --resource-group lab5-rg \
  --template-file diagnostic-settings-template.json \
  --parameters \
    resourceId="/subscriptions/<sub-id>/resourceGroups/lab5-rg" \
    workspaceId="/subscriptions/<sub-id>/resourceGroups/lab5-rg/providers/Microsoft.OperationalInsights/workspaces/lab5-logs"
```

🔁 Replace `<sub-id>` with your actual subscription ID.

---

### 3️⃣ Query Logs with Kusto Query Language (KQL)

#### 🌐 Azure Portal:

1. Go to **Log Analytics workspaces** → `lab5-logs`
2. Click **Logs**
3. Paste the following KQL:

```kql
AzureDiagnostics
| where Category == "Policy" or Category == "ResourceWriteFailure"
| where OperationNameValue contains "deployments"
| project TimeGenerated, ResourceGroup, OperationName, ResultType, Caller
| sort by TimeGenerated desc
```

4. Click **Run**

✅ View CI/CD deployment logs and policy violations

---

### 4️⃣ Create Alert Rule for Failed Deployments

#### 🌐 Azure Portal:

1. Go to **Monitor → Alerts → + Create → Alert rule**
2. Scope: Choose `lab5-rg`
3. Condition:
   - Choose **Custom log search**
   - Paste the above KQL
   - Set threshold: `result count > 0 in last 5 minutes`
4. Action Group:
   - Click **+ Create new** → Name: `DevOpsAlerts`
   - Add Email action
5. Alert Details:
   - Name: `DeploymentFailuresAlert`
   - Severity: 2 (High)
6. Click **Create alert rule**

✅ You will now be alerted if any CI/CD pipeline deployment fails.

---

### 5️⃣ Trigger a Failed Deployment to Test Alert

```bash
az storage account create \
  --name baddeployfail1234 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS
```

🚫 This will fail if Azure Policy (e.g., tag enforcement) is active.

✅ This failure will be logged and can trigger alerts.

---

## ✅ Lab Complete

You configured monitoring for CI/CD pipelines using Azure Monitor, Log Analytics, and alert rules. You also used ARM, CLI, and Portal for full automation and observability.

