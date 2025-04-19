import heapq
import json
import math


def euclidean_distance(x1, y1, x2, y2):
    return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)


def get_sorted_checkpoints(x, y, graph):
    return sorted(
        graph.keys(),
        key=lambda node: euclidean_distance(
            x, y,
            graph[node]['coordinates']['x'],
            graph[node]['coordinates']['y']
        )
    )



def dijkstra_fire_safe(graph, start, destination, hazardous_nodes):
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
    with open(file_path, 'r') as f:
        return json.load(f)


def calculate_path(graph, start, destination, fireroom):
    hazardous_nodes = {fireroom}
    hazardous_nodes.update(conn['target']
                           for conn in graph[fireroom]['connections'])
    print(
        f"Hazardous nodes: {hazardous_nodes} for start : {start} and destination : {destination}")

    result = dijkstra_fire_safe(graph, start, destination, hazardous_nodes)
    return (result['distance'], result['path']) if result else (float('inf'), [])


def convert_path_to_coordinates(graph, path):
    return [[graph[node]['coordinates']['x'], graph[node]['coordinates']['y']] for node in path]


def shortest_path_from_coordinates(x, y, fireRoom):
    try:
        graph = load_graph_from_json('merged_new.json')
        checkpoints_sorted = get_sorted_checkpoints(x, y, graph)
        print("Distances from (x, y):")
        for node in checkpoints_sorted[0:5]:
            dist = euclidean_distance(
                x, y,
                graph[node]['coordinates']['x'],
                graph[node]['coordinates']['y']
            )
            print(f"  → {node}: {dist:.2f}")
        exits = ['Stairway 1', 'Stairway 2']

        for start in checkpoints_sorted[0:4]:
            if start in exits:
                print("User is already at an exit!")
                return {
                    "x": x,
                    "y": y,
                    "exit": graph[start]['coordinates'],
                    "path": [
                        [graph[start]['coordinates']['x'],
                            graph[start]['coordinates']['y']]
                    ],
                    "exitName": start
                }

            shortest_dist = float('inf')
            shortest_path = []
            chosen_exit = None

            for exit_point in exits:
                result_distance, result_path = calculate_path(
                    graph, start, exit_point, fireRoom)
                if result_path and result_distance < shortest_dist:
                    shortest_dist = result_distance
                    shortest_path = result_path
                    chosen_exit = exit_point

            if shortest_path:
                # print(
                #     f"Best exit from '{start}' is {chosen_exit} with path: {shortest_path}")
                return {
                    "x": x,
                    "y": y,
                    "exit": graph[chosen_exit]['coordinates'],
                    "path": convert_path_to_coordinates(graph, shortest_path),
                    "exitName": chosen_exit
                }

        print("No safe path to any exit found from any nearby checkpoint")
        return {
                    "x": x,
                    "y": y,
                    "exit": {},
                    "path": [],
                    "exitName": ""
                }

    except Exception as e:
        import traceback
        print(f"Error in path calculation: {e}")
        print(traceback.format_exc())
        return {"error": str(e)}


def room_to_coordinate(room):
    graph = load_graph_from_json('merged_new.json')
    if room in graph:
        coordinates = graph[room]['coordinates']
        return coordinates['x'], coordinates['y']
    else:
        raise ValueError(f"Room '{room}' not found in the graph.")


# if _name_ == "_main_":
#     x = 260
#     y = 244
#     fireRoom = 'Staff Room'

#     result = shortest_path_from_coordinates(x, y, fireRoom)
#     # print(result)

#     if "error" in result:
#         print("Error:", result["error"])
#     else:
#         print("\n✅ Path Calculation Result:")
#         print("Starting Coordinates:", (result["x"], result["y"]))
#         print("Exit Name:", result["exitName"])
#         print("Exit Coordinates:", (result["exit"]["x"], result["exit"]["y"]))
#         print("Path (with room names):")

#         graph = load_graph_from_json('merged_new.json')
#         for coord in result["path"]:
#             for name, data in graph.items():
#                 node_coords = [data['coordinates']
#                                ['x'], data['coordinates']['y']]
#                 if node_coords == coord:
#                     print(f"  → {name}: {coord}")
#                     break