# MLOps Patient Risk Predictor - Setup Script
# This script sets up the complete MLOps environment

Write-Host "🏥 MLOps Patient Risk Predictor - Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`nStep 1: Checking Prerequisites" -ForegroundColor Yellow

# Check Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker not found. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check kubectl
try {
    $kubectlVersion = kubectl version --client
    Write-Host "✅ kubectl: Available" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl not found. Please install kubectl." -ForegroundColor Red
    exit 1
}

# Check Minikube
try {
    $minikubeStatus = minikube status
    Write-Host "✅ Minikube: Available" -ForegroundColor Green
} catch {
    Write-Host "❌ Minikube not found. Please install Minikube." -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 2: Starting Minikube" -ForegroundColor Yellow
minikube start
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start Minikube" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 3: Enabling Metrics Server" -ForegroundColor Yellow
minikube addons enable metrics-server
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to enable metrics-server" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 4: Training ML Model" -ForegroundColor Yellow
cd app
python train_model.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to train model" -ForegroundColor Red
    exit 1
}
cd ..

Write-Host "`nStep 5: Building Docker Image" -ForegroundColor Yellow
docker build -t health-predictor:v1 .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build Docker image" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 6: Loading Image to Minikube" -ForegroundColor Yellow
minikube image load health-predictor:v1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to load image to Minikube" -ForegroundColor Red
    exit 1
}

Write-Host "`nStep 7: Deploying to Kubernetes" -ForegroundColor Yellow
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml

Write-Host "`nStep 8: Waiting for Deployment" -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=health-predictor --timeout=60s

Write-Host "`nStep 9: Setting up Port Forwarding" -ForegroundColor Yellow
Write-Host "Starting port forwarding in background..." -ForegroundColor White
Start-Job -Name "PortForward" -ScriptBlock {
    kubectl port-forward svc/health-predictor 8080:80
} | Out-Null

Start-Sleep -Seconds 5

Write-Host "`n✅ Setup Complete!" -ForegroundColor Green
Write-Host "`n🌐 Application Access:" -ForegroundColor Cyan
Write-Host "URL: http://localhost:8080" -ForegroundColor White
Write-Host "Health Check: http://localhost:8080/health" -ForegroundColor White

Write-Host "`n📊 Monitoring Commands:" -ForegroundColor Cyan
Write-Host "kubectl get pods -l app=health-predictor" -ForegroundColor White
Write-Host "kubectl get hpa" -ForegroundColor White
Write-Host "kubectl top pods -l app=health-predictor" -ForegroundColor White

Write-Host "`n🎬 Demo Scripts:" -ForegroundColor Cyan
Write-Host ".\scripts\complete_demo.ps1" -ForegroundColor White
Write-Host ".\scripts\manual_scaling_demo.ps1" -ForegroundColor White
Write-Host ".\scripts\load_test_demo.ps1" -ForegroundColor White

Write-Host "`n🚀 Ready to demonstrate MLOps!" -ForegroundColor Green
