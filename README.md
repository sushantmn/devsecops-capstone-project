# 🚀 DevSecOps Capstone: Automated Task Board Pipeline

This repository contains a fully automated **DevSecOps pipeline** that deploys a functional Task Board application to an **Azure-hosted Kubernetes (K3s) cluster**. The project demonstrates Infrastructure as Code (IaC), Continuous Integration/Deployment (CI/CD), and real-time Monitoring.

## 🛠️ Tech Stack
* **Infrastructure:** Terraform (Azure)
* **Orchestration:** Kubernetes (K3s)
* **CI/CD:** Jenkins
* **Security:** Trivy Vulnerability Scanner
* **Containerization:** Docker
* **Monitoring:** Prometheus & Grafana

---

## 🏗️ Architecture
* **Cloud Provider**: Azure.
* **Infrastructure**: Provisioned with **Terraform** and configured via **Ansible**.
* **CI/CD**: Jenkins running in a Docker container (DooD).
* **Security**: **Trivy** vulnerability scanning integrated into the build stage [cite: 2026-03-07, 2026-03-08].
* **Orchestration**: **K3s (Lightweight Kubernetes)** for efficient resource management [cite: 2026-03-08].
* **Observability**: **Prometheus** for metric collection and **Grafana** for visualization [cite: 2026-03-07].

---

## 🚀 Pipeline Stages
1.  **Checkout**: Securely pulls code from GitHub using automated Git safety configurations [cite: 2026-03-06, 2026-03-07, 2026-03-08].
2.  **Build & Security Scan**:
    * Builds an optimized **Nginx Alpine** image [cite: 2026-03-07].
    * Runs a **Trivy scan** to enforce a zero-critical-vulnerability policy [cite: 2026-03-08].
3.  **Push**: Tags and pushes the verified image to **Docker Hub** [cite: 2026-03-08].
4.  **Deploy**: Uses a dockerized `kubectl` to apply manifests to the **K3s cluster** [cite: 2026-03-08].

---

## 🛠️ How to Run
1.  **Provision Infrastructure**:
    ```bash
    terraform apply
    ansible-playbook -i inventory.ini playbook.yml
    ```
2.  **Trigger Pipeline**:
    * Push code to the `dev` branch to trigger the Jenkins build.
3.  **Access the App**:
    * **Application**: `http://20.235.35.205:32560` [cite: 2026-03-07, 2026-03-08].
    * **Monitoring**: `http://20.235.35.205:3000` [cite: 2026-03-07].

---

## 🌐 Live Access
| Service | Link | Description |
| :--- | :--- | :--- |
| **Application** | [http://20.235.35.205:32560](http://20.235.35.205:32560) | Functional Task Board app |
| **CI/CD** | [http://20.235.35.205:8080](http://20.235.35.205:8080) | Jenkins Pipeline Dashboard |
| **Prometheus** | [http://20.235.35.205:9090/targets](http://20.235.35.205:9090/targets) | Prometheus Target Health Dashboard |
| **Monitoring** | [http://20.235.35.205:3000](http://20.235.35.205:3000) | Grafana Cluster Metrics |


---

### ✅ Final Project Status
* **Deployment**: Success [cite: 2026-03-08].
* **Replicas**: 2 healthy pods running on K3s [cite: 2026-03-08].
* **Security Findings**: 0 Critical [cite: 2026-03-08].

---
