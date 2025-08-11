class Authentication {
  final String token;
  final String email;
  final String message;
  final String? disability; // Changed to nullable String (singular form)

  Authentication({
    required this.token,
    required this.email,
    required this.message,
    this.disability, // Now nullable with no default value
  });

  /// Factory constructor to create an Authentication object from JSON
  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      token: json['token'] ?? '', // Ensures token is not null
      email: json['email'] ?? '', // Ensures email is not null
      message: json['message'] ?? 'No message provided', // Default message
      disability: json['disability'], // Can be null if not provided
    );
  }

  /// Converts Authentication object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'message': message,
      'disability': disability, // Will be null if not set
    };
  }

  /// Override toString for better debugging
  @override
  String toString() {
    return 'Authentication(token: $token, email: $email, message: $message, disability: $disability)';
  }
}