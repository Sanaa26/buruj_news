abstract class AuthRepository {
  Future<Map<String, dynamic>> register(String email, String password);
}
