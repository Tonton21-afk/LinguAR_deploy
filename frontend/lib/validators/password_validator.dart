class PasswordValidator {
  static final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,12}$',
  );

  static bool isPasswordValid(String password) {
    return _passwordRegex.hasMatch(password);
  }

  /// Returns null if valid, or error message string if invalid
  static String? validate(String password) {
    if (password.isEmpty) {
      return 'Please enter a new password.';
    }
    if (!_passwordRegex.hasMatch(password)) {
      return 'Password must contain at least 1 uppercase letter,\n1 number, 1 special character, and be 8-12 characters long.';
    }
    return null; // Valid password
  }
}