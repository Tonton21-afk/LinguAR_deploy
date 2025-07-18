class Authentication {
  final String token;
  final String email;
  final String message;
  final List<String> disabilities; // New field

  Authentication({
    required this.token,
    required this.email,
    required this.message,
    this.disabilities = const [], // Default empty list
  });

  /// Factory constructor to create an Authentication object from JSON
  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      token: json['token'] ?? '', // Ensures token is not null
      email: json['email'] ?? '', // Ensures email is not null
      message: json['message'] ?? 'No message provided', // Default message
      disabilities: List<String>.from(json['disabilities'] ?? []), // Handle null or missing disabilities
    );
  }

  /// Converts Authentication object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'message': message,
      'disabilities': disabilities, // Include disabilities in JSON output
    };
  }

  /// Override toString for better debugging
  @override
  String toString() {
    return 'Authentication(token: $token, email: $email, message: $message, disabilities: $disabilities)';
  }
}