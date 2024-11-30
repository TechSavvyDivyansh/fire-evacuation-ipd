from flask import Flask, request, jsonify , Response
from find_shortest_path import shortest_path_main
import cv2
import numpy as np
from flask_cors import CORS

# Initialize the Flask app
app = Flask(__name__)
CORS(app, resources={r"/": {"origins": ""}})


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

def adjust_contrast_brightness(img, clip_percent):
    assert img.shape[2] == 3, "Image must have 3 channels (BGR)."
    assert 0 < clip_percent < 100, "Percent must be in (0, 100)."
    
    clip_ratio = clip_percent / 200.0
    adjusted_channels = []

    for i in range(3):  
        channel = img[:, :, i]
        sorted_channel = np.sort(channel.ravel())

        total_pixels = sorted_channel.size
        lower_bound = sorted_channel[int(total_pixels * clip_ratio)]
        upper_bound = sorted_channel[int(total_pixels * (1 - clip_ratio))]

        channel_thresh = np.clip(channel, lower_bound, upper_bound)
        channel_adjusted = cv2.normalize(channel_thresh, None, 0, 255, cv2.NORM_MINMAX)

        adjusted_channels.append(channel_adjusted)

    return cv2.merge(adjusted_channels)

def generate_frames():
    cap = cv2.VideoCapture(0)

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break  

        enhanced_frame = adjust_contrast_brightness(frame, clip_percent=1)

        # Convert BGR to JPEG
        _, buffer = cv2.imencode('.jpg', enhanced_frame, [cv2.IMWRITE_JPEG_QUALITY, 80])
        frame_bytes = buffer.tobytes()

        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

    cap.release()

@app.route('/video_feed')
def video_feed():
    return Response(
        generate_frames(),
        mimetype='multipart/x-mixed-replace; boundary=frame'
    )




if __name__ == '__main__':
    app.run(host='192.168.1.9',port=5000,debug=True)