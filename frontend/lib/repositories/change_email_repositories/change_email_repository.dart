abstract class ResetEmailRepository {
  Future<String> resetEmail({
    required String email,
    required String otp,
    required String newEmail,
  });
}
