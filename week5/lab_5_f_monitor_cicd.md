# 📈 Lab 5-F: Monitor CI/CD Pipelines with Azure Monitor (Portal Only)

## 🎯 Objectives

- Monitor CI/CD pipeline activity using Azure Monitor
- Enable diagnostic logs for CI/CD governance and visibility
- Create a Log Analytics workspace and view deployment telemetry
- Trigger alerts on pipeline failure or policy violations
- Understand how monitoring improves delivery reliability

---

## 🛠️ Requirements

| Requirement         | Description                                |
|---------------------|--------------------------------------------|
| ✅ Azure Portal      | Access to [portal.azure.com](https://portal.azure.com) |
| ✅ Azure Subscription | Subscription with permission to create resources |
| ✅ Existing RG       | `lab5-rg` resource group from prior labs   |

---

## 👣 Lab Instructions (Portal Only)

### 1️⃣ Create Log Analytics Workspace

1. In Azure Portal, search for **Log Analytics workspaces**
2. Click **+ Create**
3. In the **Basics** tab:
   - Resource Group: `lab5-rg`
   - Name: `lab5-logs`
   - Region: `Australia East`
4. Click **Review + Create** → **Create**

---

### 2️⃣ Enable Diagnostic Settings on Resource Group

1. Go to **Resource Groups** → select `lab5-rg`
2. On the left menu, click **Diagnostic settings**
3. Click **+ Add diagnostic setting**
4. Name: `rg-diag-logs`
5. Check:
   - ✅ **AllLogs**
   - ✅ **Policy**
6. Under **Destination details**, select:
   - ✅ **Send to Log Analytics workspace**
   - Workspace: `lab5-logs`
7. Click **Save**

---

### 3️⃣ Query Logs in Log Analytics

1. In the Portal, go to **Log Analytics workspaces**
2. Select `lab5-logs` → Click **Logs**
3. Paste this KQL query:

```kql
AzureDiagnostics
| where Category == "Policy" or Category == "ResourceWriteFailure"
| where OperationNameValue contains "deployments"
| project TimeGenerated, ResourceGroup, OperationName, ResultType, Caller
| sort by TimeGenerated desc
```

4. Click **Run**  
✅ You should see deployment activity, errors, and policy logs.

---

### 4️⃣ Create Alert Rule for Failed Deployments

1. Go to **Monitor → Alerts**
2. Click **+ Create → Alert rule**
3. Scope: Select `lab5-rg`
4. Condition:
   - Click **Custom log search**
   - Paste the same KQL from step 3
   - Set threshold: `Result count > 0 in last 5 minutes`
5. Action Group:
   - Click **+ Create new**
   - Name: `DevOpsAlerts`
   - Add your email address under **Notifications**
6. Alert Details:
   - Alert name: `DeploymentFailuresAlert`
   - Severity: 2 (High)
7. Click **Create alert rule**

✅ You will now be alerted when deployment or policy failures occur.

---

### 5️⃣ Trigger a Failed Deployment (Validation)

To simulate failure:

1. Go to **Azure Portal → Storage accounts**
2. Click **+ Create**
3. Use:
   - Name: `failstoragelab5`
   - Resource Group: `lab5-rg`
   - Region: `Australia East`
   - Tags: Leave empty if a **"Require Tag"** policy is active
4. Click **Review + Create** → **Create**

❌ If tag policy is active, deployment should fail and appear in logs.

---

### 🧹 Final Cleanup (Important)

To remove all resources created in this lab series:

1. In **Azure Portal**, search for **Resource groups**
2. Select `lab5-rg`
3. Click **🗑️ Delete resource group**
4. Enter `lab5-rg` to confirm and delete

Or use CLI to delete the resource group
```bash
az group delete --name lab5-rg --yes --no-wait
```
⚠️ This will delete all labs A–F deployments and telemetry.

---

## ✅ Lab Complete

- 📈 Configured centralized monitoring for CI/CD pipelines using Azure Monitor and Log Analytics
- 📝 Enabled diagnostic logs for governance and visibility
- 🔍 Queried deployments using KQL in Log Analytics
- 🚨 Created actionable alerts for deployment failures and policy violations
- ✅ Improved governance and reliability of your