import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/models/Profile.dart';

void passwordModifierDialog(
    BuildContext context, int userid, String username, String oldPassword,
    {onDone(Profile profile)}) {
  bool changeable = true;
  TextEditingController _controlleroldpassword = TextEditingController();
  TextEditingController _controllernewpassword = TextEditingController();
  showDialog(
    context: context,
    child: AlertDialog(
      title: Container(
        color: colorPrimary,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Text(
          "Modifier Le Mot de Passe",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      titlePadding: EdgeInsets.all(0),
      content: Container(
        child: Container(
          child: Form(
            autovalidate: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _controlleroldpassword,
                  // autovalidate: true,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      changeable = false;
                      return "";
                    } else if (value == oldPassword) {
                      changeable = true;
                      return "";
                    } else {
                      changeable = false;
                      return "Ancien mot de passe incorrect";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(1),
                    prefixIcon: Icon(Icons.lock_open),
                    labelText: "ancien mot de passe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllernewpassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(1),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "nouveau mot de passe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'ANNULER',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        FlatButton(
          onPressed: () {
            editPass(context, userid, username, _controlleroldpassword.text,
                _controllernewpassword.text, done: (profile) {
              if (onDone != null) onDone(profile);
              Navigator.pop(context);
            });
          },
          child: Text('MODIFIER'),
        ),
      ],
    ),
  );
}

editPass(BuildContext context, int userid, String username, String oldpass,
    String newpass,
    {done(Profile profile)}) {
  DBM
      .base_edit_query(A_EDIT_PROFILE_URL, userid,
          getEditPassword(userid, username, oldpass, newpass))
      .then((value) {
    Profile profile = Profile.fromMap(jsonDecode(value.body));
    //log(profile.toString());
    profile.saveProfile();
    Provider.of<LoginWatcher>(context, listen: false).profile = profile;
    if (done != null) done(profile);
  });
}

editMonnaie(BuildContext context, int userid, String um,
    {done(Profile profile)}) {
  DBM
      .base_edit_query(A_EDIT_PROFILE_URL, userid,
      getEditProfileUM(userid, um))
      .then((value) {
    Profile profile = Profile.fromMap(jsonDecode(value.body));
    //log(profile.toString());
    profile.saveProfile();
    Provider.of<LoginWatcher>(context, listen: false).profile = profile;
    if (done != null) done(profile);
  });
}
