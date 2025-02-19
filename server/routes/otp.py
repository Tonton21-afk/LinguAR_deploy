from flask import Blueprint, request, jsonify
import random
import smtplib
from email.mime.text import MIMEText

# Blueprint definition
otp_routes = Blueprint('otp_routes', __name__)

# Shared OTP storage
otp_storage = {}

def generate_otp():
    return str(random.randint(100000, 999999))

def send_otp(email, otp):
    sender_email = "LinguaAR01@gmail.com"  
    sender_password = "mywq drvg lzwh ctlj" 
    
    message = MIMEText(f"Your OTP is: {otp}")
    message['Subject'] = 'Your OTP for Password Reset'
    message['From'] = sender_email
    message['To'] = email
    
    try:
        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, [email], message.as_string())
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False

@otp_routes.route('/send-otp', methods=['POST'])
def send_otp_route():
    data = request.json
    email = data.get('email')
    
    if not email:
        return jsonify({"success": False, "message": "Email is required"}), 400
    
    otp = generate_otp()
    otp_storage[email] = otp
    
    if send_otp(email, otp):
        return jsonify({"success": True, "message": "OTP sent successfully"})
    else:
        return jsonify({"success": False, "message": "Failed to send OTP"}), 500

@otp_routes.route('/verify-otp', methods=['POST'])
def verify_otp_route():
    data = request.json
    email = data.get('email')
    otp = data.get('otp')
    
    if not email or not otp:
        return jsonify({"success": False, "message": "Email and OTP are required"}), 400
    
    stored_otp = otp_storage.get(email)
    if stored_otp and stored_otp == otp:
        return jsonify({"success": True, "message": "OTP verified successfully"})
    else:
        return jsonify({"success": False, "message": "Invalid OTP"}), 400
    
def create_otp_routes(app):
    app.register_blueprint(otp_routes, url_prefix='/otp')    