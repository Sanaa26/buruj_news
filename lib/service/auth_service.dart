import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // We use reqres.in for mock post API requests to demonstrate a working login/registration.
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('https://reqres.in/api/register');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // e.g. {"id": 4, "token": "QpwL5tke4Pnpja7X4"}
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
