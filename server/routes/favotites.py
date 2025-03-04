from flask import Blueprint, request, jsonify
from pymongo import MongoClient
from bson import ObjectId

favorites_bp = Blueprint('favorites', __name__)
client = MongoClient("mongodb+srv://LinguaAR:LinguaAR_password@cluster0.a4rwe.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client['LinguaAR_db']
favorites_collection = db.favorites

@favorites_bp.route('/favorites', methods=['POST'])
def add_favorite():
    data = request.get_json()
    user_id = data.get('user_id')
    item = data.get('item')  # Phrase
    mapped_value = data.get('mapped_value')  # Mapped value

    if not user_id or not item or not mapped_value:
        return jsonify({'error': 'user_id, item, and mapped_value are required'}), 400

    existing = favorites_collection.find_one({'user_id': user_id, 'item': item})
    if existing:
        return jsonify({'message': 'Already a favorite'}), 200

    favorite = {'user_id': user_id, 'item': item, 'mapped_value': mapped_value}
    result = favorites_collection.insert_one(favorite)
    return jsonify({'message': 'Favorite added', 'id': str(result.inserted_id)}), 201

@favorites_bp.route('/favorites/<user_id>', methods=['GET'])
def get_favorites(user_id):
    favorites = list(favorites_collection.find({'user_id': user_id}))
    for fav in favorites:
        fav['_id'] = str(fav['_id'])
    return jsonify(favorites)

@favorites_bp.route('/favorites/<user_id>/<item>', methods=['DELETE'])
def remove_favorite(user_id, item):
    result = favorites_collection.delete_one({'user_id': user_id, 'item': item})
    if result.deleted_count > 0:
        return jsonify({'message': 'Favorite removed'}), 200
    return jsonify({'error': 'Favorite not found'}), 404

def create_favorites_routes(app):
    app.register_blueprint(favorites_bp, url_prefix='/favorites')
