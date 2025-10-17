"""
Train Patient Risk Prediction Model
Generates synthetic patient data and trains a classifier
"""
import joblib
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split

# Generate synthetic patient data
np.random.seed(42)
n_samples = 1000

# Features: heart_rate, blood_pressure, temperature, oxygen_level
heart_rate = np.random.normal(75, 15, n_samples)  # Normal: 60-100 bpm
blood_pressure = np.random.normal(120, 20, n_samples)  # Normal: 90-140 mmHg
temperature = np.random.normal(98.6, 1.5, n_samples)  # Normal: 97-99.5 F
oxygen_level = np.random.normal(97, 3, n_samples)  # Normal: 95-100 %

# Combine features
X = np.column_stack([heart_rate, blood_pressure, temperature, oxygen_level])

# Generate risk levels based on realistic rules
def calculate_risk(hr, bp, temp, o2):
    """Calculate risk level based on vital signs"""
    risk_score = 0
    
    # Heart rate risk
    if hr > 100 or hr < 60:
        risk_score += 1
    if hr > 120 or hr < 50:
        risk_score += 1
    
    # Blood pressure risk
    if bp > 140 or bp < 90:
        risk_score += 1
    if bp > 160 or bp < 80:
        risk_score += 1
    
    # Temperature risk
    if temp > 100 or temp < 97:
        risk_score += 1
    if temp > 102 or temp < 96:
        risk_score += 1
    
    # Oxygen level risk
    if o2 < 95:
        risk_score += 1
    if o2 < 90:
        risk_score += 2
    
    # Classify risk
    if risk_score >= 4:
        return 2  # High risk
    elif risk_score >= 2:
        return 1  # Medium risk
    else:
        return 0  # Low risk

# Generate labels
y = np.array([calculate_risk(hr, bp, temp, o2) 
              for hr, bp, temp, o2 in X])

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Train model
print("Training Patient Risk Prediction Model...")
model = LogisticRegression(max_iter=1000, random_state=42)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f"\n[SUCCESS] Model Training Complete!")
print(f"Accuracy: {accuracy:.2%}")
print(f"\nClassification Report:")
print(classification_report(y_test, y_pred, 
                          target_names=['Low Risk', 'Medium Risk', 'High Risk']))

# Save model
joblib.dump(model, 'model.pkl')
print(f"\nModel saved as 'model.pkl'")

# Print sample predictions
print(f"\nSample Predictions:")
sample_patients = [
    [75, 120, 98.6, 98],   # Normal patient
    [110, 150, 100.5, 92], # Medium risk
    [130, 170, 103, 88]    # High risk
]

risk_labels = ['Low Risk', 'Medium Risk', 'High Risk']
for i, patient in enumerate(sample_patients, 1):
    pred = model.predict([patient])[0]
    prob = model.predict_proba([patient])[0]
    print(f"Patient {i}: {patient} -> {risk_labels[pred]} (confidence: {prob[pred]:.2%})")
