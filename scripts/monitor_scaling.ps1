# Kubernetes Scaling Monitor Script
# Run this in separate terminals to monitor scaling

Write-Host "Kubernetes Scaling Monitor" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

Write-Host "`nChoose monitoring option:" -ForegroundColor Yellow
Write-Host "1. Watch HPA (Horizontal Pod Autoscaler)" -ForegroundColor White
Write-Host "2. Watch Pods scaling" -ForegroundColor White
Write-Host "3. Watch CPU usage" -ForegroundColor White
Write-Host "4. Watch all (HPA + Pods + CPU)" -ForegroundColor White

$choice = Read-Host "`nEnter your choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`nWatching HPA metrics..." -ForegroundColor Green
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        kubectl get hpa -w
    }
    "2" {
        Write-Host "`nWatching Pod scaling..." -ForegroundColor Green
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        kubectl get pods -l app=health-predictor -w
    }
    "3" {
        Write-Host "`nWatching CPU usage..." -ForegroundColor Green
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        kubectl top pods -l app=health-predictor -w
    }
    "4" {
        Write-Host "`nStarting comprehensive monitoring..." -ForegroundColor Green
        Write-Host "This will open 3 separate windows for monitoring" -ForegroundColor Yellow
        
        # Open HPA monitoring
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'HPA Monitoring' -ForegroundColor Green; kubectl get hpa -w"
        
        # Open Pod monitoring
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'Pod Monitoring' -ForegroundColor Green; kubectl get pods -l app=health-predictor -w"
        
        # Open CPU monitoring
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host 'CPU Monitoring' -ForegroundColor Green; kubectl top pods -l app=health-predictor -w"
        
        Write-Host "`nMonitoring windows opened!" -ForegroundColor Green
        Write-Host "Now go to http://localhost:9200 and start load testing" -ForegroundColor Cyan
    }
    default {
        Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
    }
}
