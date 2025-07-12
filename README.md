# Zerodha Kite API Project

A comprehensive FastAPI backend with React TypeScript frontend for Zerodha Kite Connect API integration.

## 🚀 Features

### Backend (FastAPI)
- Complete Kite Connect API integration
- Authentication with login/logout endpoints
- Holdings API with real-time portfolio data
- Historical data download with file management
- Instruments search and caching
- Swagger documentation
- Database models for user sessions and data storage
- CORS configuration for frontend integration

### Frontend (React + TypeScript)
- Beautiful login interface similar to Kite Zerodha
- Responsive dashboard with navigation
- Holdings page with portfolio summary and detailed table
- Historical data download interface with file management
- Material-UI components with modern design
- Authentication context and protected routes
- Real-time data display

## 📁 Project Structure

```
Zerodha_API/
├── backend/                 # FastAPI backend
│   ├── routers/            # API route handlers
│   ├── services/           # Business logic services
│   ├── models/             # Database models
│   ├── schemas/            # Pydantic schemas
│   ├── requirements.txt    # Python dependencies
│   ├── .env               # Environment variables
│   └── main.py            # FastAPI application
├── frontend/               # React TypeScript frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   ├── contexts/      # React contexts
│   │   └── App.tsx        # Main application
│   ├── package.json       # Node.js dependencies
│   └── public/            # Static assets
├── keys.txt               # API credentials
├── tasks.md              # Implementation checklist
├── requirement.md        # Project requirements
├── start.ps1             # Windows startup script
├── start.sh              # Linux/Mac startup script
└── README.md             # Project documentation
```

## 🛠️ Installation & Setup

### Prerequisites
- Python 3.8+
- Node.js 16+
- npm or yarn

### Quick Start

#### Windows (PowerShell)
```powershell
.\start.ps1
```

#### Linux/Mac (Bash)
```bash
chmod +x start.sh
./start.sh
```

#### Manual Setup

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python init_db.py
python main.py
```

**Frontend:**
```bash
cd frontend
npm install
npm start
```

## 🌐 Access URLs

- **Frontend Application:** <http://localhost:8000>
- **Backend API:** <http://localhost:3000>
- **API Documentation:** <http://localhost:3000/docs>
- **Alternative API Docs:** <http://localhost:3000/redoc>

> **Note:** The frontend runs on port 8000 and the backend runs on port 3000 (opposite of typical configurations).

## 🔑 Configuration

### Environment Variables (.env)
```env
API_KEY=your_kite_api_key
API_SECRET=your_kite_api_secret
SECRET_KEY=your_jwt_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
DATABASE_URL=sqlite:///./zerodha_app.db
```

### API Keys
Update the `backend/.env` file with your Kite Connect API credentials:
- Get API keys from Zerodha Kite Connect developer console
- Replace the placeholder values in the `.env` file

## 📖 API Documentation

### Authentication Endpoints
- `GET /api/auth/login-url` - Get Kite login URL
- `POST /api/auth/login` - Complete login with request token
- `POST /api/auth/logout` - Logout and invalidate session
- `GET /api/auth/profile` - Get user profile
- `GET /api/auth/margins` - Get user margins

### Data Endpoints
- `GET /api/holdings/` - Get user holdings
- `GET /api/holdings/positions` - Get user positions
- `GET /api/instruments/` - Get instruments list
- `GET /api/instruments/search` - Search instruments
- `POST /api/historical/download` - Download historical data
- `GET /api/historical/saved-data` - List saved data files

## 🎨 UI Features

### Login Page
- Automated Kite Connect authentication flow
- Clean, modern interface similar to Zerodha Kite
- Support for both automatic and manual token entry

### Dashboard
- Welcome screen with account information
- Navigation to different sections
- Quick access to key features

### Holdings Page
- Portfolio summary with total value and P&L
- Detailed holdings table with real-time data
- Color-coded profit/loss indicators
- Responsive design for all devices

### Historical Data Page
- Date range selection for data download
- Multiple timeframe support (1min to daily)
- File management interface
- Download and preview capabilities

## 🚧 Development Status

### Completed ✅
- FastAPI backend with Kite Connect integration
- React TypeScript frontend with Material-UI
- Authentication flow and protected routes
- Holdings display with real-time data
- Historical data download functionality
- Database models and API documentation
- Cross-platform startup scripts

### In Progress 🚧
- Chart visualization (TradingView-like interface)
- Bulk data download interface
- Real-time WebSocket data streaming

### Planned 📋
- Order placement interface
- Advanced technical analysis tools
- Portfolio analytics and reporting
- Multi-timeframe chart analysis
- Options chain display
- Market depth and order book

## 🐛 Troubleshooting

### Common Issues

1. **Port Already in Use**
   - The startup scripts now automatically detect and stop processes on ports 3000 and 8000
   - If ports are still unavailable, the scripts will use alternative ports (3001, 8001)
   - The scripts will display which ports are being used

2. **API Authentication Errors**
   - Verify your Kite Connect API credentials
   - Ensure the API key and secret are correctly set in `.env`
   - Check if your Kite Connect app is properly configured

3. **Database Issues**
   - Run `python init_db.py` to initialize database tables
   - Delete `zerodha_app.db` and reinitialize if corrupted

4. **Frontend Build Errors**
   - Clear npm cache: `npm cache clean --force`
   - Delete `node_modules` and run `npm install` again

## 📄 License

This project is for educational and personal use. Please ensure compliance with Zerodha's terms of service and API usage guidelines.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review the API documentation at `/docs`
3. Ensure all dependencies are properly installed
4. Verify your Kite Connect API credentials

---

**Note:** This application requires valid Zerodha Kite Connect API credentials. Please ensure you have proper authorization before using this software for live trading.
