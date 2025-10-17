# 🏥 Patient Risk Predictor - MLOps Pipeline

A complete MLOps demonstration project showcasing machine learning model deployment with Kubernetes auto-scaling, Docker containerization, and production-ready Flask API.

## 🎯 Project Overview

This project demonstrates a **HealthTech startup** scenario where we predict patient risk levels (Low/Medium/High) based on medical vitals using machine learning, deployed on Kubernetes with automatic scaling capabilities.

### Key Features
- 🤖 **ML Model**: Logistic Regression for patient risk prediction
- 🐳 **Docker**: Containerized Flask application
- ☸️ **Kubernetes**: Production deployment with auto-scaling
- 📊 **HPA**: Horizontal Pod Autoscaler based on CPU usage
- 🌐 **Web UI**: Interactive testing interface
- 📈 **Monitoring**: Real-time scaling demonstrations

## 🏗️ Architecture

```
[Patient Data] → [Flask API] → [ML Model] → [Prediction]
       ↓
[Docker Container] → [Kubernetes Pod] → [Auto-Scaling]
       ↓
[HPA monitors CPU] → [Scales 2→5 pods] → [Load Balancing]
```

## 📁 Project Structure

```
mlops-patient-risk/
├── app/                          # Application code
│   ├── train_model.py           # ML model training
│   ├── app.py                   # Flask API server
│   ├── requirements.txt         # Python dependencies
│   ├── model.pkl               # Trained model (generated)
│   └── templates/
│       └── index.html           # Web UI
├── k8s/                         # Kubernetes manifests
│   ├── deployment.yaml          # Pod deployment
│   ├── service.yaml             # Service exposure
│   └── hpa.yaml                 # Auto-scaling configuration
├── scripts/                     # Demo and testing scripts
│   ├── complete_demo.ps1        # Full MLOps demonstration
│   ├── manual_scaling_demo.ps1  # Manual scaling demo
│   ├── load_test_demo.ps1       # Load testing demo
│   └── monitor_scaling.ps1      # Monitoring options
├── docs/                        # Documentation
│   └── APPROACH.md              # Technical approach
├── examples/                    # Example configurations
├── Dockerfile                   # Container definition
├── README.md                    # This file
└── .gitignore                   # Git ignore rules
```

## 🚀 Quick Start

### Prerequisites
- Docker Desktop
- Kubernetes (Minikube recommended)
- kubectl
- Python 3.9+

### 1. Setup Environment
```bash
# Start Minikube
minikube start

# Enable metrics-server for HPA
minikube addons enable metrics-server
```

### 2. Train the Model
```bash
cd app
python train_model.py
```

### 3. Build and Deploy
```bash
# Build Docker image
docker build -t health-predictor:v1 .

# Load into Minikube
minikube image load health-predictor:v1

# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

### 4. Access Application
```bash
# Port forward to access locally
kubectl port-forward svc/health-predictor 8080:80

# Open browser: http://localhost:8080
```

## 🎬 Demo Instructions

### Complete MLOps Demonstration
```powershell
# Run the complete demo
.\scripts\complete_demo.ps1
```

### Manual Scaling Demo
```powershell
# Demonstrate Kubernetes scaling
.\scripts\manual_scaling_demo.ps1
```

### Load Testing Demo
```powershell
# Test auto-scaling with load
.\scripts\load_test_demo.ps1
```

### Monitoring
```powershell
# Watch scaling in real-time
.\scripts\monitor_scaling.ps1
```

## 🔧 Technical Details

### ML Model
- **Algorithm**: Logistic Regression
- **Features**: Heart Rate, Blood Pressure, Temperature, Oxygen Level
- **Output**: Risk Level (Low/Medium/High) + Confidence Score
- **Training Data**: 1000 synthetic patient records

### Kubernetes Configuration
- **Min Pods**: 2 (always running)
- **Max Pods**: 5 (scaling limit)
- **CPU Threshold**: 70% (scaling trigger)
- **Resource Requests**: 128Mi memory, 100m CPU
- **Resource Limits**: 256Mi memory, 200m CPU

### Auto-Scaling Logic
```
IF (CPU Usage > 70%) THEN
    Scale UP (add pods)
ELSE IF (CPU Usage < 70% for 5 minutes) THEN
    Scale DOWN (remove pods)
```

## 📊 Monitoring

### Watch HPA Scaling
```bash
kubectl get hpa -w
```

### Watch Pod Creation
```bash
kubectl get pods -l app=health-predictor -w
```

### Check CPU Usage
```bash
kubectl top pods -l app=health-predictor
```

## 🧪 Testing

### Web Interface Testing
1. Open http://localhost:8080
2. Fill in patient vitals
3. Click "Predict Risk Level"
4. Test different scenarios

### Load Testing
1. Scroll to "Kubernetes Scaling Demo"
2. Click "Peak Load (100 users)"
3. Watch pods scale automatically
4. Monitor HPA metrics

### API Testing
```bash
# Health check
curl http://localhost:8080/health

# Prediction
curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{
    "heart_rate": 85,
    "blood_pressure": 120,
    "temperature": 98.6,
    "oxygen_level": 97
  }'
```

## 🛠️ Development

### Local Development
```bash
# Install dependencies
pip install -r app/requirements.txt

# Run locally
cd app
python app.py
```

### Docker Development
```bash
# Build image
docker build -t health-predictor:dev .

# Run container
docker run -p 5000:5000 health-predictor:dev
```

## 📚 Documentation

- [Technical Approach](docs/APPROACH.md) - Detailed technical implementation
- [Testing Guide](TESTING-GUIDE.md) - Comprehensive testing instructions
- [Scaling Demo Guide](SCALING_DEMO_GUIDE.md) - Auto-scaling demonstration

## 🎯 Learning Objectives

This project demonstrates:
- **MLOps Pipeline**: End-to-end machine learning deployment
- **Containerization**: Docker best practices
- **Orchestration**: Kubernetes deployment and management
- **Auto-scaling**: HPA configuration and monitoring
- **Production Readiness**: Health checks, resource limits, security
- **Monitoring**: Real-time scaling and performance metrics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Kubernetes community for excellent documentation
- Flask team for the web framework
- scikit-learn for machine learning capabilities
- Docker for containerization platform

---

**Ready to demonstrate MLOps in action!** 🚀