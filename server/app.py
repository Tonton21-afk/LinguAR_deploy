from flask import Flask
from routes.auth_routes import create_auth_routes
from routes.gesture_routes import create_gesture_routes

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = '79e026c5eaee509133e45e5004d457b0500cbbdc62c50b5f539497fdbd14e0d3'

    # Register routes
    create_auth_routes(app)
    create_gesture_routes(app)

    return app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)