import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_ui/model/task.dart';
// Import the Task model

class TaskService {
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
  

  Future<List<Task>> fetchTasks() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/tasks'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventJson) => Task.fromMap(eventJson)).toList();
    } else {
      throw Exception('Failed to load events from server');
    }
  }

  Future<void> createTasks(Task event) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.post(
      Uri.parse('$baseUrl/task'),
      headers: headers,
      body: jsonEncode(event.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create event');
    }
  }

  Future<void> updateTasks(String id, Task event) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.put(
      Uri.parse('$baseUrl/task/$id'),
      headers: headers,
      body: jsonEncode(event.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteTasks(String id) async {
    final headers = await _getHeaders(); // Get headers with token
    final response = await http.delete(
      Uri.parse('$baseUrl/task/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }

  Future<Task> getTasks(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/task/$id'),
    );

    if (response.statusCode == 200) {
      return Task.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load event');
    }
  }

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
