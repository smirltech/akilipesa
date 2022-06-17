import 'dart:convert';
import 'dart:developer';

import 'package:akilipesa/application/configs/inits.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  int id;
  String username;
  String password;
  String categorie;
  String created;

  User({this.id, this.username, this.password, this.categorie, this.created});

  static User fromMap(Map map) {
    if (map == null) return null;
    return User(
      id: int.parse("${map['id']}"),
      username: map['username'],
      password: map['password'],
      categorie: map['categorie'],
      created: map['created'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'categorie': categorie,
      'created': created
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, categorie: $categorie, created: $created}';
  }

  void saveUser() async {
    final SharedPreferences _prefs = await PREFS;
    _prefs.setString('userinfo', this.toJson());
  }

  void unsaveUser() async {
    final SharedPreferences _prefs = await PREFS;
    _prefs.remove('userinfo');
  }
}
