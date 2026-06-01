import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String email, String password) {
    return repository.register(email, password);
  }
}
