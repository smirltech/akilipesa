import 'dart:developer';

import 'package:akilipesa/application/models/Monnaie.dart';
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
import 'package:akilipesa/application/models/Compte.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:akilipesa/application/models/Transaction.dart';

import 'home_page.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _label = "Transactions";

  List<Compte> _comptes;

  Profile _profile;

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<LoginWatcher>(context, listen: false).profile;
    _comptes = Provider.of<Transactions>(context, listen: false).comptes;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(this);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false;
      },
      child: OrientationBuilder(builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorPrimary,
            splashColor: colorAccent0016,
            onPressed: () {
              //addTransactionDialog();
              addTransactionDialog(context, _comptes, _profile.id);
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
                        transactionsIcon,
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
                      return SingleChildScrollView(
                        child: PaginatedDataTable(
                          header: Text("Toutes Mes Transactions"),
                          columnSpacing: 15,
                          horizontalMargin: 5,
                          columns: [
                            DataColumn(
                              label: Text(
                                "DATE",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "DETAIL",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "COMPTE",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (orientation == Orientation.landscape)
                              DataColumn(
                                label: Text(
                                  "CATEGORIE",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            DataColumn(
                              numeric: true,
                              label: Text(
                                "MONTANT",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          source: TransactionData(
                              tr.transactions, orientation, _profile.um,
                              onThisTap: (transaction) {
                            editTransactionDialog(transaction);
                          }),
                          sortAscending: false,
                          rowsPerPage: _rowsPerPage,
                          onRowsPerPageChanged: (r) {
                            setState(() {
                              _rowsPerPage = r;
                            });
                          },
                        ),
                      );

                      /* ListView.builder(
                          shrinkWrap: true,
                          itemCount: tr.transactions.length,
                          itemBuilder: (context, idx) {
                            return buildTransactionTile(idx, tr.transactions[idx]);
                          },
                        ); */
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildTransactionTile(int idx, Transaction transaction) {
    return InkWell(
      onLongPress: () {
        editTransactionDialog(transaction);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        height: 70,
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "${transaction.date}".split(' ')[0],
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${transaction.detail}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Compte :",
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                "${transaction.compte}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Categorie :",
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                "${transaction.categorie}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(
                            "Entrée",
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            "${NumberFormat('#,##0.00').format(transaction.debit)}${_profile.um}",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(
                            "Sortie",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            "${NumberFormat('#,##0.00').format(transaction.credit)}${_profile.um}",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editTransactionDialog(Transaction transaction) {
    TextEditingController _controllerdate =
        TextEditingController(text: transaction.date);
    TextEditingController _controlleredit =
        TextEditingController(text: transaction.detail);
    TextEditingController _controllerdebit = TextEditingController(
        text: transaction.debit > 0 || transaction.debit < 0
            ? "${transaction.debit}"
            : null);
    TextEditingController _controllercredit = TextEditingController(
        text: transaction.credit > 0 || transaction.credit < 0
            ? "${transaction.credit}"
            : null);
    List<DropdownMenuItem<Compte>> _cptdrops = getCompteDrops(_comptes);

    Compte _selectedEditCompte =
        _comptes.firstWhere((element) => element.id == transaction.compte_id);
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Modifier Transaction"),
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
              // Navigator.of(context).pop(this);
              deleteTransaction(transaction.id, transaction.detail,
                  callBack: () {
                Navigator.of(context).pop(this);
              });
            },
            child: Text(
              "SUPPRIMER",
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(this);
            },
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.grey),
            ),
          ),
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
                      .raw_query(getUpdateTransaction(
                          transaction.id,
                          _selectedEditCompte.id,
                          _controllerdate.text,
                          _controlleredit.text,
                          _dr,
                          _cr,
                          _profile.id))
                      .whenComplete(() {
                    setState(() {
                      Provider.of<Transactions>(context, listen: false)
                          .loadTransactions(_profile.id);
                    });
                  });
                  Navigator.of(context).pop(this);
                } else {
                  log("Failing");
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
              "MODIFIER",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void deleteTransaction(int transaction_id, String transactionDetail,
      {Function callBack}) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Suppression de Transaction"),
        content: Text(
            "Vous êtes sur le point de supprimer la transaction \"$transactionDetail\". Supprimer ?"),
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
                  .raw_query(getDeleteTransaction(transaction_id, _profile.id))
                  .whenComplete(() {
                setState(() {
                  Provider.of<Transactions>(context, listen: false)
                      .loadComptes(_profile.id);
                });
              });
              if (callBack != null) callBack();
              Navigator.of(context).pop(this);
            },
            child: Text("SUPPRIMER"),
          ),
        ],
      ),
    );
  }
}

class TransactionData extends DataTableSource {
  final List<Transaction> trans;
  final Orientation orientation;
  final String um;
  final Function(Transaction) onThisTap;

  double _fontSize = 9.0;

  TransactionData(this.trans, this.orientation, this.um, {this.onThisTap});
  @override
  DataRow getRow(int index) {
    int _idx = index;
    return DataRow.byIndex(
      index: _idx,
      cells: [
        DataCell(SizedBox(
          width: 60,
          child: Text(
            "${trans[_idx].date}".split(' ')[0],
            style: TextStyle(fontSize: _fontSize),
          ),
        )),
        DataCell(SizedBox(
          width: 120,
          child: Text(
            "${trans[_idx].detail}",
            softWrap: true,
            style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w800),
          ),
        )),
        DataCell(SizedBox(
          width: 100,
          child: Text(
            "${trans[_idx].compte}",
            style: TextStyle(
                fontSize: _fontSize,
                color: colorPrimary,
                fontWeight: FontWeight.w800),
          ),
        )),
        if (orientation == Orientation.landscape)
          DataCell(SizedBox(
            width: 100,
            child: Text(
              "${trans[_idx].categorie}",
              style: TextStyle(
                  fontSize: _fontSize,
                  color: colorPrimary,
                  fontWeight: FontWeight.w800),
            ),
          )),
        DataCell(
          Text(
            trans[_idx].debit > trans[_idx].credit
                ? "${monnefy(trans[_idx].debit, um)}"
                : "${monnefy(trans[_idx].credit, um)}",
            style: TextStyle(
                fontSize: _fontSize,
                color: trans[_idx].debit > trans[_idx].credit
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w800),
          ),
          onTap: () {
            onThisTap(trans[_idx]);
          },
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trans.length;

  @override
  int get selectedRowCount => 0;
}
