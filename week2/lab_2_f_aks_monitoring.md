# 📈 Lab 2-F: Setup Monitoring & Logging for Azure Kubernetes Service (AKS) Using CLI, Portal, and ARM Template

## 🎯 Objective

- Enable Azure Monitor and Container Insights on AKS
- Configure and link a Log Analytics Workspace
- Run KQL queries on container logs
- Create alert rules from log conditions
- Visualize metrics and container performance

---

## 🧰 Requirements

- **Azure CLI** installed
- **kubectl** installed (`az aks install-cli` if needed)
- **Docker Desktop** running
- **Existing AKS cluster** (e.g., `lab2e-aks` from Lab 2-E)

---

## 👣 Lab Instructions

### 1️⃣ Create Log Analytics Workspace

#### 🔹 Azure CLI:

```bash
az monitor log-analytics workspace create \
  --resource-group lab2e-rg \
  --workspace-name lab2e-logs \
  --location australiaeast
```

#### 🔹 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Log Analytics workspaces** → **+ Create**
3. Select Resource Group: `lab2e-rg`
4. Name: `lab2e-logs`
5. Region: `Australia East`
6. Review + Create → Create

✅ This workspace will receive telemetry from your AKS cluster.

---

### 2️⃣ Enable Monitoring on AKS Cluster

#### 🔹 Azure CLI:

```bash
az aks enable-addons \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --addons monitoring \
  --workspace-resource-id "/subscriptions/<subscription-id>/resourceGroups/lab2e-rg/providers/Microsoft.OperationalInsights/workspaces/lab2e-logs"
```

#### 🔹 Azure Portal:

1. Go to **Resource Groups** → `lab2e-rg`
2. Open AKS cluster `lab2e-aks`
3. Click **Insights** → If not enabled, click **Enable monitoring**
4. Choose existing workspace: `lab2e-logs`
5. Save settings

✅ Container Insights is now connected.

---

### 3️⃣ View Logs and Metrics (Portal)

1. From AKS cluster → Click **Insights** → **Monitoring**
2. Explore:
   - Node CPU & memory
   - Pod/container logs
   - Container restart trends

---

### 4️⃣ Run KQL Query in Azure Logs

1. In AKS cluster → Click **Logs** → Choose workspace `lab2e-logs`
2. Paste:

```kusto
ContainerLog
| where TimeGenerated > ago(1h)
| sort by TimeGenerated desc
```

3. Modify query to filter by message, pod name, or severity.

---

### 5️⃣ Create Alert Rule (Portal)

1. Go to **Monitor** → **Alerts** → **+ Create Alert Rule**
2. Set Resource: `lab2e-logs` (Log Analytics Workspace)
3. Define condition using KQL:

```kusto
ContainerLog
| where LogEntry has "error"
```

4. Add Action Group (Email/SMS)
5. Create alert rule

---

### 6️⃣ ARM Template to Enable Monitoring

#### 🔹 `aks-monitoring-enable.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "aksName": { "type": "string" },
    "location": { "type": "string" },
    "workspaceResourceId": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.ContainerService/managedClusters",
      "apiVersion": "2023-01-01",
      "name": "[parameters('aksName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addonProfiles": {
          "omsagent": {
            "enabled": true,
            "config": {
              "logAnalyticsWorkspaceResourceID": "[parameters('workspaceResourceId')]"
            }
          }
        }
      }
    }
  ]
}
```

#### 🔹 `aks-monitoring-enable.parameters.json`

```json
{
  "parameters": {
    "aksName": { "value": "lab2e-aks" },
    "location": { "value": "australiaeast" },
    "workspaceResourceId": {
      "value": "/subscriptions/<subscription-id>/resourceGroups/lab2e-rg/providers/Microsoft.OperationalInsights/workspaces/lab2e-logs"
    }
  }
}
```

#### 🔹 Deploy ARM Template via CLI:

```bash
az deployment group create \
  --resource-group lab2e-rg \
  --template-file aks-monitoring-enable.json \
  --parameters @aks-monitoring-enable.parameters.json
```

✅ This enables Azure Monitor on the AKS cluster via ARM.

---

### 7️⃣ Post-Deployment Verification Checklist

#### ✅ Check Add-on Enabled:

```bash
az aks show \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --query "addonProfiles.omsagent.enabled"
```

Expected output:

```json
true
```

#### ✅ Confirm Workspace Link:

```bash
az aks show \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --query "addonProfiles.omsagent.config.logAnalyticsWorkspaceResourceID"
```

Expected to match your actual workspace resource ID.

#### ✅ Portal Validation:

1. Go to AKS cluster → Click **Insights**
2. Confirm dashboards load (Node, Pod, Container views)

#### ✅ Run KQL Log Query:

```kusto
ContainerLog
| where TimeGenerated > ago(15m)
| take 10
```

#### ✅ Generate Dummy Activity:

```bash
kubectl run hello-debug --image=busybox -it --rm --restart=Never -- /bin/sh -c "echo 'Hello AKS Monitor'; sleep 1"
```

Then rerun:

```kusto
ContainerLog
| where LogEntry contains "Hello AKS Monitor"
```

✅ This confirms that Container Insights and log ingestion are functioning.

---

## ✅ Lab Complete

You’ve successfully configured monitoring and logging on Azure Kubernetes Service using Azure Monitor, Log Analytics, and alert rules. You also deployed monitoring configuration using ARM templates, CLI, and the Azure Portal.

