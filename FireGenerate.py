import random
import time
import json 

def randomFireGenerator():
    TEMP_THRESHOLD = 45.0  # Temperature threshold for hazards
    CO2_THRESHOLD = 1500.0

    with open('merged_new.json', 'r') as f:
        data = json.load(f)

    # Extract all room names (top-level keys)
    rooms = list(data.keys())

    while True:
        for room in rooms:
            temp = random.uniform(25, 60)  # float between 25 and 60
            co2 = random.randint(1400, 1600)
            smoke = random.choice([True, False])

            print(f"[{room}] Temp: {temp:.2f}°C, CO2: {co2} ppm, Smoke: {smoke}")

            if temp > 45 and co2 > 1500 and smoke:
                print(f"\n🔥 Fire detected in {room}!")
                return room

            time.sleep(1)  # Optional: slow down loop for realism

