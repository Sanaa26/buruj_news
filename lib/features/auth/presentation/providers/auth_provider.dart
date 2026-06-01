import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return AuthRemoteDataSourceImpl(client: client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUserUseCase(repository);
});

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState();

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);
    try {
      final useCase = ref.read(registerUserUseCaseProvider);
      await useCase.execute(email, password);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
  
  void resetState() {
     state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
