# Test script to verify port-killing functionality
Write-Host "Testing port-killing functionality..." -ForegroundColor Green

# Function to stop processes on a specific port (same as in start.ps1)
function Stop-ProcessOnPort {
    param([int]$Port)
    
    Write-Host "Checking port $Port..." -ForegroundColor Cyan
    
    # Method 1: Using Get-NetTCPConnection
    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        if ($connections) {
            $processes = $connections | Select-Object -ExpandProperty OwningProcess -Unique
            Write-Host "Found processes on port $Port using TCP connections: $($processes -join ', ')" -ForegroundColor Yellow
            foreach ($pid in $processes) {
                try {
                    $processInfo = Get-Process -Id $pid -ErrorAction SilentlyContinue
                    if ($processInfo) {
                        Write-Host "Stopping process $pid ($($processInfo.ProcessName))" -ForegroundColor Yellow
                        Stop-Process -Id $pid -Force -ErrorAction Stop
                        Write-Host "Stopped process $pid" -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host "Could not stop process $pid`: $_" -ForegroundColor Red
                }
            }
        }
    }
    catch {
        Write-Host "Error checking TCP connections: $_" -ForegroundColor Red
    }
    
    # Method 2: Using netstat as backup
    try {
        $netstatOutput = netstat -ano | Select-String ":$Port "
        if ($netstatOutput) {
            Write-Host "Found additional processes using netstat:" -ForegroundColor Yellow
            foreach ($line in $netstatOutput) {
                if ($line -match "\s+(\d+)$") {
                    $pid = $matches[1]
                    try {
                        $processInfo = Get-Process -Id $pid -ErrorAction SilentlyContinue
                        if ($processInfo) {
                            Write-Host "Stopping process $pid ($($processInfo.ProcessName)) found via netstat" -ForegroundColor Yellow
                            Stop-Process -Id $pid -Force -ErrorAction Stop
                            Write-Host "Stopped process $pid" -ForegroundColor Green
                        }
                    }
                    catch {
                        Write-Host "Could not stop process $pid`: $_" -ForegroundColor Red
                    }
                }
            }
        }
    }
    catch {
        Write-Host "Error using netstat: $_" -ForegroundColor Red
    }
    
    # Wait for processes to terminate
    Start-Sleep -Seconds 3
    
    # Verify port is now free
    try {
        $stillUsed = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        if ($stillUsed) {
            Write-Host "Warning: Port $Port may still be in use" -ForegroundColor Red
        } else {
            Write-Host "Port $Port is now free" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Port $Port appears to be free" -ForegroundColor Green
    }
}

# Test the function
Write-Host "Testing ports 3000 and 8000..." -ForegroundColor Yellow
Stop-ProcessOnPort -Port 3000
Stop-ProcessOnPort -Port 8000

Write-Host "Port test completed!" -ForegroundColor Green
