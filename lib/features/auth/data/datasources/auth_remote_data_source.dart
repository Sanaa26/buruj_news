import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('https://reqres.in/api/register');
    
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var errorMessage = 'Registration failed';
      try {
        final errorResponse = jsonDecode(response.body);
        errorMessage = errorResponse['error'] ?? errorMessage;
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
