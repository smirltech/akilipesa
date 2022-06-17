import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/models/Categorie.dart';
import 'package:akilipesa/application/models/Compte.dart';
import 'package:akilipesa/application/models/Transaction.dart';
import 'package:akilipesa/application/models/Type.dart';

import 'dbm.dart';

class Transactions with ChangeNotifier {
  bool _init = false;
  List<Type> types = List<Type>();
  List<Categorie> categories = List<Categorie>();
  List<Compte> comptes = List<Compte>();

  List<Transaction> transactions = List<Transaction>();

  double sumIncome = 0.0;
  double sumExpenses = 0.0;
  double sumSolde = 0.0;

  loadTypes() async {
    // log("${getAllTypes()} === $SQL_URL");
    DBM.raw_query(getAllTypes()).then((value) {
      // log(value.body);
      List<dynamic> mm = jsonDecode(value.body);
      types = mm.map((e) => Type.fromMap(e)).toList();
      //notifyListeners();
    }).catchError((err) {
      log(err.toString());
    });
  }

  loadCategories(int userid) async {
    //log("logging categories");
    DBM.raw_query(getAllCategories(userid)).then((value) {
      //log(value.body);
      List<dynamic> mm = jsonDecode(value.body);
      categories = mm.map((e) => Categorie.fromMap(e)).toList();
      //notifyListeners();
    });
  }

  loadComptes(int userid) async {
    //log("logging comptes with userid : $userid");
    DBM.raw_query(getAllComptes(userid)).then((value) {
      // log(value.body);
      List<dynamic> mm = jsonDecode(value.body);
      comptes = mm.map((e) => Compte.fromMap(e)).toList();
      //notifyListeners();
    });
  }

  void loadTransactions(int userid) async {
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      DBM.raw_query(getAllTransactions(userid)).then((value) {
        //log(value.body);
        List<dynamic> mm = jsonDecode(value.body);
        transactions = mm.map((e) => Transaction.fromMap(e)).toList();
        //log(transactions.toString());
        presetAll();
        notifyListeners();
      });
    }
  }

  void sumAll() {
    sumIncome = 0.0;
    sumExpenses = 0.0;
    types.forEach((element) {
      element.credit = 0.0;
      element.debit = 0.0;
    });

    categories.forEach((element) {
      element.credit = 0.0;
      element.debit = 0.0;
    });

    transactions.forEach((transaction) {
      sumIncome += transaction.debit;
      sumExpenses += transaction.credit;
      Type _type =
          types.singleWhere((element) => element.id == transaction.type_id);
      _type.debit += transaction.debit;
      _type.credit += transaction.credit;
    });
    sumSolde = sumIncome - sumExpenses;
  }

  List<Categorie> categoriesPerType(int type_id) {
    return categories.where((element) => element.type_id == type_id).toList();
  }

  void presetAll() async {
    sumAll();
  }

  void refreshThem(int userid) async {
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      loadTypes();
      loadCategories(userid);
      loadComptes(userid);
    }
  }

  initTransactions(int userid) {
    if (!_init) {
      loadTypes();
      loadCategories(userid);
      loadComptes(userid);

      refreshThem(userid);
      loadTransactions(userid);
      _init = true;
    }
  }
}
