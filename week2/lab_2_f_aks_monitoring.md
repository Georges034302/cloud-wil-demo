# 📈 Lab 2-F: Setup Monitoring & Logging for Azure Kubernetes Service (AKS)

## 🎯 Objective

- Enable Azure Monitor and Container Insights on AKS
- Configure and link a Log Analytics workspace
- Run Kusto Query Language (KQL) queries on AKS logs
- Create alert rules from log conditions
- Visualize metrics and performance in Azure Portal

---

## 🧰 Requirements

- **Azure CLI**
- **kubectl** installed (or via `az aks install-cli`)
- **Docker Desktop** running
- Working AKS cluster (from **Lab 2-E**)

---

## 👣 Lab Instructions

### 1️⃣ Ensure Prerequisites Are Met

You should already have:

- AKS cluster deployed (e.g., `lab2e-aks`)
- Azure CLI access
- Connected `kubectl` to your AKS cluster

---

### 2️⃣ Create Log Analytics Workspace

```bash
az monitor log-analytics workspace create \
  --resource-group lab2e-rg \
  --workspace-name lab2e-logs \
  --location australiaeast
```

🔍 **Tip:** This workspace will collect metrics and logs from the cluster.

---

### 3️⃣ Enable Monitoring for AKS Cluster

```bash
az aks enable-addons \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --addons monitoring \
  --workspace-resource-id "/subscriptions/<sub-id>/resourceGroups/lab2e-rg/providers/Microsoft.OperationalInsights/workspaces/lab2e-logs"
```

✅ This enables Azure Monitor and links it to your Log Analytics workspace.

---

### 4️⃣ Access Container Insights in Azure Portal

1. Visit [https://portal.azure.com](https://portal.azure.com)
2. Go to **Resource Groups** → `lab2e-rg`
3. Open your AKS cluster → Click **Insights**
4. Explore:
   - Node CPU, memory, and disk performance
   - Pod metrics and restart counts
   - Container logs and live queries

---

### 5️⃣ Run Sample KQL Queries

1. From your AKS cluster in the portal, click **Logs**
2. Paste this KQL query to show logs:

```kusto
ContainerLog
| where TimeGenerated > ago(1h)
| sort by TimeGenerated desc
```

3. Modify time ranges, pod names, or message filters to refine results

---

### 6️⃣ Create an Alert Rule

1. Navigate to **Log Analytics Workspace** → `lab2e-logs`
2. Go to **Alerts** → **+ New alert rule**
3. Set **Resource** = `lab2e-logs`
4. Define **Condition** using a KQL query (e.g., matching errors):

```kusto
ContainerLog
| where LogEntry contains "error"
```

5. Define **Action Group** to email notifications
6. Click **Create**

✅ Now you’ll be notified on important container-level events.

---

### 7️⃣ Visualize Live Metrics

1. Return to AKS cluster → **Insights**
2. Click **Metrics** tab
3. Use Metrics Explorer to visualize:
   - Pod counts
   - Container restart rates
   - Node CPU usage
4. Optionally: Pin graphs to a custom Azure Dashboard

---

✔️ **Lab complete – you’ve enabled Azure Monitor, connected Log Analytics, explored AKS logs with KQL, created alert rules, and visualized real-time metrics.**

