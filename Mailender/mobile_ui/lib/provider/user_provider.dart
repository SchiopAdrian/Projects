import 'package:flutter/material.dart';
import 'package:mobile_ui/provider/mail_provider.dart';
import 'package:mobile_ui/provider/task_provider.dart';
import 'package:mobile_ui/services/auth_service.dart';
import 'package:http/http.dart' as http;
class UserProvider extends ChangeNotifier {
  final AuthService _authService;
  String? _userId;

  UserProvider(this._authService) {
    _loadUserId();
  }

  String? get userId => _userId;

  Future<void> _loadUserId() async {
    _userId = await _authService.getUserId();
    notifyListeners();
  }

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    notifyListeners();
  }

  Future<void> checkAuthentication() async {
    bool isAuthenticated = await _authService.isAuthenticated();
    if (!isAuthenticated) {
      clearUser();
    }
  }

  // Expose AuthService methods through the UserProvider

  Future<bool> signIn(String email, String password, MailProvider emailProvider, TaskProvider taskProvider) async {
    bool success = await _authService.signIn(email, password);
    if (success) {
      _userId = await _authService.getUserId();
      
      await emailProvider.fetchMailsAfterLogin();
      await taskProvider.fetchTasksAfterLogin();
      notifyListeners();
    }
    return success;
  }

  Future<bool> signUp(String username, String email, String password) async {
    bool success = await _authService.signUp(username, email, password);
    return success;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    clearUser();
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<String?> getUserId() async {
    return await _authService.getUserId();
  }
  
}