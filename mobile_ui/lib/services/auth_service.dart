import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Sign in method
  Future<bool> signIn(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/sign_in');  

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Extract token from the response headers
        final token = response.headers['authorization']?.replaceFirst('Bearer ', '');
        final userId = responseData['idUser']; 
        if (token != null) {
          // Store token securely
          await _storage.write(key: _tokenKey, value: token);
          await _storage.write(key: 'userId', value: userId);
          return true; // Sign-in successful
        } else {
          return false; // Token not found
        }
      } else {
        return false; // Sign-in failed
      }
    } catch (e) {
      print("Error during sign in: $e");
      return false;
    }
  }

  // Sign up method
  Future<bool> signUp(String username, String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/sign_up'); 

    try {
      var id = Uuid();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'id': id.v4(),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false; // Sign-up failed
      }
    } catch (e) {
      print("Error during sign up: $e");
      return false;
    }
  }

  // Log out method
  Future<void> signOut() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: 'userId');
  }

  // Check if the user is already authenticated
  Future<bool> isAuthenticated() async {
    String? token = await _storage.read(key: _tokenKey);
    String? idUser = await _storage.read(key: 'userId');
    if(idUser != null)
    return token != null;
    return false;
  }

  // Get the stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }
}

