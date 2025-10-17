# Demo Scaling Script - Run this to demonstrate HPA scaling
# Make sure your app is running first: kubectl port-forward pod/<pod> 9100:5000

Write-Host "=== HPA Scaling Demo ===" -ForegroundColor Cyan
Write-Host "Make sure you have 3 terminals open:" -ForegroundColor Yellow
Write-Host "Terminal 1: kubectl get hpa -w" -ForegroundColor White
Write-Host "Terminal 2: kubectl get pods -w" -ForegroundColor White
Write-Host "Terminal 3: Run this script" -ForegroundColor White
Write-Host ""

# Check if app is accessible
try {
    $health = Invoke-RestMethod -Uri "http://localhost:9100/health" -TimeoutSec 5
    Write-Host "✓ App is accessible" -ForegroundColor Green
} catch {
    Write-Host "✗ App not accessible. Start port-forward first:" -ForegroundColor Red
    Write-Host "kubectl port-forward pod/<pod> 9100:5000" -ForegroundColor Yellow
    exit 1
}

# Show initial state
Write-Host "`n=== Initial State ===" -ForegroundColor Cyan
kubectl get pods
kubectl get hpa

Write-Host "`nPress Enter to start load testing sequence..." -ForegroundColor Yellow
Read-Host

# Load test sequence
$testCases = @(
    @{Users=20; Duration=30; Name="Light Load"},
    @{Users=40; Duration=30; Name="Medium Load"},
    @{Users=60; Duration=30; Name="Heavy Load"},
    @{Users=100; Duration=30; Name="Peak Load"}
)

foreach ($test in $testCases) {
    Write-Host "`n=== $($test.Name): $($test.Users) users for $($test.Duration) seconds ===" -ForegroundColor Magenta
    
    # Start load test
    .\load_test.ps1 -ConcurrentUsers $test.Users -DurationSeconds $test.Duration
    
    # Show current state
    Write-Host "`nCurrent pod count:" -ForegroundColor Cyan
    kubectl get pods
    Write-Host "`nHPA status:" -ForegroundColor Cyan
    kubectl get hpa
    
    if ($test -ne $testCases[-1]) {
        Write-Host "`nWaiting 10 seconds before next test..." -ForegroundColor Yellow
        Start-Sleep 10
    }
}

Write-Host "`n=== Load Testing Complete ===" -ForegroundColor Green
Write-Host "Watch HPA scale down over the next 5 minutes..." -ForegroundColor Yellow
Write-Host "`nFinal state:" -ForegroundColor Cyan
kubectl get pods
kubectl get hpa
