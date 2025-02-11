from flask import request, jsonify

def create_speech_recognition_routes(app):
    @app.route('/recognize', methods=['POST'])
    def recognize_voice():
        # Extract voice data from the request
        data = request.get_json()
        voice_data = data.get('voice_data', '').lower()

        # Simple logic: If the user says anything, return recognized=True
        if voice_data:
            return jsonify({'recognized': True, 'message': 'Voice recognized successfully!'})
        else:
            return jsonify({'recognized': False, 'message': 'No voice data received.'})