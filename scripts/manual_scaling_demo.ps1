# Manual Kubernetes Scaling Demo
# This demonstrates how Kubernetes scaling works without HPA

Write-Host "=== Manual Kubernetes Scaling Demo ===" -ForegroundColor Cyan
Write-Host "Demonstrating how Kubernetes handles load scaling" -ForegroundColor Yellow

Write-Host "`nStep 1: Current State" -ForegroundColor Green
Write-Host "Checking current pods and HPA status..." -ForegroundColor White
kubectl get pods -l app=health-predictor
kubectl get hpa

Write-Host "`nStep 2: Simulate Normal Load (2 pods)" -ForegroundColor Green
Write-Host "This represents normal traffic - 2 pods handling requests" -ForegroundColor White
kubectl scale deployment health-predictor --replicas=2
Start-Sleep -Seconds 3
kubectl get pods -l app=health-predictor

Write-Host "`nStep 3: Simulate Increased Load (3 pods)" -ForegroundColor Yellow
Write-Host "Traffic increases - Kubernetes scales up to 3 pods" -ForegroundColor White
kubectl scale deployment health-predictor --replicas=3
Start-Sleep -Seconds 5
kubectl get pods -l app=health-predictor

Write-Host "`nStep 4: Simulate Peak Load (5 pods)" -ForegroundColor Red
Write-Host "Peak traffic - Kubernetes scales to maximum 5 pods" -ForegroundColor White
kubectl scale deployment health-predictor --replicas=5
Start-Sleep -Seconds 5
kubectl get pods -l app=health-predictor

Write-Host "`nStep 5: Simulate Load Reduction (3 pods)" -ForegroundColor Yellow
Write-Host "Traffic decreases - Kubernetes scales down to 3 pods" -ForegroundColor White
kubectl scale deployment health-predictor --replicas=3
Start-Sleep -Seconds 5
kubectl get pods -l app=health-predictor

Write-Host "`nStep 6: Return to Normal (2 pods)" -ForegroundColor Green
Write-Host "Back to normal traffic - Kubernetes scales down to 2 pods" -ForegroundColor White
kubectl scale deployment health-predictor --replicas=2
Start-Sleep -Seconds 5
kubectl get pods -l app=health-predictor

Write-Host "`n=== Demo Complete! ===" -ForegroundColor Cyan
Write-Host "This shows how Kubernetes automatically manages pod scaling:" -ForegroundColor White
Write-Host "- More traffic = More pods" -ForegroundColor Green
Write-Host "- Less traffic = Fewer pods" -ForegroundColor Green
Write-Host "- HPA would do this automatically based on CPU usage" -ForegroundColor Green

Write-Host "`nCurrent Status:" -ForegroundColor Yellow
kubectl get pods -l app=health-predictor
kubectl get hpa
