/* import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_cash_tracker/application/configs/custom_sqls.dart';
import 'package:s_cash_tracker/application/configs/color_presets.dart';
import 'package:s_cash_tracker/application/controllers/Transactions.dart';
import 'package:s_cash_tracker/application/controllers/dbm.dart';
import 'package:s_cash_tracker/application/core/presets.dart';
import 'package:s_cash_tracker/application/models/Categorie.dart';

class NewExpensePage extends StatefulWidget {
  NewExpensePage({Key key, this.groupeid}) : super(key: key);
  final groupeid;
  @override
  _NewExpensePageState createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  String _label = "Nouvelle Recette";
  TextEditingController _controllerdate;
  TextEditingController _controllerdescr;
  TextEditingController _controlleramount;
  Categorie _selectedCateg;
  @override
  void initState() {
    _label = widget.groupeid == 1 ? "Nouvelle Recette" : "Nouvelle Dépense";
    _selectedCateg = widget.groupeid == 1
        ? Provider.of<Transactions>(context, listen: false).inc_categories.first
        : Provider.of<Transactions>(context, listen: false)
            .exp_categories
            .first;
    super.initState();
    _controllerdate = TextEditingController(text: DateTime.now().toString());
    _controllerdescr = TextEditingController(text: null);
    _controlleramount = TextEditingController(text: null);
  }

  @override
  Widget build(BuildContext context) {
    List<Categorie> _caategs = widget.groupeid == 1
        ? Provider.of<Transactions>(context, listen: false).inc_categories
        : Provider.of<Transactions>(context, listen: false).exp_categories;
    List<DropdownMenuItem<Categorie>> _catdrops = getCategorieDrops(_caategs);
    return Scaffold(
      backgroundColor: colorSecondaryLight,
      body: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              colorPrimaryLight,
              colorPrimary,
              colorPrimaryDark,
            ])),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(this);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _label,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      GestureDetector(
                          onTap: () {
                            saveTransaction();
                          },
                          child: Text(
                            "ENREGISTRER",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                TextField(
                  controller: _controllerdescr,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 10,
                  minLines: 5,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Decrire cette transaction",
                    border: OutlineInputBorder(),
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
                TextField(
                  textAlign: TextAlign.end,
                  controller: _controlleramount,
                  decoration: InputDecoration(
                    labelText: "Montant",
                    hintText: "ex. 278",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                    value: _selectedCateg,
                    items: _catdrops,
                    // hi
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: "Categorie",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (el) {
                      setState(() {
                        _selectedCateg = el;
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void saveTransaction() {
    if (_controllerdescr.text != null &&
        _controlleramount.text != null &&
        _controllerdescr.text.isNotEmpty &&
        _controlleramount.text.isNotEmpty) {
      DBM
          .raw_query(getSaveTransaction(_selectedCateg.id, _controllerdate.text,
              _controllerdescr.text, _controlleramount.text))
          .whenComplete(() {
        Navigator.of(context).pop(this);
      });
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            "Echec d'Enregistrement",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Soit le champ de la description, soit le champ du montant est vide. Veuillez completer les champs encore vides, puis enregistrez!",
            textAlign: TextAlign.justify,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(this);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );
    }
  }

  /*List<DropdownMenuItem<Categorie>> getCategorieDrops(List<Categorie> categs) {
    List<DropdownMenuItem<Categorie>> ddm = List<DropdownMenuItem<Categorie>>();
    categs.forEach((element) {
      ddm.add(DropdownMenuItem<Categorie>(
        child: Text(element.nom),
        value: element,
      ));
    });
    return ddm;
  }*/
}
 */