abstract class ResetPasswordRepository {
  Future<bool> resetPassword(String email, String otp, String newPassword);
}