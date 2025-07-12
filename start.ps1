# Zerodha API Project Startup Script
# This script starts both backend and frontend servers

Write-Host "Starting Zerodha API Project..." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Function to stop processes on a specific port
function Stop-ProcessOnPort {
    param([int]$Port)
    
    Write-Host "Checking port $Port..." -ForegroundColor Cyan
    
    # Method 1: Using Get-NetTCPConnection
    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        if ($connections) {
            $processes = $connections | Select-Object -ExpandProperty OwningProcess -Unique
            Write-Host "Found processes on port $Port using TCP connections: $($processes -join ', ')" -ForegroundColor Yellow
            foreach ($processId in $processes) {
                try {
                    $processInfo = Get-Process -Id $processId -ErrorAction SilentlyContinue
                    if ($processInfo) {
                        # Skip system processes that can't be stopped
                        if ($processInfo.ProcessName -eq "System" -or $processId -eq 4) {
                            Write-Host "Skipping system process $processId ($($processInfo.ProcessName)) - checking if port is actually in use by user process" -ForegroundColor Yellow
                            continue
                        }
                        
                        Write-Host "Stopping process $processId ($($processInfo.ProcessName))" -ForegroundColor Yellow
                        Stop-Process -Id $processId -Force -ErrorAction Stop
                        Write-Host "Stopped process $processId" -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host "Could not stop process $processId`: $_" -ForegroundColor Red
                }
            }
        }
    }
    catch {
        Write-Host "Error checking TCP connections: $_" -ForegroundColor Red
    }
    
    # Method 2: Using netstat as backup to find user processes only
    try {
        $netstatOutput = netstat -ano | Select-String ":$Port " | Where-Object { $_ -notmatch "0\.0\.0\.0:$Port" }
        if ($netstatOutput) {
            Write-Host "Found additional processes using netstat:" -ForegroundColor Yellow
            foreach ($line in $netstatOutput) {
                if ($line -match "\s+(\d+)$") {
                    $processId = $matches[1]
                    try {
                        $processInfo = Get-Process -Id $processId -ErrorAction SilentlyContinue
                        if ($processInfo -and $processInfo.ProcessName -ne "System" -and $processId -ne 4) {
                            Write-Host "Stopping process $processId ($($processInfo.ProcessName)) found via netstat" -ForegroundColor Yellow
                            Stop-Process -Id $processId -Force -ErrorAction Stop
                            Write-Host "Stopped process $processId" -ForegroundColor Green
                        }
                    }
                    catch {
                        Write-Host "Could not stop process $processId`: $_" -ForegroundColor Red
                    }
                }
            }
        }
    }
    catch {
        Write-Host "Error using netstat: $_" -ForegroundColor Red
    }
    
    # Wait for processes to terminate
    Start-Sleep -Seconds 2
    
    # Final check: try to bind to the port to see if it's actually available
    try {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
        $listener.Start()
        $listener.Stop()
        Write-Host "Port $Port is available for use" -ForegroundColor Green
    }
    catch {
        Write-Host "Port $Port appears to be in use, but may be available for our application" -ForegroundColor Yellow
        Write-Host "If startup fails, you may need to choose different ports" -ForegroundColor Yellow
    }
}

# Stop any processes on ports 3000 and 8000
Write-Host "Checking and stopping processes on ports 3000 and 8000..." -ForegroundColor Yellow
Stop-ProcessOnPort -Port 3000
Stop-ProcessOnPort -Port 8000

# Alternative port strategy if main ports are unavailable
$backendPort = 3000
$frontendPort = 8000

# Check if we need alternative ports
try {
    $listener3000 = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, 3000)
    $listener3000.Start()
    $listener3000.Stop()
}
catch {
    Write-Host "Port 3000 still unavailable, trying alternative port 3001..." -ForegroundColor Yellow
    $backendPort = 3001
}

try {
    $listener8000 = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, 8000)
    $listener8000.Start()
    $listener8000.Stop()
}
catch {
    Write-Host "Port 8000 still unavailable, trying alternative port 8001..." -ForegroundColor Yellow
    $frontendPort = 8001
}

# Start Backend
Write-Host "Starting Backend (FastAPI) on port $backendPort..." -ForegroundColor Yellow
$backendCommand = "cd '$PSScriptRoot\backend'; python -m venv venv; .\venv\Scripts\Activate.ps1; pip install -r requirements.txt; python main.py --port $backendPort"
Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", $backendCommand -WindowStyle Normal

# Wait a bit for backend to start
Start-Sleep -Seconds 5

# Update frontend .env file with correct backend port
$envContent = @"
PORT=$frontendPort
REACT_APP_API_BASE_URL=http://localhost:$backendPort
"@
$envContent | Out-File -FilePath "$PSScriptRoot\frontend\.env" -Encoding UTF8

# Start Frontend
Write-Host "Starting Frontend (React) on port $frontendPort..." -ForegroundColor Yellow
$frontendCommand = "cd '$PSScriptRoot\frontend'; npm install; npm start"
Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", $frontendCommand -WindowStyle Normal

Write-Host "=====================================" -ForegroundColor Green
Write-Host "Backend running on: http://localhost:$backendPort" -ForegroundColor Cyan
Write-Host "Frontend running on: http://localhost:$frontendPort" -ForegroundColor Cyan
Write-Host "API Documentation: http://localhost:$backendPort/docs" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Green

if ($backendPort -ne 3000 -or $frontendPort -ne 8000) {
    Write-Host "NOTE: Using alternative ports due to conflicts!" -ForegroundColor Yellow
    Write-Host "Backend: $backendPort (default: 3000)" -ForegroundColor Yellow
    Write-Host "Frontend: $frontendPort (default: 8000)" -ForegroundColor Yellow
}

# Keep the main window open
Write-Host "Press any key to stop all servers..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Stop all processes (simplified - in production you'd want better process management)
Write-Host "Stopping servers..." -ForegroundColor Red
Get-Process | Where-Object {$_.ProcessName -eq "python" -or $_.ProcessName -eq "node"} | Stop-Process -Force
Write-Host "All servers stopped." -ForegroundColor Red
