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

## 🏗️ Architecture & Features
* **IaC Mastery:** Automated provisioning of VMs, VNETs, and NSGs using **Terraform**.
* **Secure CI/CD:** A 4-stage Jenkins pipeline (Checkout -> Scan -> Push -> Deploy) that completes in **~29 seconds**.
* **Zero-Vulnerability Policy:** Every build is scanned; only images with **0 Critical Vulnerabilities** are pushed.
* **High Availability:** Deployment utilizes **2 replicas** with a rolling update strategy.

---

## 🌐 Live Access
| Service | Link | Description |
| :--- | :--- | :--- |
| **Application** | [http://20.235.35.205:32560](http://20.235.35.205:32560) | Functional Task Board app |
| **CI/CD** | [http://20.235.35.205:8080](http://20.235.35.205:8080) | Jenkins Pipeline Dashboard |
| **Monitoring** | [http://20.235.35.205:3000](http://20.235.35.205:3000) | Grafana Cluster Metrics |

---

## 📈 Monitoring & Observability
The cluster is monitored using the **kube-prometheus-stack**. Real-time metrics are scraped by **Prometheus** and visualized in **Grafana**, providing insights into pod health, CPU usage, and memory consumption.
