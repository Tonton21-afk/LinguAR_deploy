class Authentication {
  final String token;
  final String email;
  final String name; // Add other user fields if necessary

  Authentication({
    required this.token,
    required this.email,
    required this.name,
  });

  // Factory constructor to create an Authentication object from JSON
  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      token: json['token'],
      email: json['email'],
      name: json['name'],  // Assuming 'name' exists in the API response
    );
  }

  // Method to convert the Authentication object to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'name': name,
    };
  }
}
