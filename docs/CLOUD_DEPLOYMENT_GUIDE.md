# 🌐 SLIIT SE3090 — Assignment 1: Zero-Cost Cloud Deployment Guide

**Project**: Rental Management System (RMS)  
**Group ID**: `SEF_KDY_AI_04` (SLIIT Kandy Uni)  
**Target Deadline**: September 30, 2026  
**Compliance**: SE3090 Specification Section 14 (Zero-Cost / Institution Provided Services)  

---

## 🚀 Free Tier Deployment Architecture (10-Minute Setup)

According to Section 14, evaluators require working live URLs for the **React Web App**, **ASP.NET Core API (/health and /swagger)**, and secure **PostgreSQL Database**.

```mermaid
graph TD
    subgraph Cloud Infrastructure [Zero-Cost Free Tier Cloud]
        A[Vercel / Netlify<br/>React 19 Frontend Web Portal]
        B[Render.com / Railway<br/>ASP.NET Core Web API :5000]
        C[(Neon.tech / Render Postgres<br/>PostgreSQL 16 Database)]
        D[Internal Microservice<br/>LangGraph Python AI Engine]
    end

    A -->|HTTPS REST| B
    B -->|Encrypted SSL| C
    B -->|Internal Call / Fallback| D
```

---

## 🛠️ Step-by-Step Deployment Instructions

### STEP 1: Deploy PostgreSQL Database (Neon.tech — 60 Seconds)
1. Go to **[https://neon.tech](https://neon.tech)** and sign up with your GitHub account.
2. Click **[Create Project]**:
   - Name: `rms-postgres-db`
   - Region: `Asia Pacific (Singapore)`
3. Under **Connection Details**, copy the PostgreSQL connection string:
   ```text
   postgres://neondb_owner:YOUR_PASSWORD@ep-xyz.ap-southeast-1.aws.neon.tech/neondb?sslmode=require
   ```
4. *Note: When the ASP.NET Core backend starts, its built-in EF Core migration pipeline will automatically create all tables, indexes, and seed demo properties!*

---

### STEP 2: Deploy ASP.NET Core Web API (Render.com — 4 Minutes)
1. Go to **[https://render.com](https://render.com)** and sign in with GitHub.
2. Click **[New +]** $\rightarrow$ **[Web Service]**.
3. Select your GitHub repository: `IT24200314/SE3090-RMS`.
4. Configure service parameters:
   - **Name**: `rms-backend-api`
   - **Region**: `Singapore`
   - **Environment**: `Docker`
   - **Dockerfile Path**: `backend/Dockerfile`
   - **Docker Context**: `backend`
   - **Instance Type**: `Free`
5. Under **Environment Variables**, add:
   - `ConnectionStrings__DefaultConnection`: *(Paste your Neon connection string from Step 1)*
   - `ASPNETCORE_ENVIRONMENT`: `Production`
   - `Jwt__Key`: `RMS_Super_Secret_Security_Key_SE3090_Assignment_Grading_2026_Key!`
   - `Jwt__Issuer`: `RMS_API`
   - `Jwt__Audience`: `RMS_Clients`
6. Click **[Create Web Service]**.
7. Once deployed, note your public API URL:
   - **Health URL**: `https://rms-backend-api.onrender.com/health`
   - **Swagger URL**: `https://rms-backend-api.onrender.com/swagger`

---

### STEP 3: Deploy React Frontend (Vercel — 2 Minutes)
1. Go to **[https://vercel.com](https://vercel.com)** and sign in with GitHub.
2. Click **[Add New...]** $\rightarrow$ **[Project]**.
3. Import your repository: `IT24200314/SE3090-RMS`.
4. In the configuration dialog:
   - **Root Directory**: Click edit and select `frontend`.
   - **Framework Preset**: `Vite`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
5. Under **Environment Variables**, add:
   - `VITE_API_BASE_URL`: `https://rms-backend-api.onrender.com` (Your Render backend URL)
6. Click **[Deploy]**.
7. In ~45 seconds, your live React portal will be online (e.g. `https://rms-se3090.vercel.app`)!

---

### STEP 4: Android APK Delivery
- The runnable Android APK is pre-built and located at:
  ```text
  mobile/build/app/outputs/flutter-apk/app-debug.apk (150 MB)
  ```
- Evaluators can install this APK directly on any Android device or emulator.

---

## 📋 Required Submission Evidence Checklist (Section 14 & 15)

| Deliverable | URL / Artifact Location | Conformance |
|---|---|:---:|
| **Public GitHub Repo** | `https://github.com/IT24200314/SE3090-RMS` | Section 13 |
| **React Live Web Portal** | `https://rms-se3090.vercel.app` | Section 14 |
| **ASP.NET Core Health URL** | `https://rms-backend-api.onrender.com/health` | Section 14 |
| **Swagger Documentation** | `https://rms-backend-api.onrender.com/swagger` | Section 14 |
| **PostgreSQL Database** | Hosted on Neon.tech (Singapore AWS) | Section 14 |
| **Runnable Android APK** | `mobile/build/app/outputs/flutter-apk/app-debug.apk` | Section 14 |
| **Agentic AI Microservice** | Internal service with automatic resilient fallback proxy | Section 9 & 14 |
