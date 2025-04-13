import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipinjam/models/peminjam_model.dart';

class AppSession {
  static Future<PeminjamModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    String? userString = pref.getString('user');
    if (userString == null) return null;
    var userMap = jsonDecode(userString);
    return PeminjamModel.fromJson(userMap);
  }

  static Future<bool> setUser(Map userMap) async {
    final pref = await SharedPreferences.getInstance();
    String userString = jsonEncode(userMap);
    bool success = await pref.setString('user', userString);
    return success;
  }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    return success;
  }
}
