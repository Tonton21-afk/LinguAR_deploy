from flask import Flask
from routes.gesture_routes import create_gesture_routes
from routes.touch import create_touch_routes



def create_app():
    app = Flask(__name__)


    # Register routes
    create_gesture_routes(app)
    create_touch_routes(app)




    return app

app = create_app()
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)