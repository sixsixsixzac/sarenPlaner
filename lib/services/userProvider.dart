import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _isLoggedIn = false;
  String? _userId;

  UserProvider(this.prefs) {
    _loadUserState();
  }

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;

  void _loadUserState() {
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> login(String userId) async {
    _isLoggedIn = true;
    _userId = userId;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    notifyListeners();
  }
}
