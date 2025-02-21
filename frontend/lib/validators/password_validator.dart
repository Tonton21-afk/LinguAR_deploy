class PasswordValidator {
  static bool isPasswordValid(String password) {
    // Password must contain at least:
    // 1 uppercase letter, 1 number, 1 special character, and be 8-12 characters long
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,12}$',
    );
    return regex.hasMatch(password);
  }
}

