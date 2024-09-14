import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_ui/model/mail.dart';

class MailService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Function to retrieve the JWT token from storage
  Future<String?> _getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Function to add the JWT token to headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Include the token if it exists
    };
  }

  // Fetch all mails from the server
  Future<List<Mail>> fetchMails() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/emails'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((mailJson) => Mail.fromMap(mailJson)).toList();
    } else {
      throw Exception('Failed to load mails from server');
    }
  }

  // Create a new mail on the server
  Future<void> createMail(Mail mail) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.post(
      Uri.parse('$baseUrl/email'),
      headers: headers,
      body: jsonEncode(mail.toMap()),
    );

    if (response.statusCode != 201) { // Assuming 201 Created for successful creation
      throw Exception('Failed to create mail');
    }
  }

  // Update an existing mail on the server
  Future<void> updateMail(String id, Mail mail) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.put(
      Uri.parse('$baseUrl/email/$id'),
      headers: headers,
      body: jsonEncode(mail.toMap()),
    );

    if (response.statusCode != 200) { // Assuming 200 OK for successful update
      throw Exception('Failed to update mail');
    }
  }

  // Delete a mail from the server
  Future<void> deleteMail(String id) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.delete(
      Uri.parse('$baseUrl/email/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) { // Assuming 200 OK for successful deletion
      throw Exception('Failed to delete mail');
    }
  }

  // Get a specific mail by ID from the server
  Future<Mail> getMail(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/email/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Mail.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load mail');
    }
  }

  // Check server health
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/healthcheck')); // Ensure this endpoint exists
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking server health: $e');
      return false;
    }
  }
}
