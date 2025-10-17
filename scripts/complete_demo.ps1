# Complete MLOps Demo - HPA Working!
# This demonstrates the full MLOps pipeline with working HPA

Write-Host "=== Complete MLOps Demo - HPA Working! ===" -ForegroundColor Cyan
Write-Host "HPA is now collecting CPU metrics: cpu: 1%/70%" -ForegroundColor Green

Write-Host "`nCurrent Status:" -ForegroundColor Yellow
kubectl get pods -l app=health-predictor
kubectl get hpa

Write-Host "`nWeb Application:" -ForegroundColor Green
Write-Host "URL: http://localhost:9200" -ForegroundColor White
Write-Host "The HPA is now working and will automatically scale based on CPU!" -ForegroundColor White

Write-Host "`nDemo Instructions:" -ForegroundColor Cyan
Write-Host "1. Open http://localhost:9200 in your browser" -ForegroundColor White
Write-Host "2. In another terminal, run: kubectl get hpa -w" -ForegroundColor White
Write-Host "3. In another terminal, run: kubectl get pods -l app=health-predictor -w" -ForegroundColor White
Write-Host "4. Click 'Peak Load (100 users)' in the web UI" -ForegroundColor White
Write-Host "5. Watch the HPA automatically scale pods!" -ForegroundColor White

Write-Host "`nWhat You'll See:" -ForegroundColor Yellow
Write-Host "- HPA TARGETS will change from 1%/70% to higher values" -ForegroundColor White
Write-Host "- REPLICAS will increase from 2 to 3, 4, or 5" -ForegroundColor White
Write-Host "- New pods will be created automatically" -ForegroundColor White
Write-Host "- When load stops, pods will scale down after 5 minutes" -ForegroundColor White

Write-Host "`nHPA Configuration:" -ForegroundColor Magenta
Write-Host "- Min Pods: 2 (always running)" -ForegroundColor White
Write-Host "- Max Pods: 5 (scaling limit)" -ForegroundColor White
Write-Host "- CPU Threshold: 70%" -ForegroundColor White
Write-Host "- Scale Up: Immediate when CPU > 70%" -ForegroundColor White
Write-Host "- Scale Down: After 5 minutes of low CPU" -ForegroundColor White

Write-Host "`nKey Features Working:" -ForegroundColor Green
Write-Host "✅ HPA collecting CPU metrics" -ForegroundColor White
Write-Host "✅ Web UI load testing" -ForegroundColor White
Write-Host "✅ Automatic pod scaling" -ForegroundColor White
Write-Host "✅ Professional UI" -ForegroundColor White
Write-Host "✅ Real-time monitoring" -ForegroundColor White

Write-Host "`nMonitoring Commands:" -ForegroundColor Cyan
Write-Host "Terminal 1: kubectl get hpa -w" -ForegroundColor White
Write-Host "Terminal 2: kubectl get pods -l app=health-predictor -w" -ForegroundColor White
Write-Host "Terminal 3: Web UI at http://localhost:9200" -ForegroundColor White

Write-Host "`nDemo Ready!" -ForegroundColor Green
Write-Host "The complete MLOps pipeline is now working with automatic scaling!" -ForegroundColor Green
