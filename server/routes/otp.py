from flask import Blueprint, request, jsonify
import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os
import time

# Blueprint definition
otp_routes = Blueprint('otp_routes', __name__)

# Shared OTP storage
otp_storage = {}

def generate_otp():
    return str(random.randint(100000, 999999))

def send_otp(email, otp):
    # Use environment variables for security
    sender_email = "LinguaAR01@gmail.com"  
    sender_password = "mywq drvg lzwh ctlj"
    
    # Create message with better formatting
    message = MIMEMultipart()
    message['Subject'] = 'Your OTP for Password Reset'
    message['From'] = sender_email
    message['To'] = email
    
    # Email content
    body = f"""
    Hello,
    
    Your OTP verification code is: {otp}
    
    This code will expire in 10 minutes.
    
    If you didn't request this code, please ignore this email.
    
    Best regards,
    Your App Team
    """
    
    message.attach(MIMEText(body, 'plain'))
    
    try:
        # Create SMTP connection with explicit timeout
        server = smtplib.SMTP('smtp.gmail.com', 587, timeout=25)  # 25 seconds timeout
        server.ehlo()  # Identify yourself to the SMTP server
        server.starttls()  # Secure the connection
        server.ehlo()  # Re-identify yourself over TLS connection
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, [email], message.as_string())
        server.quit()  # Use quit() instead of relying on context manager
        
        print(f"OTP sent successfully to {email}")
        return True
        
    except smtplib.SMTPException as e:
        print(f"SMTP error occurred: {e}")
        return False
    except Exception as e:
        print(f"Error sending email: {e}")
        return False

def cleanup_old_otps():
    """Remove OTPs older than 10 minutes"""
    current_time = time.time()
    expired_emails = [
        email for email, data in otp_storage.items() 
        if current_time - data['timestamp'] > 600
    ]
    for email in expired_emails:
        del otp_storage[email]
        print(f"Cleaned up expired OTP for: {email}")

@otp_routes.route('/send-otp', methods=['POST'])
def send_otp_route():
    data = request.json
    email = data.get('email')
    
    if not email:
        return jsonify({"success": False, "message": "Email is required"}), 400
    
    # Generate OTP and store with timestamp
    otp = generate_otp()
    otp_storage[email] = {
        'otp': otp,
        'timestamp': time.time()
    }
    
    # Clean up old OTPs (older than 10 minutes)
    cleanup_old_otps()
    
    if send_otp(email, otp):
        return jsonify({"success": True, "message": "OTP sent successfully"})
    else:
        # Remove the OTP if sending failed
        if email in otp_storage:
            del otp_storage[email]
        return jsonify({"success": False, "message": "Failed to send OTP"}), 500

@otp_routes.route('/verify-otp', methods=['POST'])
def verify_otp_route():
    data = request.json
    email = data.get('email')
    otp = data.get('otp')
    
    if not email or not otp:
        return jsonify({"success": False, "message": "Email and OTP are required"}), 400
    
    # Clean up before verification
    cleanup_old_otps()
    
    stored_data = otp_storage.get(email)
    if not stored_data:
        return jsonify({"success": False, "message": "OTP not found or expired"}), 400
    
    stored_otp = stored_data['otp']
    timestamp = stored_data['timestamp']
    
    # Check if OTP is expired (10 minutes)
    if time.time() - timestamp > 600:  # 10 minutes in seconds
        del otp_storage[email]
        return jsonify({"success": False, "message": "OTP has expired"}), 400
    
    if stored_otp == otp:
        # Remove OTP after successful verification
        del otp_storage[email]
        return jsonify({"success": True, "message": "OTP verified successfully"})
    else:
        return jsonify({"success": False, "message": "Invalid OTP"}), 400

def create_otp_routes(app):
    app.register_blueprint(otp_routes, url_prefix='/otp')
