import 'dart:convert';
import 'dart:developer';

import 'package:akilipesa/application/models/Monnaie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/core/utils.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWatcher with ChangeNotifier {
  List<Monnaie> monnaies = List<Monnaie>();
  int _logState = -1;
  set logState(int state) {
    _logState = state;
    notifyListeners();
  }

  int get logState => _logState;

  Profile _profile;
  set profile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  Profile get profile => _profile;

  loadMonnaies() async {
    DBM.raw_query(getAllUm()).then((value) {
      //log(value.body);
      monnaies.clear();
      List<dynamic> mm = jsonDecode(value.body);
      monnaies = mm.map((e) => Monnaie.fromMap(e)).toList();
      notifyListeners();
    }).catchError((err) {
      log(err.toString());
    });
  }

  tryLogin(BuildContext context) async {
    final SharedPreferences _prefs = await PREFS;

    await Future.delayed(Duration(seconds: 3));
    //log("outter");
    if (_prefs.containsKey('profileinfo')) {
      Map s = jsonDecode(_prefs.getString('profileinfo'));

      profile = await login(
        email: s['email'],
        password: s['password'],
      ).timeout(Duration(seconds: 10), onTimeout: () {
        profile = null;
        logState = 0;
        return profile;
      }).catchError((err) {
        profile = null;
        logState = 0;
      });
      if (profile != null) {
        profile.saveProfile();
        Provider.of<Transactions>(context, listen: false)
            .initTransactions(profile.id);
        logState = 1;
      } else {
        profile = null;
        logState = 0;
      }
      notifyListeners();
    } else {
      profile = null;
      logState = 0;
    }
  }

  updateLastLogin() async {
    while (true) {
      //log("message");
      await Future.delayed(Duration(seconds: 5));
      if (profile != null) {
        DBM.base_query(A_REGISTER_URL, getLastLogin(profile.id));
      }
      loadMonnaies();
    }
  }

  logoutNow() async {
    final SharedPreferences _prefs = await PREFS;
    if (_prefs.containsKey('profileinfo')) {
      profile.unsaveProfile();
      profile = null;
      logState = 0;
    }
  }

  LoginWatcher() {
    loadMonnaies();
    updateLastLogin();
  }
}
