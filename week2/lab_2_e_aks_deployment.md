# ☸️ Lab 2-E: Deploy a Containerized Application to AKS using CLI, Portal, and ARM Template

## 🎯 Objective

- Build and push a Docker image to Azure Container Registry (ACR)
- Deploy to Azure Kubernetes Service (AKS) using kubectl
- Access the app via external LoadBalancer IP
- Manage AKS workloads and deploy using ARM templates

---

## 🧰 Requirements

- **Azure CLI** v2.38.0 or later
- **Docker Desktop** installed
- **kubectl** installed (`az aks install-cli`)
- **Active Azure subscription** with sufficient quota

---

## 👣 Lab Instructions

### 1️⃣ Build the Docker Image

From your Lab 2-D directory:

```bash
docker build -t my-simple-app .
```

---

### 2️⃣ Create Azure Container Registry (ACR)

```bash
az group create --name lab2e-rg --location australiaeast
az acr create \
  --name lab2eacr12345 \
  --resource-group lab2e-rg \
  --sku Basic \
  --location australiaeast
```

✅ Ensure `lab2eacr12345` is globally unique.

---

### 3️⃣ Push Image to ACR

```bash
az acr login --name lab2eacr12345
az acr show --name lab2eacr12345 --query loginServer --output tsv
# Assume login server is lab2eacr12345.azurecr.io

docker tag my-simple-app lab2eacr12345.azurecr.io/my-simple-app:v1
docker push lab2eacr12345.azurecr.io/my-simple-app:v1
```

---

### 4️⃣ Create AKS Cluster (CLI)

```bash
az aks create \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --node-count 1 \
  --enable-addons monitoring \
  --generate-ssh-keys \
  --attach-acr lab2eacr12345
```

✅ `--attach-acr` allows AKS to pull images from ACR.

---

### 5️⃣ Connect to AKS

```bash
az aks get-credentials --resource-group lab2e-rg --name lab2e-aks
kubectl get nodes
```

✅ Node should be **Ready**.

---

### 6️⃣ Create Kubernetes Deployment and Service YAML

#### 🔹 `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: simple-app
  template:
    metadata:
      labels:
        app: simple-app
    spec:
      containers:
      - name: simple-app
        image: lab2eacr12345.azurecr.io/my-simple-app:v1
        ports:
        - containerPort: 5000
```

#### 🔹 `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: simple-app-service
spec:
  type: LoadBalancer
  selector:
    app: simple-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5000
```

---

### 7️⃣ Deploy to AKS (kubectl)

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

#### 🔹 Check status:

```bash
kubectl get pods
kubectl get services
```

✅ Wait for `EXTERNAL-IP` to be assigned (1–3 min)

🔹 Access app: `http://<EXTERNAL-IP>`

---

### 8️⃣ Deploy to AKS via Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Search → **Kubernetes services** → `lab2e-aks`
3. Open → Click **Workloads** > **+ Add** > **Deployment**
4. Input:
   - Name: `simple-app`
   - Container image: `lab2eacr12345.azurecr.io/my-simple-app:v1`
   - Port: 5000
   - Replicas: 1
5. Click **Next** → Expose Service as LoadBalancer on Port 80
6. Review + Create → Submit

✅ Open **Services** tab to get the external IP.

---

### 9️⃣ AKS Deployment using ARM Template

#### 🔹 `aks-deploy.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "aksClusterName": { "type": "string" },
    "location": { "type": "string" },
    "acrId": { "type": "string" }
  },
  "resources": [
    {
      "type": "Microsoft.ContainerService/managedClusters",
      "apiVersion": "2023-01-01",
      "name": "[parameters('aksClusterName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "dnsPrefix": "[parameters('aksClusterName')]",
        "agentPoolProfiles": [
          {
            "name": "nodepool1",
            "count": 1,
            "vmSize": "Standard_DS2_v2",
            "osType": "Linux",
            "mode": "System",
            "type": "VirtualMachineScaleSets"
          }
        ],
        "enableRBAC": true,
        "networkProfile": {
          "networkPlugin": "azure",
          "loadBalancerSku": "standard"
        },
        "addonProfiles": {
          "omsagent": {
            "enabled": true
          }
        },
        "aadProfile": {
          "managed": true
        },
        "servicePrincipalProfile": {
          "clientId": "msi"
        },
        "apiServerAccessProfile": {
          "enablePrivateCluster": false
        }
      },
      "dependsOn": []
    },
    {
      "type": "Microsoft.ContainerRegistry/registries/providers/roleAssignments",
      "apiVersion": "2022-04-01-preview",
      "name": "[format('{0}/Microsoft.Authorization/{1}', parameters('acrId'), guid(parameters('aksClusterName')))]",
      "properties": {
        "roleDefinitionId": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')]",
        "principalId": "[reference(resourceId('Microsoft.ContainerService/managedClusters', parameters('aksClusterName')), '2023-01-01', 'Full').identity.principalId]",
        "principalType": "ServicePrincipal"
      },
      "dependsOn": [
        "[resourceId('Microsoft.ContainerService/managedClusters', parameters('aksClusterName'))]"
      ]
    }
  ]
}
```

#### 🔹 `aks-deploy.parameters.json`

```json
{
  "parameters": {
    "aksClusterName": { "value": "lab2e-aks-arm" },
    "location": { "value": "australiaeast" },
    "acrId": {
      "value": "/subscriptions/<subscription-id>/resourceGroups/lab2e-rg/providers/Microsoft.ContainerRegistry/registries/lab2eacr12345"
    }
  }
}
```

#### 🔹 Deploy via CLI:

```bash
az deployment group create \
  --resource-group lab2e-rg \
  --template-file aks-deploy.json \
  --parameters @aks-deploy.parameters.json
```

✅ This provisions the AKS cluster and grants it pull access to ACR.

---

## ✅ Lab Complete

You have successfully built, pushed, and deployed a containerized app to Azure Kubernetes Service using Docker, CLI, Portal, and ARM templates.

