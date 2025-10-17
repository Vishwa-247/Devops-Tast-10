# Test Scaling Demo Script
# This script demonstrates the new scaling controls in the web UI

Write-Host "MLOps Scaling Demo - Enhanced Frontend" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`nCurrent Status:" -ForegroundColor Yellow
kubectl get pods -l app=health-predictor
kubectl get hpa

Write-Host "`nWeb Application Access:" -ForegroundColor Green
Write-Host "URL: http://localhost:9100" -ForegroundColor White
Write-Host "The web UI now includes scaling control buttons!" -ForegroundColor White

Write-Host "`nNew Features Added:" -ForegroundColor Magenta
Write-Host "[SUCCESS] Light Load (20 users) button" -ForegroundColor Green
Write-Host "[SUCCESS] Medium Load (40 users) button" -ForegroundColor Green  
Write-Host "[SUCCESS] Heavy Load (60 users) button" -ForegroundColor Green
Write-Host "[SUCCESS] Peak Load (100 users) button" -ForegroundColor Green
Write-Host "[SUCCESS] Stop Load Test button" -ForegroundColor Green
Write-Host "[SUCCESS] Real-time status updates" -ForegroundColor Green
Write-Host "[SUCCESS] Auto-stop after 30 seconds" -ForegroundColor Green

Write-Host "`nHow to Demo:" -ForegroundColor Cyan
Write-Host "1. Open http://localhost:9100 in your browser" -ForegroundColor White
Write-Host "2. Scroll down to 'Kubernetes Scaling Demo' section" -ForegroundColor White
Write-Host "3. Click 'Light Load (20 users)' to start a gentle load test" -ForegroundColor White
Write-Host "4. Watch the status updates in real-time" -ForegroundColor White
Write-Host "5. In another terminal, run: kubectl get hpa -w" -ForegroundColor White
Write-Host "6. Try 'Peak Load (100 users)' for dramatic scaling!" -ForegroundColor White

Write-Host "`nMonitoring Commands:" -ForegroundColor Yellow
Write-Host "kubectl get hpa -w          # Watch HPA metrics" -ForegroundColor White
Write-Host "kubectl get pods -w         # Watch pod scaling" -ForegroundColor White
Write-Host "kubectl top pods            # See CPU usage" -ForegroundColor White

Write-Host "`nDemo Ready!" -ForegroundColor Green
Write-Host "The enhanced frontend is now live with integrated scaling controls!" -ForegroundColor Green
