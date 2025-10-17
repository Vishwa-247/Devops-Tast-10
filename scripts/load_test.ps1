param(
    [int]$ConcurrentUsers = 20,
    [int]$DurationSeconds = 60,
    [string]$BaseUrl = "http://localhost:9100"
)

Write-Host "Starting load test: $ConcurrentUsers users for $DurationSeconds seconds" -ForegroundColor Green

$jobs = @()
for ($i = 1; $i -le $ConcurrentUsers; $i++) {
    $job = Start-Job -ScriptBlock {
        param($url, $duration)
        $endTime = (Get-Date).AddSeconds($duration)
        while ((Get-Date) -lt $endTime) {
            try {
                $body = @{
                    heart_rate = (Get-Random -Minimum 60 -Maximum 150)
                    blood_pressure = (Get-Random -Minimum 80 -Maximum 200)
                    temperature = (Get-Random -Minimum 95 -Maximum 105)
                    oxygen_level = (Get-Random -Minimum 85 -Maximum 100)
                } | ConvertTo-Json
                
                Invoke-RestMethod -Uri "$url/predict" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
            } catch {
                # Ignore errors for load testing
            }
            Start-Sleep -Milliseconds (Get-Random -Minimum 100 -Maximum 500)
        }
    } -ArgumentList $BaseUrl, $DurationSeconds
    $jobs += $job
}

Write-Host "Load test running... Check HPA with: kubectl get hpa -w" -ForegroundColor Yellow
Start-Sleep $DurationSeconds

# Clean up
$jobs | Stop-Job
$jobs | Remove-Job
Write-Host "Load test completed" -ForegroundColor Green
