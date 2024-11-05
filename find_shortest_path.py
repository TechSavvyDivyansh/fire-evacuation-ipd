import firebase_admin
from firebase_admin import credentials, firestore
import heapq
import datetime
import time
import json

# Firebase setup
cred = credentials.Certificate("firebase_key.json")  # Replace with your downloaded Firebase service account key
firebase_admin.initialize_app(cred)
db = firestore.client()

# Thresholds for detecting hazardous conditions
TEMP_THRESHOLD = 45.0  # Temperature threshold for hazards
CO2_THRESHOLD = 1500.0  # CO2 level threshold

def fetch_hazardous_nodes():
    """Fetch recent hazardous nodes from Firestore based on sensor data."""
    hazardous_nodes = set()
    query = db.collection('sensor_readings').stream()

    for doc in query:
        data = doc.to_dict()
        if data['temperature'] > TEMP_THRESHOLD and data['smoke'] and data['co2_level'] > CO2_THRESHOLD:
            print(data)
            hazardous_nodes.add(data['sensor_id'])
    return hazardous_nodes

def dijkstra_fire_safe(graph, start, destination, hazardous_nodes):
    """Implement Dijkstra's algorithm to find a safe path avoiding hazardous areas."""
    queue = []
    distances = {node: float('inf') for node in graph}
    previous_nodes = {node: None for node in graph}
    distances[start] = 0
    heapq.heappush(queue, (0, start))

    while queue:
        current_distance, current_node = heapq.heappop(queue)
        if current_node in hazardous_nodes:
            continue

        for neighbor, weight in graph[current_node]:
            if neighbor in hazardous_nodes:
                continue
            distance = current_distance + weight
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous_nodes[neighbor] = current_node
                heapq.heappush(queue, (distance, neighbor))

    path = []
    current = destination
    while current:
        path.append(current)
        current = previous_nodes[current]
    path.reverse()

    return {"distance": distances[destination], "path": path} if distances[destination] != float('inf') else None

def load_graph_from_json(file_path):
    """Load the graph structure from a JSON file."""
    with open(file_path, 'r') as f:
        return json.load(f)

def monitor_and_update_path(graph, start, destination, interval=10):
    """Continuously monitor hazardous nodes and update the safe path."""
    # while True:
    hazardous_nodes = fetch_hazardous_nodes()
    print(f"Hazardous nodes detected: {hazardous_nodes}")
    

    result = dijkstra_fire_safe(graph, start, destination, hazardous_nodes)
    if result:
        print("Safe path to exit:", result['path'])
        result_path=result['path']
        print("Distance:", result['distance'])
        result_distance=result['distance']
    else:
        print("No safe path found.")
        result_distance=100000
        result_path=[]
    return result_distance,result_path


# Load the graph from JSON file
graph = load_graph_from_json('graph.json')  # Replace with your graph JSON file path

# Start monitoring and updating path dynamically

exits=['Stairway1','Stairway2','Stairway3']
distance=[]
path=[]
for exit in exits:
    result_distance,result_path=monitor_and_update_path(graph, "Men's Restroom", exit, interval=10)
    distance.append(result_distance)
    path.append(result_path)
shortest_dist=min(distance)
print(shortest_dist)
print(path[distance.index(shortest_dist)])
