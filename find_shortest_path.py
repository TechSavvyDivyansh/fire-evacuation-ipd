# # find_shortest_path.py

# import json
# import heapq

# def load_combined_graph(file_path):
#     """Load the combined graph from a JSON file."""
#     with open(file_path, 'r') as file:
#         return json.load(file)

# def dijkstra(graph, start, destination):
#     """Implement Dijkstra's algorithm to find shortest paths and return the path taken."""
#     queue = []
#     distances = {node: float('inf') for node in graph}
#     previous_nodes = {node: None for node in graph}  # Track the path
#     distances[start] = 0
#     heapq.heappush(queue, (0, start))

#     while queue:
#         current_distance, current_node = heapq.heappop(queue)
#         if current_distance > distances[current_node]:
#             continue

#         for neighbor, weight in graph[current_node]:
#             distance = current_distance + weight
#             if distance < distances[neighbor]:
#                 distances[neighbor] = distance
#                 previous_nodes[neighbor] = current_node
#                 heapq.heappush(queue, (distance, neighbor))

#     path = []
#     current = destination
#     while current is not None:
#         path.append(current)
#         current = previous_nodes[current]
#     path.reverse()

#     if distances[destination] == float('inf'):
#         return None

#     return {
#         "distance": distances[destination],
#         "path": path
#     }

# def find_nearest_exit(graph, current_location, exit_rooms):
#     """Find the nearest exit room from the current location."""
#     shortest_path = None
#     shortest_distance = float('inf')

#     for exit_room in exit_rooms:
#         if exit_room in graph:
#             result = dijkstra(graph, current_location, exit_room)
#             if result and result['distance'] < shortest_distance:
#                 shortest_distance = result['distance']
#                 shortest_path = result['path']

#     return shortest_path, shortest_distance

# # Example usage
# combined_graph = load_combined_graph('combined_graph.json')
# current_location = 'Administration 0010 Floor1'
# exit_rooms = [
#     "Bldg.1, Room S102^M^J128300-FacMgmt-Custodial Services^M^JFICM: Stairway^M^JASF:",  # Example exit room
# ]

# nearest_exit_path, nearest_exit_distance = find_nearest_exit(combined_graph, current_location, exit_rooms)

# if nearest_exit_path:
#     print(f"Shortest distance to nearest exit: {nearest_exit_distance}")
#     print(f"Path to nearest exit: {' -> '.join(nearest_exit_path)}")
# else:
#     print(f"No exits reachable from {current_location}.")
# dynamic_pathfinder.py
# pip install firebase_admin

import firebase_admin
from firebase_admin import credentials, firestore
import heapq
import datetime
import time
import json

# Firebase setup
cred = credentials.Certificate("path_to_firebase_key.json")  # Replace with your downloaded Firebase service account key
firebase_admin.initialize_app(cred)
db = firestore.client()

# Thresholds for detecting hazardous conditions
TEMP_THRESHOLD = 45.0  # Temperature threshold for hazards
CO2_THRESHOLD = 1500.0  # CO2 level threshold

def fetch_hazardous_nodes():
    """Fetch recent hazardous nodes from Firestore based on sensor data."""
    hazardous_nodes = set()
    query = db.collection('sensor_readings').where(
        'timestamp', '>', datetime.datetime.now() - datetime.timedelta(seconds=10)
    ).stream()

    for doc in query:
        data = doc.to_dict()
        if data['temperature'] > TEMP_THRESHOLD or data['smoke'] or data['co2_level'] > CO2_THRESHOLD:
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
    while True:
        hazardous_nodes = fetch_hazardous_nodes()
        print(f"Hazardous nodes detected: {hazardous_nodes}")

        result = dijkstra_fire_safe(graph, start, destination, hazardous_nodes)
        if result:
            print("Safe path to exit:", result['path'])
            print("Distance:", result['distance'])
        else:
            print("No safe path found.")

        time.sleep(interval)

# Load the graph from JSON file
graph = load_graph_from_json('path_to_graph.json')  # Replace with your graph JSON file path

# Start monitoring and updating path dynamically
monitor_and_update_path(graph, 'Lecture1 L', 'Exit', interval=10)
