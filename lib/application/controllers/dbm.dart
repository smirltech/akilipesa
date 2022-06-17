import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:akilipesa/application/configs/inits.dart';

class DBM {
  static Future<http.Response> raw_query(String sql) async {
    final _map = {'sql': sql};
    return await http.post(SQL_URL, body: _map);
  }

  static Future<http.Response> base_query(String url, String sql) async {
    final _map = {'sql': sql};
    return await http.post(url, body: _map);
  }

  static Future<http.Response> base_edit_query(
      String url, int userid, String sql) async {
    final _map = {'userid': "$userid", 'sql': sql};
    return await http.post(url, body: _map);
  }

  static Future<http.Response> base_login(
      String url, String email, String password) async {
    final _map = {'email': email, 'password': password};
    return await http.post(url, body: _map);
  }

  static Future<http.Response> base_loadProfile(String url, int userid) async {
    final Map<String, String> _map = {'userid': "$userid"};
    return await http.post(url, body: _map);
  }
}
