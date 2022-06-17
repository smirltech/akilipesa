import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/core/presets.dart';
import 'package:akilipesa/application/core/utils.dart';
import 'package:akilipesa/application/models/Categorie.dart';
import 'package:akilipesa/application/models/Compte.dart';
import 'package:akilipesa/application/models/Profile.dart';

import 'home_page.dart';

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  int _selectedNavBarItem = 1;
  String _label = "Comptes";

  List<Categorie> _categories;
  Profile _profile;

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<LoginWatcher>(context, listen: false).profile;
    _categories = Provider.of<Transactions>(context, listen: false).categories;
  }

  @override
  Widget build(BuildContext context) {
    // List<DropdownMenuItem<Categorie>> _catdrops = getGroupeDrops(_categories);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(this);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorPrimary,
          splashColor: colorAccent0016,
          onPressed: () {
            //addCompteDialog();
            addCompteDialog(
                context,
                Provider.of<Transactions>(context, listen: false).comptes,
                _categories,
                _profile.id);
          },
          child: Icon(Icons.add),
        ),
        // bottomNavigationBar: buildBottomAppBar(context, _selectedNavBarItem),
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimaryLight,
                    colorPrimary,
                    colorPrimaryDark,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Row(
                  children: [
                    Icon(
                      comptesIcon,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      _label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Consumer<Transactions>(
                  builder: (_, tr, __) {
                    return ListView.separated(
                      itemCount: tr.comptes.length,
                      itemBuilder: (context, idx) {
                        return ListTile(
                          leading: CircleAvatar(
                              backgroundColor: colorPrimary,
                              child: Text("${idx + 1}")),
                          title: Text("${tr.comptes[idx].nom}"),
                          subtitle: Text("${tr.comptes[idx].categorie}"),
                          trailing: Text(
                            "${NumberFormat('#,##0.00').format(tr.comptes[idx].solde.abs())}${_profile.um}",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                          onLongPress: () {
                            editCompteDialog(tr.comptes[idx]);
                          },
                        );
                      },
                      separatorBuilder: (context, idx) {
                        return Container(
                          margin: EdgeInsets.only(left: 60),
                          height: 1,
                          color: Colors.grey.shade400,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editCompteDialog(Compte compte) {
    TextEditingController _controlleredit =
        TextEditingController(text: compte.nom);
    List<DropdownMenuItem<Categorie>> _catdrops =
        getCategorieDrops(_categories);
    Categorie _selectedEditCategorie =
        _categories.singleWhere((element) => element.id == compte.categorie_id);
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Modifier Compte"),
        content: SingleChildScrollView(
          child: Container(
            child: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (cat) => doesCategorieExist(cat, _categories),
                  autovalidate: true,
                  controller: _controlleredit,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: colorPrimary),
                    labelText: "Compte",
                    hintText: "Saisir nom de compte",
                    counterStyle: TextStyle(color: colorPrimaryLight),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white.withOpacity(0.1),
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                    value: _selectedEditCategorie,
                    items: _catdrops,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: colorPrimary),
                      labelText: "Choisir Categorie",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (el) {
                      // setState(() {
                      _selectedEditCategorie = el;
                      // });
                    }),
              ],
            )),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              deleteCompte(compte.id, compte.nom);
            },
            child: Text(
              "DELETE",
              style: TextStyle(
                  color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(this);
            },
            child: Text(
              "ANNULER",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () {
              //log("${_profile.id}");
              DBM
                  .raw_query(getUpdateCompte(
                      compte.id,
                      _selectedEditCategorie.id,
                      _controlleredit.text,
                      _profile.id))
                  .whenComplete(() {
                setState(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadComptes(_profile.id);
                });
              });
              Navigator.of(context).pop(this);
            },
            child: Text(
              "MODIFIER",
              style: TextStyle(
                  color: colorPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void deleteCompte(int compteid, String comptename) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Suppression de Compte"),
        content: Text(
            "Vous êtes sur le point de supprimer la categorie \"$comptename\". Toutes les transactions dépendantes deviendront orphelines, vous aurez à les affecter aux autres categories manuellement. Supprimer ?"),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(this);
            },
            child: Text("ANNULER"),
          ),
          FlatButton(
            onPressed: () {
              DBM
                  .raw_query(getDeleteCompte(compteid, _profile.id))
                  .whenComplete(() {
                setState(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadComptes(_profile.id);
                });
              });
              Navigator.of(context).pop(this);
            },
            child: Text("SUPPRIMER"),
          ),
        ],
      ),
    );
  }

  Container _buildRemoveTrip() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
