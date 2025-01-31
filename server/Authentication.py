import os
import jwt
import datetime
from flask import Flask, request, jsonify
from pymongo import MongoClient
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash

app = Flask(__name__)
app.config['SECRET_KEY'] = '79e026c5eaee509133e45e5004d457b0500cbbdc62c50b5f539497fdbd14e0d3'

# Connect to MongoDB
client = MongoClient(
    "mongodb+srv://LinguaAR:LinguaAR_password@cluster0.a4rwe.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")

# Specify the database name explicitly
db = client['LinguaAR_db']
users_collection = db.users


# Register Route
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    if 'email' not in data or 'password' not in data:
        return jsonify({'message': 'Email and password are required'}), 400

    # Check if user already exists
    user = users_collection.find_one({'email': data['email']})
    if user:
        return jsonify({'message': 'User already exists'}), 400

    # Hash password
    hashed_password = generate_password_hash(data['password'], method='pbkdf2:sha256')
    # Create new user
    new_user = {
        'email': data['email'],
        'password': hashed_password
    }

    users_collection.insert_one(new_user)

    return jsonify({'message': 'User registered successfully'}), 201


# Login Route
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if 'email' not in data or 'password' not in data:
        return jsonify({'message': 'Email and password are required'}), 400

    user = users_collection.find_one({'email': data['email']})
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Check password
    if not check_password_hash(user['password'], data['password']):
        return jsonify({'message': 'Invalid password'}), 400

    # Generate JWT token
    token = jwt.encode({'email': user['email'], 'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)},
                       app.config['SECRET_KEY'], algorithm='HS256')

    return jsonify({'message': 'Login successful', 'token': token}), 200


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True) 
