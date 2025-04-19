import eventlet
eventlet.monkey_patch()
import os
from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
from flask_cors import CORS
from new_shortest_path import  load_graph_from_json, shortest_path_from_coordinates,room_to_coordinate
from FireGenerate import randomFireGenerator

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
socketio = SocketIO(app, cors_allowed_origins="*", async_mode='eventlet')

fireroom=''

@app.route('/')
def index():
    print("Entered")
    return 'Simplified Server is running'

@app.route('/calculate-path', methods=['POST'])
def calculate_path_api():
    try:
        print("📥 Received path request")
        data = request.get_json()
        x, y = data['x'], data['y']

        if(fireroom!=""):
            result = shortest_path_from_coordinates(x, y,fireroom)

            print(f'myresult : {result}')
            return jsonify(result)
        else:
            return jsonify({
                    "x": x,
                    "y": y,
                    "exit": {},
                    "path": [],
                    "exitName": ""
                })
    
    except Exception as e:
        import traceback
        print(f"❌ Error: {e}")
        print(traceback.format_exc())
        return jsonify({'error': str(e)}), 500


@app.route('/get-fire')
def get_fire_api():
    global fireroom
    fireroom=""
    fireroom = randomFireGenerator()
    firepoints=room_to_coordinate(fireroom)
    return jsonify(firepoints)


# def calculate_path_internal(x, y):
    # print(f"🔍 Calculating path for ({x}, {y})")
    # graph = load_graph_from_json('merged_new.json')
    # start = get_nearest_checkpoint(x, y, graph)
    # print(f"✅ Nearest checkpoint: {start}")
    # return shortest_path_from_coordinates(x, y)

# --- WebSocket Events ---
@socketio.on('connect')
def handle_connect():
    print("✅ Client connected")

@socketio.on('disconnect')
def handle_disconnect():
    print("❌ Client disconnected")

@socketio.on('personMoved')
def handle_person_moved(data):
    print(f"📡 Received personMoved: {data}")
    emit('personMoved', data, broadcast=True)  # Emit to all clients including sender

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))  # default to 5000 locally
    socketio.run(app, host='0.0.0.0', port=port)