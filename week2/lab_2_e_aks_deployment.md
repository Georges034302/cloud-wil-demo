# ☸️ Lab 2-E: Deploy a Containerized Application to AKS

## 🎯 Objective

- Create an AKS cluster using Azure CLI
- Push Docker image to Azure Container Registry (ACR)
- Write Kubernetes deployment and service YAML files
- Deploy the container to AKS using kubectl
- Access the application via public IP
- Monitor and manage pods

---

## 🧰 Requirements

- **Azure CLI** v2.38.0 or later
- **Docker Desktop** installed and running
- **kubectl** installed (or installed via `az aks install-cli`)
- **Active Azure subscription** with:
  - Permission to create resource groups, ACR, AKS
  - Quota for 1 ACR and 1 AKS cluster (Basic tier)

---

## 👣 Lab Instructions

### 1️⃣ Build the Docker Image (from Lab 2-D)

Ensure you’ve built `my-simple-app` container using the instructions from **Lab 2-D**. This image will be pushed to ACR and deployed to AKS.

---

### 2️⃣ Create Azure Container Registry (ACR)

```bash
az acr create \
  --name lab2eacr12345 \
  --resource-group lab2e-rg \
  --sku Basic \
  --location australiaeast
```

✅ Use a **globally unique** name for the ACR (e.g., `lab2eacr12345`).

---

### 3️⃣ Push Image to ACR

```bash
az acr login --name lab2eacr12345
az acr show --name lab2eacr12345 --query loginServer --output tsv
```

📌 Example Output: `lab2eacr12345.azurecr.io`

🔹 **Tag and Push:**

```bash
docker tag my-simple-app lab2eacr12345.azurecr.io/my-simple-app:v1
docker push lab2eacr12345.azurecr.io/my-simple-app:v1
```

✅ Your container image is now stored in ACR.

---

### 4️⃣ Create an AKS Cluster

```bash
az aks create \
  --resource-group lab2e-rg \
  --name lab2e-aks \
  --node-count 1 \
  --enable-addons monitoring \
  --generate-ssh-keys \
  --attach-acr lab2eacr12345
```

✅ `--attach-acr` grants the cluster access to pull images from ACR.

---

### 5️⃣ Connect to AKS

```bash
az aks get-credentials --resource-group lab2e-rg --name lab2e-aks
kubectl get nodes
```

✅ You should see a node with status **Ready**.

---

### 6️⃣ Write Kubernetes YAML Files

🔹 **deployment.yaml:**

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

🔹 **service.yaml:**

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

### 7️⃣ Deploy to AKS

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

🔹 **Verify:**

```bash
kubectl get pods
kubectl get services
```

✅ Wait for the `EXTERNAL-IP` to be assigned (1–3 minutes).

🔹 **Test the app:** Open browser to:

```
http://<EXTERNAL-IP>
```

---

✔️ **Lab complete – you have built, pushed, and deployed a Dockerized application to AKS and accessed it via public IP!**

