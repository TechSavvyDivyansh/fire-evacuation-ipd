import heapq
import json
import math 

def euclidean_distance(x1, y1, x2, y2):
    return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

def get_nearest_checkpoint(x, y, graph):
    """Find the nearest node in the graph to the given (x, y) coordinate."""
    return min(
        graph.keys(),
        key=lambda node: euclidean_distance(
            x, y, 
            graph[node]['coordinates']['x'], 
            graph[node]['coordinates']['y']
        )
    )


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
            
        for connection in graph[current_node]['connections']:
            neighbor = connection['target']
            weight = connection['distance']

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


def calculate_path(graph, start, destination):
    """Calculate the safest path avoiding hardcoded hazardous nodes."""
    # Hardcoded hazardous node
    hazardous_nodes = {'63'}
    # print(f"Using hardcoded hazardous nodes: {hazardous_nodes}")

    result = dijkstra_fire_safe(graph, start, destination, hazardous_nodes)
    if result:
        # print("Safe path to exit:", result['path'])
        return result['distance'], result['path']
    else:
        print("No safe path found.")
        return float('inf'), []


def convert_path_to_coordinates(graph, path):
    return [
        [graph[node]['coordinates']['x'], graph[node]['coordinates']['y']]
        for node in path
    ]


def shortest_path_from_coordinates(x, y):
    try:
        # print("Loading graph...")
        graph = load_graph_from_json('merged_new.json')
        # print("Finding nearest checkpoint...")
        start = get_nearest_checkpoint(x, y, graph)
        # print(f"Nearest start point: {start}")
        
        exits = ['Stairway 1', 'Stairway 2']
        
        # Check if we're already at an exit
        if start in exits:
            print("User is already at an exit!")
            return {
                "x": x,
                "y": y,
                "exit": {
                    "x": graph[start]['coordinates']['x'],
                    "y": graph[start]['coordinates']['y']
                },
                "path": [[graph[start]['coordinates']['x'], graph[start]['coordinates']['y']]],
                "exitName": start
            }
        
        shortest_dist = float('inf')
        shortest_path = []
        chosen_exit = None

        # print("Calculating paths to exits...")
        for exit_point in exits:
            # print(f"Calculating path to {exit_point}...")
            result_distance, result_path = calculate_path(graph, start, exit_point)
            if result_distance < shortest_dist:
                shortest_dist = result_distance
                shortest_path = result_path
                chosen_exit = exit_point  

        if not shortest_path:
            print("No safe path to any exit found")
            return {"error": "No safe path to any exit."}

        print(f"Best exit is {chosen_exit} with path: {shortest_path}")
        
        result = {
            "x": x,
            "y": y,
            "exit": {
                "x": graph[chosen_exit]['coordinates']['x'],
                "y": graph[chosen_exit]['coordinates']['y']
            },
            "path": convert_path_to_coordinates(graph, shortest_path),
            "exitName": chosen_exit
        }
        
        # print("Path calculation completed successfully")
        return result
        
    except Exception as e:
        import traceback
        print(f"Error in path calculation: {e}")
        print(traceback.format_exc())
        return {"error": str(e)}
    
# shortest_path_from_coordinates(300,300)