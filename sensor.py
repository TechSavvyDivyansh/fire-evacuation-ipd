import random
import datetime
import time
import firebase_admin
from firebase_admin import credentials, firestore

# Firebase setup
# Replace 'path_to_firebase_key.json' with the path to your Firebase key JSON file
cred = credentials.Certificate("./firebase_key.json")  # e.g., 'firebase_key.json'
firebase_admin.initialize_app(cred)
db = firestore.client()

# List of sensors placed in key locations on the floor
sensors = [
    'Lecture1 L', 'Lecture1 R', 'Lecture2 L', 'Lecture2 R', 'Lecture3 L',
    'Lecture4 R', 'Corridor/Circulation', 'Faculty Office1', 'Department Lab1',
    'Lecture5', 'Self Instruction Lab', 'Stairway1', 'Stairway2', 'Stairway3'
]

simulation_running = False

def generate_sensor_data():
    """Generate random sensor data with temperature, smoke, and CO2 level readings."""
    data = []
    for sensor in sensors:
        temp = round(random.uniform(20, 50), 1)  # Simulating fire with higher temp
        smoke = random.choice([True, False])
        co2 = round(random.uniform(400, 2000), 1)  # Higher CO2 indicates fire presence
        data.append({
            'sensor_id': sensor,
            'temperature': temp,
            'smoke': smoke,
            'co2_level': co2,
            'timestamp': datetime.datetime.now()
        })
    return data

def start_simulation():
    """Start the sensor simulation."""
    global simulation_running
    simulation_running = True
    sensor_data = generate_sensor_data()
    for data in sensor_data:
        db.collection('sensor_readings').add(data)  # Upload each reading to Firestore
    c=0
    while simulation_running:
        while c!=0:
            c=c+1 

def stop_simulation():
    """Stop the sensor simulation."""
    global simulation_running
    simulation_running = False

# To start the simulation: 
# start_simulation()
# To stop the simulation: 
# stop_simulation()