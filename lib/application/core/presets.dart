import 'dart:developer';
import 'dart:io';

import 'package:akilipesa/application/models/Monnaie.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/models/Categorie.dart';
import 'package:akilipesa/application/models/Compte.dart';
import 'package:akilipesa/application/models/Type.dart';
import 'package:intl/intl.dart';

class HeadedTile extends StatelessWidget {
  const HeadedTile({
    Key key,
    this.title,
    this.subtitle,
    this.headerColor,
    this.content,
    this.contentColor,
    this.footerColor,
  }) : super(key: key);
  final Text title;
  final Text content;
  final Text subtitle;
  final Color headerColor;
  final Color contentColor;
  final Color footerColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      /* decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70),
          bottomLeft: Radius.circular(70),
        ),
        color: Colors.white,
      ), */
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(5),
                  ),
                  color: headerColor,
                ),
                child: title,
              ),
            if (content != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                color: contentColor?.withOpacity(0.15),
                child: content,
              ),
            if (subtitle != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: footerColor?.withOpacity(0.15),
                ),
                child: subtitle,
              ),
          ],
        ),
      ),
    );
  }
}

String monnefy(double amount, String um){
  return "${NumberFormat('#,##0.00').format(amount)}$um";
}

String doesCategorieExist(String cat, List<Categorie> categories) {
  List<Categorie> _categories = categories
      .where((element) => element.nom.toLowerCase() == cat.toLowerCase())
      .toList();
  return _categories.length > 0 ? "$cat existe déjà !" : null;
}

String doesCompteExist(String cpt, List<Compte> comptes) {
  List<Compte> _comptes = comptes
      .where((element) => element.nom.toLowerCase() == cpt.toLowerCase())
      .toList();
  return _comptes.length > 0 ? "$cpt existe déjà !" : null;
}

List<DropdownMenuItem<Categorie>> getCategorieDrops(List<Categorie> categs) {
  List<DropdownMenuItem<Categorie>> ddm = List<DropdownMenuItem<Categorie>>();
  categs.forEach((element) {
    ddm.add(DropdownMenuItem<Categorie>(
      child: buildDropItem(element.nom, element.type),
      value: element,
    ));
  });
  return ddm;
}

List<DropdownMenuItem<Type>> getTypeDrops(List<Type> types) {
  List<DropdownMenuItem<Type>> ddm = List<DropdownMenuItem<Type>>();
  types.forEach((element) {
    ddm.add(DropdownMenuItem<Type>(
      child: Text(element.nom),
      value: element,
    ));
  });
  return ddm;
}

List<DropdownMenuItem<Compte>> getCompteDrops(List<Compte> comptes) {
  List<DropdownMenuItem<Compte>> ddm = List<DropdownMenuItem<Compte>>();
  comptes.forEach((element) {
    ddm.add(DropdownMenuItem<Compte>(
      child: buildDropItem(element.nom, element.categorie),
      value: element,
    ));
  });
  return ddm;
}

List<DropdownMenuItem<Monnaie>> getMonnaiesDrops(List<Monnaie> monnaies) {
  List<DropdownMenuItem<Monnaie>> ddm = List<DropdownMenuItem<Monnaie>>();
  monnaies.forEach((element) {
    ddm.add(DropdownMenuItem<Monnaie>(
      child: buildDropItem(element.um, element.um),
      value: element,
    ));
  });
  return ddm;
}

Widget buildDropItem(String text1, String text2) {
  return Container(
    margin: EdgeInsets.all(1),
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.blueGrey.withOpacity(0.01),
      boxShadow: [
        BoxShadow(
          color: black01,
          blurRadius: 8,
          spreadRadius: 3,
        )
      ],
      //border: Border.all(width: 1.5, color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            text1,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            "($text2)",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, color: Colors.deepOrange),
          ),
        ),
      ],
    ),
  );
}

Future<bool> isInternetReachable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) return true;

  return false;
}

Future<bool> isInternetReachable2() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    //log("This 2 true");
  } on SocketException catch (_) {
    //log("This 2 false");
    return false;
  }
  return false;
}
