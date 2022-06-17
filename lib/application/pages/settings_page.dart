import 'dart:convert';
import 'dart:developer';

import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/models/Monnaie.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choix d'Unité Monétaire"),
        backgroundColor: colorPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: colorPrimary,
        onPressed: () => addNouvelleMonnaie(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Consumer<LoginWatcher>(
          builder: (_, lw, __) {
            return ListView.builder(
              itemCount: lw.monnaies.length,
              itemBuilder: (context, idx) {
                Monnaie _mn = lw.monnaies[idx];
                return CheckboxListTile(
                  secondary: Text("${_mn.um}"),
                  title: Text("${_mn.nom ?? ''}"),
                  value: lw.profile.um == _mn.um,
                  onChanged: (va) {
                    if (va == true)
                      confirmUMChange(context, lw.profile.id, _mn.um);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void confirmUMChange(BuildContext context, int userid, String um) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                Text("Êtes-vous sur de vouloir changer l'unité monétaire ?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(this);
                  },
                  child: Text("ANNULER")),
              FlatButton(
                  onPressed: () {
                    updateMonnaie(context, userid, um, done: (prof) {
                      Provider.of<LoginWatcher>(context, listen: false)
                          .profile = prof;
                      Navigator.of(context).pop(this);
                    });

                  },
                  child: Text("MODIFIER")),
            ],
          );
        });
  }

  void updateMonnaie(BuildContext context, int userid, String um,
      {done(Profile profile)}) {
    DBM
        .base_edit_query(
            A_EDIT_PROFILE_URL, userid, getEditProfileUM(userid, um))
        .then((value) {
      Profile profile = Profile.fromMap(jsonDecode(value.body));
      //log(profile.toString());
      profile.saveProfile();
     // Provider.of<LoginWatcher>(context, listen: false).profile = profile;
      if (done != null) done(profile);
    });
  }

  void addNouvelleMonnaie() {
    TextEditingController _monController = TextEditingController();
    TextEditingController _nomController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ajouter Nouvelle Monnaie"),
            content: Consumer<LoginWatcher>(builder: (_, lw, __) {
              return Container(
                height: 160,
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nomController,
                        autovalidate: true,
                        validator: (va) {
                          if (va.isEmpty) return "";
                          return (Monnaie.monnaiesContientNom(lw.monnaies, va))
                              ? "$va existe déjà !"
                              : "";
                        },
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          // prefixIcon: Icon(Linecons.money),
                          labelText: "Nom Monnaie",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _monController,
                        autovalidate: true,
                        validator: (va) {
                          if (va.isEmpty) return "";
                          return (Monnaie.monnaiesContientUM(lw.monnaies, va))
                              ? "$va existe déjà !"
                              : "";
                        },
                        maxLength: 3,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          prefixIcon: Icon(Linecons.money),
                          labelText: "Unité Monétaire",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: [
              FlatButton(
                child: Text(
                  "ANNULER",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop(this);
                },
              ),
              FlatButton(
                child: Text("AJOUTER"),
                onPressed: () {
                  String moo = _monController.text;
                  String nom = _nomController.text;
                  addMonnaie(moo, nom);
                  Navigator.of(context).pop(this);
                },
              ),
            ],
          );
        });
    ;
  }

  addMonnaie(String moo, String nom) async {
    String _sql = getSaveUm(moo, nom);
    //log(_sql);
    await DBM.base_query(SQL_URL, _sql).then((elm) {
      // Provider.of<LoginWatcher>(context, listen: false).loadMonnaies();
    });
  }
}
