# LAB OUTLINE

## Infrastructure
  - Controller
  - NGINX x2
  - NGINX x1 for Dev Portal
  - Kubernetes
    - Prometheus
    - Syslog
    - Grafana
    - CI Tool
    - Orchestrator
  - BIG-IP

## Lab
  - Controller
    - APIM
    - API Versioning
      - API Sec/Mgmt *111
    - Auth/Rate/Manage
    - DevPortal Sub Lab *111
      - Create/Export
  - ADC
    - Blue/Green *111
    - Deployment of NGINX
    - NAP deployment *111
    - BIG-IP Management
  - ServiceMesh
    - TBD
  - Kubernetes (AKS/EKS Request UDF unlocking)
    - KIC (Helm/Manual) *111
    - KIC + NAP (Requires Syslog)
      - whitelist-ip
      - threat *222
      - signature
  - KIC + CIS (Requires BIG-IP)
    - Static IP address
    - DDoS profiles *222
  - Analytics (Requires Prometheus/Grafana) *111
  - NGINX Service Mesh
    - KIC + NSM (Under Development) *222
  - Unit
    - TBD


### Additional Labs
  - Cloud Services (Requires CS account)
    - DNS Load Balancer
      - GSLB for ingress
      - Region Deployments (GDPR)
    - Beacon
      - Beacon Telegraf
    - Behavioral App
      - TBD
  - AspenMesh (Requires CS accoung)
    - Service Mesh Install *333
  - BIG-IP
    - TBD (canibal)
