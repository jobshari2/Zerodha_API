#!/bin/bash

# Zerodha API Project Startup Script (Bash version)
echo "Starting Zerodha API Project..."
echo "====================================="

# Function to stop processes on a specific port
stop_processes_on_port() {
    local port=$1
    echo "Checking port $port..."
    
    # Method 1: Using lsof
    local pids=$(lsof -ti:$port 2>/dev/null)
    
    if [ ! -z "$pids" ]; then
        echo "Found processes on port $port: $pids"
        echo "Stopping processes on port $port..."
        
        # First try SIGTERM (graceful shutdown)
        echo "$pids" | xargs kill -TERM 2>/dev/null
        sleep 3
        
        # Check if any processes are still running
        local remaining_pids=$(lsof -ti:$port 2>/dev/null)
        
        if [ ! -z "$remaining_pids" ]; then
            echo "Some processes still running, using SIGKILL..."
            echo "$remaining_pids" | xargs kill -9 2>/dev/null
            sleep 2
        fi
        
        echo "Stopped processes on port $port"
    else
        echo "No processes found on port $port"
    fi
    
    # Method 2: Using netstat as backup (for systems without lsof)
    if ! command -v lsof &> /dev/null; then
        echo "lsof not available, trying netstat..."
        local netstat_pids=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | grep -v '-')
        
        if [ ! -z "$netstat_pids" ]; then
            echo "Found processes via netstat: $netstat_pids"
            echo "$netstat_pids" | xargs kill -9 2>/dev/null
            sleep 2
        fi
    fi
    
    # Verify port is now free
    if lsof -i:$port &> /dev/null; then
        echo "Warning: Port $port may still be in use"
    else
        echo "Port $port is now free"
    fi
}

# Stop any processes on ports 3000 and 8000
echo "Checking and stopping processes on ports 3000 and 8000..."
stop_processes_on_port 3000
stop_processes_on_port 8000

# Alternative port strategy if main ports are unavailable
backend_port=3000
frontend_port=8000

# Check if we need alternative ports
if lsof -i:3000 &> /dev/null; then
    echo "Port 3000 still unavailable, trying alternative port 3001..."
    backend_port=3001
fi

if lsof -i:8000 &> /dev/null; then
    echo "Port 8000 still unavailable, trying alternative port 8001..."
    frontend_port=8001
fi

# Start Backend
echo "Starting Backend (FastAPI) on port $backend_port..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python init_db.py
python main.py --port $backend_port &
BACKEND_PID=$!
cd ..

# Wait a bit for backend to start
sleep 5

# Update frontend .env file with correct backend port
cat > frontend/.env << EOF
PORT=$frontend_port
REACT_APP_API_BASE_URL=http://localhost:$backend_port
EOF

# Start Frontend
echo "Starting Frontend (React) on port $frontend_port..."
cd frontend
npm install
npm start &
FRONTEND_PID=$!
cd ..

echo "====================================="
echo "Backend running on: http://localhost:$backend_port"
echo "Frontend running on: http://localhost:$frontend_port"
echo "API Documentation: http://localhost:$backend_port/docs"
echo "====================================="

if [ $backend_port -ne 3000 ] || [ $frontend_port -ne 8000 ]; then
    echo "NOTE: Using alternative ports due to conflicts!"
    echo "Backend: $backend_port (default: 3000)"
    echo "Frontend: $frontend_port (default: 8000)"
fi

# Function to cleanup processes
cleanup() {
    echo "Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo "All servers stopped."
    exit 0
}

# Trap signals to cleanup
trap cleanup SIGINT SIGTERM

# Keep script running
echo "Press Ctrl+C to stop all servers..."
wait
