# ⚙️ Lab 7-B: Configure Autoscale Rules for App Service

## 🎯 Objectives

- Understand how Azure App Service supports automatic scaling
- Create CPU-based autoscale rules for scaling out and in
- Apply autoscale settings to an App Service Plan
- Monitor autoscale conditions using Azure Monitor
- Configure and validate autoscaling using both Portal and CLI

---

## 🧰 Requirements

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
4. Ensure that autoscale is supported and enabled (Standard tier or higher)

#### 💻 Azure CLI:

```bash
az appservice plan show \
  --name Lab7Plan \
  --resource-group lab7-rg \
  --query sku.tier
```

✅ Output must be `Standard` or higher for autoscaling to work.

---

### 2️⃣ Enable Autoscale and Add Rules (Portal)

1. Go to **App Service Plan** → **Scale out (App Service plan)**
2. Toggle **Enable autoscale** to `On`
3. Click **+ Add a rule**

**Scale out rule:**

- **Metric source**: App Service Plan
- **Metric name**: CPU Percentage
- **Operator**: Greater than
- **Threshold**: 70
- **Duration**: 5 minutes
- **Action**: Increase count by 1
- **Cooldown**: 5 minutes

**Scale in rule:**

- **Metric name**: CPU Percentage
- **Operator**: Less than
- **Threshold**: 30
- **Duration**: 5 minutes
- **Action**: Decrease count by 1

**Instance limits:**

- Minimum = 1
- Maximum = 5
- Default = 2

4. Click **Save**

✅ This sets up CPU-based autoscaling.

---

### 3️⃣ Enable Autoscale and Add Rules (CLI)

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

✅ Autoscale is now fully configured via CLI.

---

### 4️⃣ Generate Load to Trigger Autoscale (Optional)

To simulate load:

- Deploy a CPU-intensive workload or stress endpoint
- Use a public load testing service (e.g., loader.io)
- Monitor activity in Azure Portal → **Metrics**
- Wait 5–10 minutes to see autoscale trigger

✅ Helps verify scale-out and scale-in actions.

---

### 5️⃣ Monitor Autoscale Activity

#### 🌐 Azure Portal:

1. Go to **Monitor** → **Autoscale**
2. Select your autoscale profile (e.g., `lab7-autoscale`)
3. View:
   - Autoscale evaluation results
   - Trigger history
   - Rule changes

#### 💻 Azure CLI:

```bash
az monitor activity-log list \
  --resource-group lab7-rg \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Observe autoscale actions triggered in real time.

---

✔️ **Lab complete – you configured autoscale rules for Azure App Service using both Portal and CLI and validated them through monitoring.**

