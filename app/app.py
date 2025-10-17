"""
Flask API for Patient Risk Prediction
Serves ML model via REST API
"""
import os
from datetime import datetime

import joblib
import numpy as np
from flask import Flask, jsonify, render_template, request

app = Flask(__name__)

# Load model at startup
MODEL_PATH = 'model.pkl'
model = None

try:
    model = joblib.load(MODEL_PATH)
    print(f"[SUCCESS] Model loaded successfully from {MODEL_PATH}")
except Exception as e:
    print(f"[ERROR] Error loading model: {e}")

# Risk level mapping
RISK_LEVELS = {
    0: "Low",
    1: "Medium",
    2: "High"
}

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint for Kubernetes probes"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None,
        'timestamp': datetime.utcnow().isoformat() + 'Z'
    }), 200

@app.route('/predict', methods=['POST'])
def predict():
    """
    Predict patient risk level
    
    Expected JSON:
    {
        "heart_rate": 85,
        "blood_pressure": 120,
        "temperature": 98.6,
        "oxygen_level": 97
    }
    """
    try:
        # Check if model is loaded
        if model is None:
            return jsonify({
                'error': 'Model not loaded'
            }), 500
        
        # Get request data
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['heart_rate', 'blood_pressure', 'temperature', 'oxygen_level']
        missing_fields = [field for field in required_fields if field not in data]
        
        if missing_fields:
            return jsonify({
                'error': f'Missing required fields: {missing_fields}'
            }), 400
        
        # Extract features
        features = np.array([[
            float(data['heart_rate']),
            float(data['blood_pressure']),
            float(data['temperature']),
            float(data['oxygen_level'])
        ]])
        
        # Validate ranges
        hr, bp, temp, o2 = features[0]
        if not (30 <= hr <= 200):
            return jsonify({'error': 'Invalid heart_rate (must be 30-200)'}), 400
        if not (50 <= bp <= 250):
            return jsonify({'error': 'Invalid blood_pressure (must be 50-250)'}), 400
        if not (90 <= temp <= 110):
            return jsonify({'error': 'Invalid temperature (must be 90-110 F)'}), 400
        if not (70 <= o2 <= 100):
            return jsonify({'error': 'Invalid oxygen_level (must be 70-100%)'}), 400
        
        # Make prediction
        prediction = model.predict(features)[0]
        probabilities = model.predict_proba(features)[0]
        
        # Prepare response
        response = {
            'risk_level': RISK_LEVELS[prediction],
            'confidence': float(probabilities[prediction]),
            'probabilities': {
                'low': float(probabilities[0]),
                'medium': float(probabilities[1]),
                'high': float(probabilities[2])
            },
            'input': {
                'heart_rate': float(hr),
                'blood_pressure': float(bp),
                'temperature': float(temp),
                'oxygen_level': float(o2)
            },
            'timestamp': datetime.utcnow().isoformat() + 'Z'
        }
        
        return jsonify(response), 200
    
    except ValueError as e:
        return jsonify({
            'error': f'Invalid input values: {str(e)}'
        }), 400
    
    except Exception as e:
        return jsonify({
            'error': f'Prediction failed: {str(e)}'
        }), 500

@app.route('/', methods=['GET'])
def root():
    """Serve web interface"""
    return render_template('index.html')

@app.route('/api', methods=['GET'])
def api_info():
    """API info endpoint"""
    return jsonify({
        'service': 'Patient Risk Prediction API',
        'version': '1.0',
        'endpoints': {
            '/': 'GET - Web interface',
            '/health': 'GET - Health check',
            '/predict': 'POST - Predict patient risk level'
        }
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
