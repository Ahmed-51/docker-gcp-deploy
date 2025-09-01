# Phase-1: Creating and Running a Docker Image for a React App 

### **1. Create the Web App**

```bash
npx create-react-app react-app
cd react-app
```

---

### **2. Add Docker and nginx files in the root of your project**

* **Dockerfile** for docker image creation
* **.dockerignore** to exclude unnecessary files (`node_modules`, `build`, etc.).
* Create a **nginx folder** and create 2 files inside: **default.conf** and **nginx.conf**
* All above files are added in this repo and **.dockerignore** is given here:

```bash
node_modules
build
.git
Dockerfile
docker-compose.yml
*.log
```
  

---

### **3. Build the React App**

```bash
npm run build
```

* Generates `build/` folder with production-ready assets.

---


### **4. Open Docker Desktop**

* Make sure Docker Desktop is running.

---

### **5. Build the Docker Image**

In VSCode terminal:

```bash
docker build -t react-docker-img .
```

* `react-docker-img` = give any name to you Docker image.

---

### **7. Run the Docker Container**

```bash
docker run -p 3000:80 react-docker-img
```

* Maps container port 80 → localhost:3000.
* port number should be the number specified in you dockerfile and nginx file

---

### **8. Test the App**

* Open browser:

```
http://localhost:3000
```

* Your React app should appear.

---
---
---



# Phase-2: Steps to deploy a Docker Image to **Google Cloud Run**

---

## **Step 0 — Prerequisites**

* Install **Google Cloud SDK**: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

---

## **Step 1 — Authenticate with GCP**

```bash
gcloud auth login
```

* Opens a browser → log in to your Google account.
* Grants `gcloud` permission to access your project.

---

## **Step 2 — Select or create your GCP project**

```bash
gcloud projects list                        # see existing projects
gcloud config set project autobizz-425913   # select any project
```

* `autobizz-425913` = your project ID.
* All subsequent commands will run under this project.

---

## **Step 3 — Enable required APIs**

```bash
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

* **Artifact/Container Registry API** → It stores your Docker image.
* **Cloud Run API** → It deploys a container with your image.

---

## **Step 4 — Configure Docker authentication**

```bash
gcloud auth configure-docker
```

* Lets you push images to GCP Container Registry (`gcr.io`) without extra credentials.

---

## **Step 5 — Build Docker image**

* Ensure your Dockerfile exposes **port 8080** for Cloud Run.
* if you choose to user any other port, **make sure you change port number during deploying at step 8**
* go to your local project directory using **cd** before running any below commands.

```bash
docker build --platform linux/amd64 -t react-docker-img .
```

* `--platform linux/amd64` → ensures compatibility with Cloud Run.
* **react-docker-img** is my docker image name.

---

## **Step 6 — Tag Docker image for GCP**

```bash
docker tag autobizz-estore gcr.io/autobizz-425913/react-docker-img:v1
```

* `v1` → version tag. Increment for future updates.

---

## **Step 7 — Push Docker image to GCP**

```bash
docker push gcr.io/autobizz-425913/react-docker-img:v1
```

* This uploads your image to **Google Container Registry**.
* Now, you can see you image inside **gcr.io folder** inside artifact registry of your project

---

## **Step 8 — Deploy to Cloud Run**

```bash
gcloud run deploy react-docker-gcp-service --image gcr.io/autobizz-425913/react-docker-img:v1 --platform managed --region us-central1 --allow-unauthenticated --port 80
```

* `react-docker-gcp-service` → name of your Cloud Run service.
* `--allow-unauthenticated` → public access.
* `--port 80` → container port (_must match port number exposed in you Dockerfile_). Cloud run Default port is 8080. You may change this port number to match the port number stated in your dockerfile.
* After executing this, you will get your URL.

---

## **Step 9 — Verify Deployment**

```bash
gcloud run services describe react-docker-gcp-service --region us-central1 --format='value(status.url)'
```

* Open the URL in your browser → React SPA should load.

---

## **Step 10 — Future Updates**

1. Update code.
2. Build new image: `docker build -t react-docker-img .`
3. Tag new version: `docker tag react-docker-img gcr.io/autobizz-425913/react-docker-img:v2`
4. Push: `docker push gcr.io/autobizz-425913/react-docker-img:v2`
5. Deploy new version:

```bash
gcloud run deploy react-docker-gcp-service --image gcr.io/autobizz-425913/react-docker-img:v2 --platform managed --region us-central1 --allow-unauthenticated --port 80
```

---

