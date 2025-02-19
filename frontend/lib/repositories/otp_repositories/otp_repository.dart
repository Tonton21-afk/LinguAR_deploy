abstract class OtpRepository {
  Future<bool> sendOtp(String email);
  Future<bool> verifyOtp(String email, String otp);
}