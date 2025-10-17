# Patient Risk Predictor – End-to-End MLOps Approach

## 1) Business Goal
- Predict patient risk level (Low/Medium/High) from vitals: heart_rate, blood_pressure, temperature, oxygen_level.
- Non-functional: 99.9% availability, handle bursts to 100 rps, minimize idle cost.

## 2) Architecture (Why this design)
- 2‑tier, stateless API → fastest to build, easy to autoscale.
- Flask API (+ Gunicorn) serves:
  - `GET /health` for liveness/readiness probes
  - `POST /predict` returns risk, confidence
  - `/` serves a simple web UI (HTML/CSS/JS)
- Docker image (python:3.9‑slim) → reproducible runtime, small footprint.
- Kubernetes:
  - Deployment with 2 replicas for HA
  - Service (NodePort) to expose inside cluster / via port‑forward
  - HPA CPU target 70%, min=2, max=5 → scales for peaks, saves at idle
- Resources: requests 128Mi/100m; limits 256Mi/200m → stable scheduling, cost control.

## 3) Data, Model, and Rationale
- Synthetic dataset (1,000 samples) derived from realistic thresholds → no PHI, trains instantly.
- Model: scikit‑learn LogisticRegression
  - Pros: fast, explainable, small artifact (~KB)
  - Acceptable demo accuracy (~66% synthetic)
- Saved as `model.pkl` with joblib and loaded on app start.

## 4) Build & Release Flow (Formulas and Steps)
- Train locally in venv:
  1. `python app/train_model.py`
- Containerize (no multi‑stage to save time here):
  2. `docker build -t health-predictor:v2 .`
- Load into Minikube and deploy:
  3. `minikube image load health-predictor:v2`
  4. `kubectl set image deploy/health-predictor flask-api=health-predictor:v2`
  5. `kubectl rollout status deploy/health-predictor`
- Access methods:
  - NodePort: `http://$(minikube ip):30080`
  - Port‑forward (stable): `kubectl port-forward pod/<pod> 9100:5000` → `http://localhost:9100`

### HPA Desired Replicas Formula
```
desired = ceil(currentReplicas * currentCPU / targetCPU)
# Example: 2 pods at 140% vs 70% target → ceil(2 * 1.4 / 0.7) = 4
```

## 5) Health, Observability, and Reliability
- Probes every 10s on `/health` → quick detection, traffic only to Ready pods.
- Gunicorn workers=2 for concurrency; timeouts tuned for short inference.
- Simple structured JSON responses for easy log aggregation (future: Loki/ELK).

## 6) Web UI (Why + How)
- Single static page `templates/index.html` for demo speed and clarity.
- Validates inputs client‑side; calls `/predict` via fetch; color‑coded risk cards.
- Keeps demo self‑contained; no external frontend stack required.

## 7) Common Issues and Fixes
- Windows Unicode console errors → removed emojis/arrows; set `PYTHONIOENCODING=utf-8` if needed.
- Port‑forward conflicts on 8080 → use a new port `9000` or `9100`; ensure only one forward running.
- Old image serving JSON at `/` → rebuild `--no-cache`, bump tag to `v2`, `kubectl set image`.
- Service forward errors referencing missing container → forward directly to a running pod: `kubectl port-forward pod/<pod> 9100:5000`.

## 8) Demo Script (2 minutes)
1. `kubectl get pods` → show 2/2 Ready.
2. Open `http://localhost:9100` (port‑forward active) → show UI.
3. Click “Medium Risk” → Predict → show JSON result with confidence.
4. `kubectl get hpa` → explain autoscaling policy.
5. Mention resources (requests/limits) and probes.

## 9) Next Steps
- Add `/metrics` and scrape with Prometheus; Grafana dashboards.
- CI/CD with GitHub Actions (build, test, push, deploy).
- Central logs, secrets management, and RBAC hardening.

---
Status: Deployed, web UI verified via pod port‑forward at `http://localhost:9100`.
