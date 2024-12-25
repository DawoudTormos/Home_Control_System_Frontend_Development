import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080";
  final _storage = const FlutterSecureStorage();

  // Store token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Login Method
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("token")) {
        await saveToken(data["token"]);
        return {"success": true, "token": data["token"]};
      } else {
        return {"success": false, "error": data["error"]};
      }
    } else {
      return {"success": false, "error": "Unexpected server error"};
    }
  }

  // Sign Up Method
  Future<Map<String, dynamic>> signUp(String username, String password, String email) async {
    final url = Uri.parse("$baseUrl/signup");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "username": username,
        "password": password,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("token")) {
        await saveToken(data["token"]);
        return {"success": true, "message": data["message"], "token": data["token"]};
      } else {
        return {"success": false, "error": data["Error"] ?? "Unknown error"};
      }
    } else {
      return {"success": false, "error": "Unexpected server error"};
    }
  }



  
}
