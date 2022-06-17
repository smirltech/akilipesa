import 'dart:convert';
import 'dart:developer';

import 'package:akilipesa/application/configs/inits.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  int id;
  String email;
  String password;
  String nom;
  String prenom;
  String sexe;
  String image;
  String bio;
  String um;
  String last_login;
  String created;
  String get nomComplet => "$prenom $nom";

  Profile(
      {this.id,
      this.email,
      this.password,
      this.nom,
      this.prenom,
      this.sexe,
      this.image,
      this.bio,
      this.um,
      this.last_login,
      this.created});

  factory Profile.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Profile(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      email: map['email']?.toString(),
      password: map['password']?.toString(),
      nom: map['nom']?.toString(),
      prenom: map['prenom']?.toString(),
      sexe: map['sexe']?.toString(),
      image: map['image']?.toString(),
      bio: map['bio']?.toString(),
      um: map['um']?.toString(),
      last_login: map['last_login']?.toString(),
      created: map['created']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom,
      'sexe': sexe,
      'image': image,
      'bio': bio,
      'um': um,
      'last_login': last_login,
      'created': created,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return 'Profile{id: $id, email: $email, password: $password, nom: $nom, prenom: $prenom, sexe: $sexe, image: $image, bio: $bio, um:$um, last_login: $last_login, created: $created}';
  }

  void saveProfile() async {
    final SharedPreferences _prefs = await PREFS;
    _prefs.setString('profileinfo', this.toJson());
  }

  void unsaveProfile() async {
    final SharedPreferences _prefs = await PREFS;
    _prefs.remove('profileinfo');
  }
}
