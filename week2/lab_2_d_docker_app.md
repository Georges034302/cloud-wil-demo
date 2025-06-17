# 🐳 Lab 2-D: Containerize a Simple Application with Docker

## 🎯 Objective

- Install and verify Docker installation
- Create a simple Python web application
- Write a Dockerfile to containerize the app
- Build and run a Docker image
- View, tag, stop, and remove containers and images

---

## 🧰 Requirements

- **Docker** installed ([Install Docker Desktop](https://www.docker.com/products/docker-desktop))
- **Azure CLI** installed
- **Docker Extension** in VS Code
- **Visual Studio Code** with Bicep extension (recommended)

---

## 👣 Lab Instructions

### 1️⃣ Install and Verify Docker

🔹 **Check Docker version:**

```bash
docker --version
```

🔹 **Test Docker installation:**

```bash
docker run hello-world
```

✅ You should see a welcome message confirming Docker is running.

---

### 2️⃣ Create a Simple Web App

🔹 **Create project folder:**

```bash
mkdir lab2d-docker && cd lab2d-docker
```

🔹 **Create a Python app:** Create a file named `app.py`:

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Dockerized Flask App!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

🔹 **Create requirements file:** Create a file named `requirements.txt`:

```txt
flask
```

---

### 3️⃣ Write a Dockerfile

🔹 **Dockerfile:**

```Dockerfile
# Use a base Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

# Command to run the application
CMD ["python", "app.py"]
```

✅ This defines how to build and run your application image.

---

### 4️⃣ Build the Docker Image

🔹 **Build command:**

```bash
docker build -t my-simple-app .
```

✅ Docker reads the Dockerfile, installs dependencies, and tags the image.

---

### 5️⃣ Run the Docker Container

🔹 **Run the app:**

```bash
docker run -d -p 5000:5000 my-simple-app
```

✅ App runs in background, accessible at:

- [http://localhost:5000](http://localhost:5000)

---

### 6️⃣ Manage Containers and Images

🔹 **List running containers:**

```bash
docker ps
```

🔹 **Stop a container:**

```bash
docker stop <container-id>
```

🔹 **Remove a container:**

```bash
docker rm <container-id>
```

🔹 **Remove an image:**

```bash
docker rmi my-simple-app
```

✅ You’ve containerized, deployed, and cleaned up a Dockerized app.

---

✔️ **Lab complete – you have successfully created, containerized, and managed a Python web app using Docker.**

