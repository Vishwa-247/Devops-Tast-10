# Load Test Demo with Manual Scaling
# This demonstrates the complete MLOps pipeline

Write-Host "=== MLOps Load Test Demo ===" -ForegroundColor Cyan
Write-Host "Complete demonstration of scaling with load testing" -ForegroundColor Yellow

Write-Host "`nPhase 1: Setup and Monitoring" -ForegroundColor Green
Write-Host "Starting monitoring in background..." -ForegroundColor White

# Start monitoring in background
Start-Job -Name "PodMonitor" -ScriptBlock {
    while ($true) {
        Clear-Host
        Write-Host "=== Pod Monitoring - $(Get-Date) ===" -ForegroundColor Cyan
        kubectl get pods -l app=health-predictor
        kubectl get hpa
        Start-Sleep -Seconds 3
    }
} | Out-Null

Write-Host "`nPhase 2: Normal Load (2 pods)" -ForegroundColor Green
Write-Host "Setting up normal load scenario..." -ForegroundColor White
kubectl scale deployment health-predictor --replicas=2
Start-Sleep -Seconds 3

Write-Host "`nPhase 3: Generate Load via Web UI" -ForegroundColor Yellow
Write-Host "Now go to http://localhost:9200 and:" -ForegroundColor White
Write-Host "1. Click 'Medium Load (40 users)'" -ForegroundColor White
Write-Host "2. Watch the monitoring window for changes" -ForegroundColor White
Write-Host "3. Then try 'Peak Load (100 users)'" -ForegroundColor White

Write-Host "`nPhase 4: Manual Scaling Simulation" -ForegroundColor Red
Write-Host "Simulating what HPA would do automatically..." -ForegroundColor White

Write-Host "`nSimulating CPU increase - Scaling UP to 3 pods" -ForegroundColor Yellow
kubectl scale deployment health-predictor --replicas=3
Start-Sleep -Seconds 5

Write-Host "`nSimulating higher CPU - Scaling UP to 4 pods" -ForegroundColor Yellow
kubectl scale deployment health-predictor --replicas=4
Start-Sleep -Seconds 5

Write-Host "`nSimulating peak CPU - Scaling UP to 5 pods" -ForegroundColor Red
kubectl scale deployment health-predictor --replicas=5
Start-Sleep -Seconds 5

Write-Host "`nPhase 5: Load Reduction" -ForegroundColor Green
Write-Host "Simulating load decrease - Scaling DOWN" -ForegroundColor White

Write-Host "`nScaling down to 3 pods..." -ForegroundColor Yellow
kubectl scale deployment health-predictor --replicas=3
Start-Sleep -Seconds 5

Write-Host "`nScaling down to 2 pods (normal load)..." -ForegroundColor Green
kubectl scale deployment health-predictor --replicas=2
Start-Sleep -Seconds 5

Write-Host "`n=== Demo Complete! ===" -ForegroundColor Cyan
Write-Host "This demonstrated:" -ForegroundColor White
Write-Host "✅ Load testing via web UI" -ForegroundColor Green
Write-Host "✅ Kubernetes pod scaling" -ForegroundColor Green
Write-Host "✅ MLOps pipeline in action" -ForegroundColor Green
Write-Host "✅ Auto-scaling concepts" -ForegroundColor Green

Write-Host "`nStopping monitoring..." -ForegroundColor Yellow
Get-Job -Name "PodMonitor" | Stop-Job
Get-Job -Name "PodMonitor" | Remove-Job

Write-Host "`nFinal Status:" -ForegroundColor Yellow
kubectl get pods -l app=health-predictor
kubectl get hpa
