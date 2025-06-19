# 🐳 Lab 2-D: Containerize a Simple Application with Docker and Deploy via CLI, Portal, and ARM Templates

## 🎯 Objective

- Install and verify Docker installation
- Create a simple Python web application
- Write a Dockerfile to containerize the app
- Build and run a Docker image locally
- Deploy containerized app to Azure Container Instance (ACI) using CLI, Portal, and ARM Template

---

## 🧰 Requirements

- **Docker Desktop** installed ([Install Docker](https://www.docker.com/products/docker-desktop))
- **Azure CLI** installed (`az version`)
- (Optional) **Visual Studio Code** with Docker extension

---

## 👣 Lab Instructions

### 1️⃣ Install and Verify Docker

#### 🔹 Verify Docker is working:

```bash
docker --version
docker run hello-world
```

✅ You should see a welcome message confirming Docker is working.

---

### 2️⃣ Create a Simple Web App

#### 🔹 Create project folder and files:

```bash
mkdir lab2d-docker && cd lab2d-docker
```

#### 🔹 `app.py`

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Dockerized Flask App!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

#### 🔹 `requirements.txt`

```txt
flask
```

---

### 3️⃣ Write the Dockerfile

#### 🔹 `Dockerfile`

```Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

---

### 4️⃣ Build and Run the Docker Image Locally

#### 🔹 Build image:

```bash
docker build -t flask-simple-app .
```

#### 🔹 Run container:

```bash
docker run -d -p 5000:5000 flask-simple-app
```

✅ Access app at: [http://localhost:5000](http://localhost:5000)

---

### 5️⃣ Push Image to Azure Container Registry (ACR)

#### 🔹 Login to Azure:

```bash
az login
```

#### 🔹 Create ACR:

```bash
az acr create --name myacruniquename --resource-group lab2d-rg --sku Basic --location australiaeast
az acr login --name myacruniquename
```

#### 🔹 Tag and push image:

```bash
az acr repository list --name myacruniquename

# Get login server name:
az acr show --name myacruniquename --query loginServer --output tsv

# Example tagging:
docker tag flask-simple-app myacruniquename.azurecr.io/flask-simple-app:v1

# Push image:
docker push myacruniquename.azurecr.io/flask-simple-app:v1
```

---

### 6️⃣ Deploy Container to Azure Container Instance (CLI)

```bash
az container create \
  --resource-group lab2d-rg \
  --name flask-container \
  --image myacruniquename.azurecr.io/flask-simple-app:v1 \
  --cpu 1 \
  --memory 1 \
  --registry-login-server myacruniquename.azurecr.io \
  --registry-username <acr-username> \
  --registry-password <acr-password> \
  --dns-name-label flask-demo-lab2d \
  --ports 5000 \
  --location australiaeast
```

✅ Visit your container: [http://flask-demo-lab2d.australiaeast.azurecontainer.io:5000](http://flask-demo-lab2d.australiaeast.azurecontainer.io:5000)

---

### 7️⃣ Deploy Container via Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Container Instances** → **Create**
3. Fill:
   - **Resource Group**: `lab2d-rg`
   - **Container Name**: `flask-container`
   - **Region**: `Australia East`
   - **Image Source**: Azure Container Registry
   - **Image**: Select `flask-simple-app:v1`
   - **Ports**: 5000
   - **DNS label**: `flask-demo-lab2d`
4. Click **Review + create** → **Create**

✅ After deployment, access via DNS URL.

---

### 8️⃣ Deploy Container Using ARM Template

#### 🔹 `aci-deploy.json`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "containerName": { "type": "string" },
    "image": { "type": "string" },
    "dnsLabel": { "type": "string" },
    "location": { "type": "string", "defaultValue": "australiaeast" }
  },
  "resources": [
    {
      "type": "Microsoft.ContainerInstance/containerGroups",
      "apiVersion": "2021-07-01",
      "name": "[parameters('containerName')]",
      "location": "[parameters('location')]",
      "properties": {
        "containers": [
          {
            "name": "[parameters('containerName')]",
            "properties": {
              "image": "[parameters('image')]",
              "resources": {
                "requests": {
                  "cpu": 1,
                  "memoryInGb": 1
                }
              },
              "ports": [ { "port": 5000 } ]
            }
          }
        ],
        "osType": "Linux",
        "ipAddress": {
          "type": "Public",
          "dnsNameLabel": "[parameters('dnsLabel')]",
          "ports": [ { "protocol": "tcp", "port": 5000 } ]
        }
      }
    }
  ]
}
```

#### 🔹 `aci-deploy.parameters.json`

```json
{
  "parameters": {
    "containerName": { "value": "flask-container" },
    "image": { "value": "myacruniquename.azurecr.io/flask-simple-app:v1" },
    "dnsLabel": { "value": "flask-demo-lab2d" },
    "location": { "value": "australiaeast" }
  }
}
```

#### 🔹 CLI Deployment:

```bash
az deployment group create \
  --resource-group lab2d-rg \
  --template-file aci-deploy.json \
  --parameters @aci-deploy.parameters.json
```

---

## ✅ Lab Complete

You’ve containerized a Python Flask app and deployed it to Azure Container Instances using Docker, Azure CLI, Portal, and ARM templates.

