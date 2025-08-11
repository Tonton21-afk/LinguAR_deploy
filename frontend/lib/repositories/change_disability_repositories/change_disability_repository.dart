abstract class DisabilityRepository {
  Future<bool> updateDisability({
    required String userId,
    required String? disability,
  });
}