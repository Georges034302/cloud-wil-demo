# 📊 Lab 7-F: Monitor and Diagnose Scaling Events

## 🎯 Objectives

- Monitor autoscale activity for Azure App Service Plans and VM Scale Sets (VMSS)
- Identify scale-in and scale-out triggers using Azure Monitor
- Analyze performance metrics and autoscale run history

---

## 🛠️ Requirements

- Azure Portal access
- App Service Plan or VMSS with autoscaling enabled

---

## 🧭 Step-by-Step: Azure Portal Monitoring

### 1️⃣ View Autoscale Run History

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Monitor**
3. Click on **Autoscale** in the left menu
4. Select your **App Service Plan** (e.g., `app-service-plan-25188`) or **VM Scale Set** (e.g., `lab7vmss`)
5. Click the **Run history** tab

✅ You’ll see:
- Scaling direction (Scale in / Scale out)
- Trigger time
- Rule and metric that caused the event

---

### 2️⃣ View Performance Metrics

1. In the **Monitor** section, click **Metrics**
2. Click **Select a scope** → Choose your App Service Plan or VMSS
3. Set **Metric Namespace** appropriately (e.g., "App Service Plan standard metrics" or "Virtual Machine Scale Set standard metrics")
4. Choose relevant metrics (e.g., `Percentage CPU`, `Instance count`)
5. Set:
   - Time range: *Last 24 hours*
   - Aggregation: *Average*

✅ This helps visualize how CPU load and instance count relate to autoscale events.

---

## 📋 Summary Table

| Task                            | Tool       | Outcome                                |
|----------------------------------|------------|----------------------------------------|
| View autoscale run history       | Portal     | See what caused recent scale actions   |
| Monitor metrics (CPU, instance)  | Portal     | Visualize performance and autoscale    |

---

## ✅ Lab Complete

You successfully monitored and diagnosed scaling events for your Azure App Service Plan and VMSS using the Azure Portal's **Autoscale Run history** and **Metrics**. Use these views to understand autoscaling triggers and performance
