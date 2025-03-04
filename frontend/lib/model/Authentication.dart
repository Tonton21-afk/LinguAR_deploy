class Authentication {
  final String token; 
  final String email; 
  final String message; 

  Authentication({
    required this.token,
    required this.email,
    required this.message,
  });

  /// Factory constructor to create an Authentication object from JSON
  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      token: json['token'] ?? '', // Ensures token is not null
      email: json['email'] ?? '', // Ensures email is not null
      message: json['message'] ?? 'No message provided', // Default message
    );
  }

  /// Converts Authentication object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'message': message,
    };
  }
}
