# 🗓️ Lab 7-C: Schedule-Based Autoscaling

## 🌟 Objectives

- Understand how scheduled scaling works as part of Azure autoscale
- Configure time-based scaling rules for an App Service
- Define different capacity targets for weekdays and weekends
- Use Azure Portal, CLI, and ARM to manage and monitor schedule profiles
- Optimize capacity during business hours and reduce costs during off-hours

---

## 🛠️ Requirements

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

### 2️⃣ Create Business Hours Profile (Weekdays)

1. Click **+ Add a scale condition** → Name: `BusinessHoursScaling`
2. Under **Recurrence**, set:
   - Time zone: Your local time zone (e.g., `AUS Eastern Standard Time`)
   - Days: Monday to Friday
   - Start time: 08:00
   - End time: 18:00
3. Instance limits:
   - Minimum: 3
   - Maximum: 5
   - Default: 3
4. Click **Add**

✅ Enables higher capacity during business hours.

---

### 3️⃣ Create Off-Hours Profile (Nights & Weekends)

1. Click **+ Add a scale condition** → Name: `OffHoursScaling`
2. Recurrence:
   - Days: Monday to Sunday
   - Start time: 18:00
   - End time: 08:00 (next day)
3. Instance limits:
   - Minimum: 1
   - Maximum: 1
   - Default: 1
4. Click **Add** → then **Save** the profile

✅ Reduces resource usage outside of business hours.

---

### 4️⃣ Schedule Autoscale Rules via CLI

#### Create Autoscale Setting:

```bash
az monitor autoscale create \
  --resource-group lab7-rg \
  --resource Lab7Plan \
  --resource-type Microsoft.Web/serverfarms \
  --name lab7-scheduled-scale \
  --count 1 --min-count 1 --max-count 5 \
  --location australiaeast
```

#### Add Business Hours Profile:

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

#### Add Off-Hours Profile:

```bash
az monitor autoscale profile create \
  --resource-group lab7-rg \
  --autoscale-name lab7-scheduled-scale \
  --name OffHoursScaling \
  --timezone "AUS Eastern Standard Time" \
  --recurrence frequency=Week daysofweek=Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday \
  --start 18:00 --end 08:00 \
  --min-count 1 --max-count 1 --count 1
```

✅ CLI setup enables precise and repeatable schedules.

---

### 5️⃣ Schedule Autoscale via ARM Template

Create `schedule-autoscale.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/autoscalesettings",
      "apiVersion": "2015-04-01",
      "name": "lab7-scheduled-scale",
      "location": "australiaeast",
      "properties": {
        "targetResourceUri": "/subscriptions/<sub-id>/resourceGroups/lab7-rg/providers/Microsoft.Web/serverfarms/Lab7Plan",
        "enabled": true,
        "profiles": [
          {
            "name": "BusinessHoursScaling",
            "capacity": {
              "minimum": "3",
              "maximum": "5",
              "default": "3"
            },
            "recurrence": {
              "frequency": "Week",
              "schedule": {
                "timeZone": "AUS Eastern Standard Time",
                "days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
                "hours": [8],
                "minutes": [0]
              }
            },
            "rules": []
          },
          {
            "name": "OffHoursScaling",
            "capacity": {
              "minimum": "1",
              "maximum": "1",
              "default": "1"
            },
            "recurrence": {
              "frequency": "Week",
              "schedule": {
                "timeZone": "AUS Eastern Standard Time",
                "days": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                "hours": [18],
                "minutes": [0]
              }
            },
            "rules": []
          }
        ]
      }
    }
  ]
}
```

Then deploy:

```bash
az deployment group create \
  --resource-group lab7-rg \
  --template-file schedule-autoscale.json
```

🔄 Replace `<sub-id>` with your actual subscription ID.

---

### 6️⃣ Monitor Scheduled Autoscale Activity

#### 🌐 Azure Portal:

1. Go to **Monitor** → **Autoscale**
2. Select `lab7-scheduled-scale`
3. View:
   - Run history
   - Evaluation details
   - Any triggered events

#### 💻 Azure CLI:

```bash
az monitor activity-log list \
  --resource-group lab7-rg \
  --max-events 10 \
  --query "[?contains(operationName.value, 'Autoscale')].{Time:eventTimestamp, Operation:operationName.value, Status:status.value}" \
  --output table
```

✅ Observe autoscale events over time.

---

## ✅ Lab Complete

You successfully configured and monitored schedule-based autoscaling using Azure Portal, CLI, and ARM templates to optimize App Service Plan usage.

