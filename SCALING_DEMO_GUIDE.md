# HPA Scaling Demo Guide

## Overview
This guide demonstrates Kubernetes Horizontal Pod Autoscaler (HPA) scaling with your patient risk prediction app.

## Prerequisites
- App running and accessible via port-forward
- HPA configured (min=2, max=5, CPU target=70%)
- 3 PowerShell terminals open

## Demo Setup

### Terminal 1: Watch HPA
```powershell
kubectl get hpa -w
```

### Terminal 2: Watch Pods
```powershell
kubectl get pods -w
```

### Terminal 3: Run Demo
```powershell
cd "C:\Users\VISHWA TEJA THOUTI\OneDrive\Desktop\DevOps-Task10\mlops-patient-risk"
.\demo_scaling.ps1
```

## What Happens During Demo

### 1. Light Load (20 users)
- **Expected**: 2 pods sufficient
- **CPU**: Normal levels
- **HPA**: No scaling action

### 2. Medium Load (40 users)
- **Expected**: CPU starts rising
- **HPA**: May add 1 pod (3 total)
- **Reason**: CPU approaching 70% threshold

### 3. Heavy Load (60 users)
- **Expected**: CPU > 70%
- **HPA**: Scales to 4 pods
- **Reason**: Sustained high CPU usage

### 4. Peak Load (100 users)
- **Expected**: Maximum load
- **HPA**: Scales to 5 pods (max)
- **Reason**: CPU consistently high

### 5. After Load Stops
- **Expected**: CPU drops below 70%
- **HPA**: Waits 5 minutes, then scales down
- **Final**: Returns to 2 pods (min)

## Alternative: Manual Scaling Demo

If load testing doesn't work, use manual scaling:

```powershell
.\manual_scaling_demo.ps1
```

This demonstrates:
- `kubectl scale deployment health-predictor --replicas=3`
- `kubectl scale deployment health-predictor --replicas=5`
- `kubectl scale deployment health-predictor --replicas=2`

## Monitoring Commands

### Real-time Monitoring
```powershell
.\monitor_scaling.ps1
```

### Individual Commands
```powershell
# CPU usage
kubectl top pods

# HPA details
kubectl describe hpa health-predictor

# Pod events
kubectl get events --sort-by=.metadata.creationTimestamp

# Current state
kubectl get pods
kubectl get hpa
```

## Troubleshooting

### HPA Shows "unknown" metrics
```powershell
# Install metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For local K8s, patch metrics-server
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
```

### Load test fails
- Ensure port-forward is running: `kubectl port-forward pod/<pod> 9100:5000`
- Check app health: `curl.exe http://localhost:9100/health`
- Verify pods are ready: `kubectl get pods`

### No scaling occurs
- Check HPA configuration: `kubectl describe hpa health-predictor`
- Verify CPU requests are set: `kubectl describe deployment health-predictor`
- Ensure metrics-server is running: `kubectl get pods -n kube-system`

## Key Learning Points

1. **HPA Formula**: `desired = ceil(current * currentCPU / targetCPU)`
2. **Scaling Behavior**: 
   - Scale up: Immediate when CPU > 70%
   - Scale down: 5-minute delay to prevent flapping
3. **Resource Management**: Requests ensure proper scheduling
4. **Cost Optimization**: Scale down during low usage
5. **High Availability**: Minimum 2 pods for redundancy

## Demo Script for Professor

1. **Show initial state**: `kubectl get pods,svc,hpa`
2. **Explain HPA config**: min=2, max=5, CPU target=70%
3. **Run load test**: `.\demo_scaling.ps1`
4. **Watch scaling**: Point to terminals showing pod count increasing
5. **Explain benefits**: Auto-scaling, cost optimization, high availability
6. **Show scale down**: After load stops, pods return to minimum

This demonstrates production-ready MLOps with automatic scaling based on demand.
