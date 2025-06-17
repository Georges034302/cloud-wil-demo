# 📈 Lab 5-F: Monitor CI/CD Pipelines with Azure Monitor

## 🎯 Objectives

- Connect CI/CD pipeline activity to Azure Monitor for visibility and alerting
- Use Log Analytics to query deployment and resource activity
- Create an Alert Rule to notify when deployments fail
- View CI/CD telemetry such as pipeline triggers, errors, and policy violations
- Understand how monitoring improves delivery reliability

---

## 🧰 Requirements

- Azure subscription
- Azure CLI installed (`az login`)
- Resource group `lab5-rg` with existing deployments
- CI/CD pipeline set up (Azure DevOps or GitHub Actions)
- Log Analytics Workspace (created in this lab or previously)

---

## 👣 Lab Instructions

### 1️⃣ Create a Log Analytics Workspace

#### 🌐 Azure Portal:

1. Go to Azure Portal → Search: **Log Analytics workspaces**
2. Click **+ Create**
3. Under **Basics**:
   - Resource Group: `lab5-rg`
   - Name: `lab5-logs`
   - Region: `Australia East`
4. Click **Review + Create** → **Create**

#### 💻 Azure CLI:

```bash
az monitor log-analytics workspace create \
  --resource-group lab5-rg \
  --workspace-name lab5-logs \
  --location australiaeast
```

✅ This workspace will collect logs from Azure Monitor, activity logs, and policy events.

---

### 2️⃣ Enable Diagnostic Settings on Resource Group

#### 🌐 Azure Portal:

1. Go to **Resource groups** → `lab5-rg`
2. In the left pane, click **Diagnostic settings**
3. Click **+ Add diagnostic setting**
4. Name: `rg-diag-logs`
5. Under **Log**, check:
   - **AllLogs**
   - **Policy**
6. Under **Destination**:
   - ✅ Send to **Log Analytics**
   - Select **lab5-logs** workspace
7. Click **Save**

#### 💻 Azure CLI:

```bash
RG_ID=$(az group show --name lab5-rg --query id --output tsv)

az monitor diagnostic-settings create \
  --name rg-diag-logs \
  --resource "$RG_ID" \
  --logs '[{"category": "AllLogs", "enabled": true}, {"category": "Policy", "enabled": true}]' \
  --workspace lab5-logs
```

✅ Now diagnostic logs will be streamed to your Log Analytics workspace.

---

### 3️⃣ Query Deployment Logs with Kusto (KQL)

#### 🌐 Azure Portal:

1. Go to **Log Analytics workspaces** → `lab5-logs`
2. Click **Logs**
3. Paste this query:

```kql
AzureDiagnostics
| where Category == "Policy" or Category == "ResourceWriteSuccess"
| where OperationNameValue contains "deployments"
| project TimeGenerated, ResourceGroup, OperationName, ResultType, Caller
| sort by TimeGenerated desc
```

4. Click **Run** to view deployment and policy log details

✅ Use this query regularly to identify failed or blocked deployments.

---

### 4️⃣ Create an Alert Rule for Failed Deployments

#### 🌐 Azure Portal:

1. Go to **Monitor → Alerts → + Create → Alert rule**
2. Scope: Choose **lab5-rg**
3. Condition:
   - Click **Custom log search**
   - Paste the KQL query above
   - Set threshold: When result count > 0 in last **5 minutes**
4. Action Group:
   - Click **Create new**
   - Name: `DevOpsAlerts`
   - Action type: Email → Enter your email
5. Rule Details:
   - Name: `DeploymentFailuresAlert`
   - Severity: `2 (High)`
6. Click **Create alert rule**

✅ You'll now be notified when CI/CD deployments fail.

---

### 5️⃣ Trigger a Failed Deployment (Test)

Try deploying a resource with missing parameters or policy violation:

```bash
az storage account create \
  --name invaliddeploy999 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS
```

🚫 Should fail if policy enforcement (e.g., tag) is active.

✅ Log entry appears in Log Analytics ✅ Email or alert is triggered via Azure Monitor

---

✔️ **Lab complete – you monitored CI/CD activity using Azure Monitor and Log Analytics, and created an alert rule for deployment failures using KQL.**

