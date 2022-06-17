
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
import 'package:akilipesa/application/models/Profile.dart';
import 'package:akilipesa/application/models/Type.dart';

import 'home_page.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedNavBarItem = 0;
  String _label = "Categories";
  TextEditingController _controllerdescr;
  Type _selectedType;
  List<Type> _types;
  Profile _profile;

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<LoginWatcher>(context, listen: false).profile;
    _types = Provider.of<Transactions>(context, listen: false).types;
    _controllerdescr = TextEditingController(text: null);
    _selectedType = _types.isNotEmpty ? _types.first : null;
  }

  @override
  Widget build(BuildContext context) {
   // _profile = Provider.of<LoginWatcher>(context, listen: false).profile;
    //List<DropdownMenuItem<Type>> _catdrops = getTypeDrops(_types);
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
            addCategorieDialog(
                context,
                Provider.of<Transactions>(context, listen: false).categories,
                _types,
                _profile.id);
          },
          child: Icon(Icons.add),
        ),
        //  bottomNavigationBar: buildBottomAppBar(context, _selectedNavBarItem),
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
                      categoriesIcon,
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
                      itemCount: tr.categories.length,
                      itemBuilder: (context, idx) {
                        return ListTile(
                          leading: CircleAvatar(
                              backgroundColor: colorPrimary,
                              child: Text("${idx + 1}")),
                          title: Text("${tr.categories[idx].nom}"),
                          subtitle: Text("${tr.categories[idx].type}"),
                          trailing: Text(
                            "${NumberFormat('#,##0.00').format(tr.categories[idx].solde.abs())}${_profile.um}",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                          onLongPress: () {
                            editCategorieDialog(tr.categories[idx]);
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

  void editCategorieDialog(Categorie categ) {
    TextEditingController _controlleredit =
        TextEditingController(text: categ.nom);
    List<DropdownMenuItem<Type>> _catdrops = getTypeDrops(_types);
    Type _selectedEditType =
        _types.singleWhere((element) => element.id == categ.type_id);
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Modifier Categorie"),
        content: SingleChildScrollView(
          child: Container(
            child: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (cat) => doesCategorieExist(
                      cat,
                      Provider.of<Transactions>(context, listen: false)
                          .categories),
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
              deleteCategorie(categ.id, categ.nom);
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
              DBM
                  .raw_query(getUpdateCategorie(categ.id, _selectedEditType.id,
                      _controlleredit.text, _profile.id))
                  .whenComplete(() {
                setState(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadCategories(_profile.id);
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

  void deleteCategorie(int categorieid, String categname) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Suppression de Categorie"),
        content: Text(
            "Vous êtes sur le point de supprimer la categorie \"$categname\". Toutes les transactions dépendantes deviendront orphelines, vous aurez à les affecter aux autres categories manuellement. Supprimer ?"),
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
                  .raw_query(getDeleteCategorie(categorieid, _profile.id))
                  .whenComplete(() {
                setState(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadCategories(_profile.id);
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
