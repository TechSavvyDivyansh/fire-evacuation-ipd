import random
import time

def randomFireGenerator():
    TEMP_THRESHOLD = 45.0  # Temperature threshold for hazards
    CO2_THRESHOLD = 1500.0


    # Extract all room names (top-level keys)
    rooms = ['L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'Staff Lounge', 'Store Room', 'WashRoom','61', '62', '63', 'Staff Room', 'HOD Cabin']
   

    while True:
        for room in rooms:
            temp = random.uniform(25, 60)  # float between 25 and 60
            co2 = random.randint(1400, 1600)
            smoke = random.choice([True, False])

            print(f"[{room}] Temp: {temp:.2f}°C, CO2: {co2} ppm, Smoke: {smoke}")

            if temp > 45 and co2 > 1500 and smoke:
                print(f"\n🔥 Fire detected in {room}!")
                return "L3"

            time.sleep(1)  # Optional: slow down loop for realism
