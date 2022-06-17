import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/core/presets.dart';
import 'package:akilipesa/application/models/Categorie.dart';
import 'package:akilipesa/application/models/Compte.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:akilipesa/application/models/Type.dart';
import 'package:akilipesa/application/pages/categories_page.dart';
import 'package:akilipesa/application/pages/comptes_page.dart';
import 'package:akilipesa/application/pages/home_page.dart';
import 'package:akilipesa/application/pages/profile_page.dart';
import 'package:akilipesa/application/pages/transactions_page.dart';
import 'package:akilipesa/application/configs/inits.dart';

void addTransactionDialog(
    BuildContext context, List<Compte> comptes, int userid,
    {Function onDone}) {
  TextEditingController _controllerdate =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController _controlleredit = TextEditingController(text: null);
  TextEditingController _controllerdebit = TextEditingController(text: null);
  TextEditingController _controllercredit = TextEditingController(text: null);
  List<DropdownMenuItem<Compte>> _cptdrops = getCompteDrops(comptes);
  Compte _selectedEditCompte = comptes.isEmpty ? null : comptes.first;
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Ajouter Transaction"),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                //validator: (cat) => doesExist(cat),
                autovalidate: true,
                controller: _controlleredit,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 5,
                //minLines: 10,
                maxLength: 255,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: colorPrimary),
                  labelText: "Description",
                  hintText: "Saisir la description de la transaction",
                  counterStyle: TextStyle(color: colorPrimaryLight),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'dd MMM yyyy',
                  controller: _controllerdate,
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: "Date",
                  timeLabelText: "Heure",
                  selectableDayPredicate: (date) {
                    // if (date.weekday == 6 || date.weekday == 7) return false;
                    return true;
                  },
                  onChanged: (val) {},
                  validator: (val) {},
                  onSaved: (val) {},
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                value: _selectedEditCompte,
                items: _cptdrops,
                isExpanded: true,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: colorPrimary),
                  labelText: "Choisir Compte",
                  border: OutlineInputBorder(),
                ),
                onChanged: (el) {
                  // setState(() {
                  _selectedEditCompte = el;
                  // });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Montant:",
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidate: true,
                          controller: _controllerdebit,
                          textAlign: TextAlign.end,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: colorPrimary),
                            labelText: "Entrée",
                            hintText: "0.0",
                            counterStyle: TextStyle(color: colorPrimaryLight),
                            border: OutlineInputBorder(),
                            fillColor: Colors.white.withOpacity(0.1),
                            filled: true,
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          autovalidate: true,
                          controller: _controllercredit,
                          textAlign: TextAlign.end,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: colorPrimary),
                            labelText: "Sortie",
                            hintText: "0.0",
                            counterStyle: TextStyle(color: colorPrimaryLight),
                            border: OutlineInputBorder(),
                            fillColor: Colors.white.withOpacity(0.1),
                            filled: true,
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "ANNULER",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        if (comptes.isNotEmpty)
          FlatButton(
            onPressed: () {
              if (_controlleredit.text != null &&
                  _controlleredit.text.isNotEmpty) {
                if ((_controllercredit.text.isNotEmpty ||
                        _controllerdebit.text.isNotEmpty) &&
                    !(_controllercredit.text.isNotEmpty &&
                        _controllerdebit.text.isNotEmpty)) {
                  var _dr = _controllerdebit.text.isNotEmpty
                      ? _controllerdebit.text
                      : "0.0";
                  var _cr = _controllercredit.text.isNotEmpty
                      ? _controllercredit.text
                      : "0.0";

                  DBM
                      .raw_query(getSaveTransaction(
                          _selectedEditCompte.id,
                          _controllerdate.text,
                          _controlleredit.text,
                          _dr,
                          _cr,
                          userid))
                      .whenComplete(() {
                    Provider.of<Transactions>(context, listen: false)
                        .loadTransactions(userid);
                    if (onDone != null) onDone();
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Colors.red,
                        title: Text("Montant !"),
                        content: Text(
                            "Un seul champ doit avoir une valeur, et l'autre champ doit rester vide."),
                      ));
                }
              } else {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Champ Vide !"),
                      content: Text("Categorie ne doit pas étre vide !"),
                    ));
              }
            },
            child: Text(
              "AJOUTER",
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    ),
  );
}

void addCompteDialog(BuildContext context, List<Compte> comptes,
    List<Categorie> categories, int userid,
    {Function onDone}) {
  TextEditingController _controlleredit = TextEditingController(text: null);
  List<DropdownMenuItem<Categorie>> _catdrops = getCategorieDrops(categories);
  Categorie _selectedEditCategorie =
      categories.isNotEmpty ? categories.first : null;
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Ajouter Compte"),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (cat) => doesCompteExist(cat, comptes),
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
            Navigator.of(context).pop();
          },
          child: Text("ANNULER"),
        ),
        if (categories.isNotEmpty)
          FlatButton(
            onPressed: () {
              if (_controlleredit.text != null &&
                  _controlleredit.text.isNotEmpty) {
                DBM
                    .raw_query(getSaveCompte(_selectedEditCategorie.id,
                        _controlleredit.text, userid))
                    .whenComplete(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadComptes(userid);
                  if (onDone != null) onDone();
                });
                Navigator.of(context).pop();
              } else {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Champ Vide !"),
                      content: Text("Categorie ne doit pas étre vide !"),
                    ));
              }
            },
            child: Text("AJOUTER"),
          ),
      ],
    ),
  );
}

void addCategorieDialog(BuildContext context, List<Categorie> categories,
    List<Type> types, int userid,
    {Function onDone}) {
  TextEditingController _controlleredit = TextEditingController(text: null);
  List<DropdownMenuItem<Type>> _catdrops = getTypeDrops(types);
  Type _selectedEditType = types.isNotEmpty ? types.first : null;
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Ajouter Categorie"),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (cat) => doesCategorieExist(cat, categories),
                autovalidate: true,
                controller: _controlleredit,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLength: 50,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: colorPrimary),
                  labelText: "Categorie",
                  hintText: "Saisir nom de categorie",
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
                  value: _selectedEditType,
                  items: _catdrops,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: colorPrimary),
                    labelText: "Choisir Type",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (el) {
                    // setState(() {
                    _selectedEditType = el;
                    // });
                  }),
            ],
          )),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("ANNULER"),
        ),
        if (types.isNotEmpty)
          FlatButton(
            onPressed: () {
              if (_controlleredit.text != null &&
                  _controlleredit.text.isNotEmpty) {
                DBM
                    .raw_query(getSaveCategorie(
                        _selectedEditType.id, _controlleredit.text, userid))
                    .whenComplete(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadCategories(userid);
                  if (onDone != null) onDone();
                });
                Navigator.of(context).pop();
              } else {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text("Champ Vide !"),
                      content: Text("Categorie ne doit pas étre vide !"),
                    ));
              }
            },
            child: Text("AJOUTER"),
          ),
      ],
    ),
  );
}

Widget buildNavBarItem(BuildContext context, IconData icon, String title,
    int index, int selectedNavBarItem,
    {Function onClick}) {
  return GestureDetector(
    onTap: () {
      if (onClick != null) onClick();
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 5),
      width: MediaQuery.of(context).size.width / 5,
      height: 50,
      decoration: index == selectedNavBarItem
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4, color: colorAccent),
              ),
              gradient: LinearGradient(
                colors: [
                  colorAccent03,
                  colorAccent0016,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            )
          : BoxDecoration(),
      child: Column(
        children: [
          Icon(
            icon,
            color: index == selectedNavBarItem
                ? colorPrimary
                : Colors.grey.shade400,
          ),
          Text(
            "${title}",
            style: TextStyle(
              fontSize: 11,
              color: index == selectedNavBarItem
                  ? colorPrimary
                  : Colors.grey.shade400,
            ),
          )
        ],
      ),
    ),
  );
}

BottomAppBar buildBottomAppBar(BuildContext context, int selectedNavBarItem) {
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildNavBarItem(
          context,
          FontAwesome5.layer_group,
          "Categories",
          0,
          selectedNavBarItem,
          onClick: () {
            if (selectedNavBarItem != -2) Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesPage()),
            );
          },
        ),
        buildNavBarItem(
          context,
          Icons.account_balance_wallet,
          "Comptes",
          1,
          selectedNavBarItem,
          onClick: () {
            if (selectedNavBarItem != -2) Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ComptesPage()),
            );
          },
        ),
        buildNavBarItem(
          context,
          Icons.home,
          "Accueil",
          2,
          selectedNavBarItem,
          onClick: () {
            if (selectedNavBarItem != -2) Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        buildNavBarItem(
          context,
          Icons.swap_vert,
          "Transactions",
          3,
          selectedNavBarItem,
          onClick: () {
            if (selectedNavBarItem != -2) Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionsPage()),
            );
          },
        ),
        buildNavBarItem(
          context,
          Icons.person,
          "Moi",
          4,
          selectedNavBarItem,
          onClick: () {
            if (selectedNavBarItem != -2) Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
      ],
    ),
  );
}

void login2(
    {@required String email,
    @required String password,
    void onLogin(Profile profile)}) async {
  DBM.base_login(A_LOGIN_URL, email, password).then((value) {
    // log(value.body);
    Profile profile = Profile.fromMap(jsonDecode(value.body));
    //log(user.toString());
    if (onLogin != null) onLogin(profile);
  });
}

Future<Profile> login({
  @required String email,
  @required String password,
}) async {
  Profile _profile;
  await DBM.base_login(A_LOGIN_URL, email, password).then((value) {
    // log(value.body);
    Profile profile = Profile.fromMap(jsonDecode(value.body));
    _profile = profile;
  });
  return _profile;
}
