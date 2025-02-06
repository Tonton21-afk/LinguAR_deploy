from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from pymongo import MongoClient
import jwt
import datetime

# Blueprint definition
auth_bp = Blueprint('auth', __name__)

# Connect to MongoDB
client = MongoClient("mongodb+srv://LinguaAR:LinguaAR_password@cluster0.a4rwe.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client['LinguaAR_db']
users_collection = db.users

# Register Route
@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    if users_collection.find_one({'email': email}):
        return jsonify({'message': 'User already exists'}), 400

    hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
    users_collection.insert_one({'email': email, 'password': hashed_password})
    return jsonify({'message': 'User registered successfully'}), 201

# Login Route
@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    user = users_collection.find_one({'email': email})
    if not user or not check_password_hash(user['password'], password):
        return jsonify({'message': 'Invalid email or password'}), 400

    token = jwt.encode({'email': email, 'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)},
                       '79e026c5eaee509133e45e5004d457b0500cbbdc62c50b5f539497fdbd14e0d3', algorithm='HS256')
    return jsonify({'message': 'Login successful', 'token': token}), 200

# Function to register routes with the app
def create_auth_routes(app):
    app.register_blueprint(auth_bp, url_prefix='/auth')