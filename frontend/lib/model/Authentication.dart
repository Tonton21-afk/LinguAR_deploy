class Authentication {
  final String? token; 
  final String? email; 
  final String message; 

  Authentication({
    this.token,
    this.email,
    required this.message,
  });

 
  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      token: json['token'], 
      email: json['email'], 
      message: json['message'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'message': message,
    };
  }
}