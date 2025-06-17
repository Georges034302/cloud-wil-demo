# 🛡️ Lab 5-E: Integrate Azure Policy in CI/CD

## 🎯 Objectives

- Understand Azure Policy as a governance-as-code tool
- Assign policies to enforce rules during deployments
- Integrate policy enforcement in a CI/CD pipeline
- Remediate existing resources to meet policy
- Validate compliance using Azure CLI and Portal

---

## 🧰 Requirements

- Azure CLI installed (`az login`)
- Azure Portal access
- Resource group: `lab5-rg` with existing deployments
- GitHub Actions or Azure DevOps pipeline
- Familiarity with resource deployment or ARM templates

---

## 👣 Lab Instructions

### 1️⃣ Review Built-In Azure Policy Definitions

#### 🌐 Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Policy** → Open **Azure Policy**
3. In the left pane, click **Definitions**
4. Filter **Type** = Built-in
5. Review definitions like:
   - **Require a tag on resources**
   - **Allowed locations**
   - **Audit resource SKU**
6. Note the **Definition ID** for CLI use

---

### 2️⃣ Assign the "Require a Tag" Policy

#### 🌐 Azure Portal:

1. In Azure Policy, go to **Assignments** → Click **+ Assign Policy**
2. Under **Basics**:
   - **Scope**: Resource group `lab5-rg`
   - **Policy Definition**: `Require a tag on resources`
   - **Assignment Name**: `EnforceEnvironmentTag`
3. Under **Parameters**:
   - **Tag Name**: `environment`
4. Click **Review + Create** → **Create**

✅ Any deployment to `lab5-rg` now requires the tag `environment`.

#### 💻 Azure CLI:

```bash
az policy assignment create \
  --name EnforceEnvironmentTag \
  --policy <definition-id> \
  --resource-group lab5-rg \
  --params '{"tagName": {"value": "environment"}}'
```

✅ Policy applied using CLI.

---

### 3️⃣ Test the Policy in Deployment

Try to deploy a resource (e.g., Storage Account) without the required tag:

```bash
az storage account create \
  --name nostoragetag1234 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS
```

🚫 Error:

```
(ResourceNotAllowed) The deployment is disallowed by the policy assignment 'EnforceEnvironmentTag'.
```

✅ Confirms the policy is blocking non-compliant deployments.

---

### 4️⃣ Redeploy with the Required Tag

```bash
az storage account create \
  --name tagstoragedev01 \
  --resource-group lab5-rg \
  --location australiaeast \
  --sku Standard_LRS \
  --tags environment=dev
```

✅ Policy-compliant deployment now succeeds.

---

### 5️⃣ Integrate Policy Check in CI/CD

💡 In your CI/CD pipeline, add a pre-deployment step to validate compliance using CLI:

```bash
az policy state list --resource-group lab5-rg --query "[?complianceState=='NonCompliant']"
```

✅ Pipeline can conditionally block deployments if non-compliance is detected.

---

### 6️⃣ Remediate Existing Non-Compliant Resources

#### 🌐 Azure Portal:

1. Go to **Azure Policy → Compliance**
2. Select **EnforceEnvironmentTag** assignment
3. Click **Create Remediation Task**
4. Select affected resources (e.g., Storage Account)
5. Provide tag value (e.g., `environment=dev`)
6. Click **Remediate**

✅ Azure will apply the required tag to bring resources into compliance.

---

✔️ **Lab complete – you integrated Azure Policy into your CI/CD process to enforce and remediate resource compliance programmatically.**

