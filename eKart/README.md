# eKart – Cloud‑Native E‑Commerce Application

## Overview
`eKart` is a production‑grade, cloud‑native e‑commerce platform modeled after modern marketplaces. It consists of:
- **Frontend** – React.js UI served by NGINX.
- **Backend** – Python Flask REST API (can be swapped for Java Spring Boot).
- **Database** – Amazon RDS MySQL (private subnet).
- **Containerization** – Docker images for frontend and backend.
- **Orchestration** – Amazon EKS (Kubernetes) with ALB Ingress.
- **CI/CD** – Jenkins pipeline with DevSecOps scans.
- **Infrastructure as Code** – Terraform modules for all AWS resources.
- **Monitoring** – Prometheus, Grafana, CloudWatch.

The repository follows a clear, modular layout to separate concerns and enable independent development of each component.

---
## Repository Layout
```
eKart/
├─ README.md                     # This document
├─ .gitignore                    # Global ignore rules
├─ frontend/                     # React application source
│   └─ README.md                 # Frontend development guidelines
├─ backend/                      # Flask (or Spring) API source
│   └─ README.md                 # Backend development guidelines
├─ infrastructure/
│   └─ terraform/                # Terraform root & modules
│        └─ README.md            # Terraform usage guide
├─ k8s/                          # Kubernetes manifests
│   └─ README.md                 # K8s deployment guide
└─ ci/
    └─ jenkins/                  # Jenkinsfile & scripts
        └─ README.md             # CI/CD pipeline details
```

---
## Getting Started (Local Development)
1. **Clone the repository**
   ```bash
   git clone <repo‑url> eKart
   cd eKart
   ```
2. **Set up Python virtual environment for the backend**
   ```bash
   cd backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
3. **Set up Node.js for the frontend**
   ```bash
   cd ../frontend
   npm install
   ```
4. **Run Docker Compose** (local MySQL, backend, frontend)
   ```bash
   cd ..
   docker compose up --build
   ```
   The UI will be reachable at `http://localhost` and the API at `http://localhost:8000`.

---
## Next Steps
The implementation follows a phased approach (see the implementation plan). After this repository skeleton is in place, we will:
1. Scaffold the React frontend (Phase 2).
2. Implement the Flask backend with JWT authentication (Phase 3).
3. Verify MySQL integration locally (Phase 4).
4. Provision AWS resources with Terraform (Phase 5) … and so on.

---
## Contributing
Please follow the guidelines in each sub‑directory's `README.md` for coding style, testing, and security checks.

---
## License
MIT – feel free to adapt and extend.
