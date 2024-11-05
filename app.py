from flask import Flask, request, jsonify
from find_shortest_path import shortest_path_main

# Initialize the Flask app
app = Flask(__name__)



@app.route("/shortestPath",methods=['POST'])
def shortest_safest_path():
    data = request.get_json()
    current_location=data['current_location']
    # print(current_location)
    shortest_dist,shortest_path=shortest_path_main(current_location)
    if(shortest_dist==1000000):
        return jsonify({
        "message":"Please dont panic fighters are coming to save you"
    })
    
    return jsonify({
        "shortest_dist":shortest_dist,
        "shortest_path":shortest_path
    })


if __name__ == '__main__':
    app.run()