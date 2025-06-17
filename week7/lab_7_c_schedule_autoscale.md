# 🗓️ Lab 7-C: Schedule-Based Autoscaling

## 🎯 Objectives

- Understand how scheduled scaling works as part of Azure autoscale
- Configure time-based scaling rules for an App Service
- Define different capacity targets for weekdays and weekends
- Use Azure CLI and Portal to manage and monitor schedule profiles
- Optimize capacity during business hours and reduce costs during off-hours

---

## 🧰 Requirements

- Azure CLI installed (`az login`)
- App Service Plan (e.g., `Lab7Plan`) in Standard or higher tier
- Resource group (e.g., `lab7-rg`)
- Autoscaling must already be enabled (see Lab 7-B)

---

## 👣 Lab Instructions

### 1️⃣ Open Autoscale Settings (Azure Portal)

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **App Service Plans** → Select `Lab7Plan`
3. In the left pane, click **Scale out (App Service plan)**
4. Click **Custom autoscale** to configure profiles

---

### 2️⃣ Create a Business Hours Scaling Profile

1. Click **+ Add a scale condition** → Name: `BusinessHoursScaling`
2. Under **Recurrence**, set:
   - Time zone: Your local time zone
   - Days: Monday to Friday
   - Start time: 08:00
   - End time: 18:00
3. Under **Instance limits**:
   - Minimum: 3
   - Maximum: 5
   - Default: 3
4. Click **Add** to save the profile

✅ This ensures higher capacity during business hours.

---

### 3️⃣ Create an Off-Hours Scaling Profile

1. Click **+ Add a scale condition** → Name: `OffHoursScaling`
2. Schedule:
   - Days: All days
   - Start: 18:00
   - End: 08:00 (next day)
3. Instance limits:
   - Minimum / Maximum / Default = 1
4. Click **Add** → then **Save** overall autoscale settings

✅ Your app will now scale based on time of day and day of week.

---

### 4️⃣ Schedule Autoscale Rules (Azure CLI)

#### 🔹 Create or Update Autoscale Setting:

```bash
az monitor autoscale create \
  --resource-group lab7-rg \
  --resource Lab7Plan \
  --resource-type Microsoft.Web/serverfarms \
  --name lab7-scheduled-scale \
  --count 1 --min-count 1 --max-count 5 \
  --location australiaeast
```

#### 🔹 Add Business Hours Profile:

```bash
az monitor autoscale profile create \
  --resource-group lab7-rg \
  --autoscale-name lab7-scheduled-scale \
  --name BusinessHoursScaling \
  --timezone "AUS Eastern Standard Time" \
  --recurrence frequency=Week daysofweek=Monday,Tuesday,Wednesday,Thursday,Friday \
  --start 08:00 --end 18:00 \
  --min-count 3 --max-count 5 --count 3
```

#### 🔹 Add Off-Hours Profile:

```bash
az monitor autoscale profile create \
  --resource-group lab7-rg \
  --autoscale-name lab7-scheduled-scale \
  --name OffHoursScaling \
  --timezone "AUS Eastern Standard Time" \
  --recurrence frequency=Week \
  --start 18:00 --end 08:00 \
  --min-count 1 --max-count 1 --count 1
```

✅ CLI-based setup allows precise profile configuration.

---

### 5️⃣ Monitor Scheduled Autoscale Activity

#### 🌐 Azure Portal:

1. Go to **Monitor** → **Autoscale**
2. Select **lab7-scheduled-scale**
3. View **Run history** and confirm time-based scale actions

#### 💻 Azure CLI:

```bash
az monitor activity-log list \
  --resource-group lab7-rg \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Schedule-based scaling may take several minutes to activate.

---

✔️ **Lab complete – you configured and monitored schedule-based autoscaling using both the Azure Portal and CLI.**

