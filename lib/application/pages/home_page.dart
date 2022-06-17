import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/core/utils.dart';
import 'package:akilipesa/application/models/Categorie.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavBarItem = 2;
  Profile _profile;

  @override
  void initState() {
    super.initState();

    _profile = Provider.of<LoginWatcher>(context, listen: false).profile;
    Provider.of<Transactions>(context, listen: false)
        .initTransactions(_profile.id);
  }

  Widget buildCategorieCard(Categorie categorie, IconData icon, String title,
      double amount, double percentage,
      {Color z0, Color z1, Color z2, Color z3}) {
    Color _z0 = z0 != null ? z0 : colorPrimaryDark;
    Color _z1 = z1 != null ? z1 : colorPrimary;
    Color _z2 = z2 != null ? z2 : colorPrimaryLight;
    Color _z3 = z3 != null ? z3 : colorSecondaryLight;
    double percy = percentage.isNaN ? 0 : percentage;
    String perc = percy.toStringAsFixed(2);
    String amt = amount.toStringAsFixed(2);

    //log("percentage : $percentage");

    return GestureDetector(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoriePage(
                    categorie: categorie,
                  )),
        ); */
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: _z1,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _z0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${NumberFormat('#,##0.00').format(double.parse(amt))}${_profile.um}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _z0,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "($perc%)",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _z2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _z3,
                  ),
                ),
                Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * percy / 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _z1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActivityButton(
      IconData icon, String title, Color backgroundColor, Color iconColor,
      {int number = 0, Function onClick}) {
    return InkWell(
      onTap: () {
        if (onClick != null) onClick();
      },
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(5),

          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                badgeContent: Text(
                  "$number",
                  style: TextStyle(color: Colors.white),
                ),
                showBadge: number > 0,
                child: Icon(
                  icon,
                  color: iconColor,
                  //size: 48,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> putCategoriesTogether(List<Categorie> _list, double sum,
      {Color z0, Color z1, Color z2, Color z3}) {
    List<Widget> list = List<Widget>();

    list = _list
        .map((cat) => buildCategorieCard(cat, categoriesIcon, cat.nom,
            cat.solde.abs(), (cat.solde.abs() * 100 / sum),
            z0: z0, z1: z1, z2: z2, z3: z3))
        .toList();
    //log("list size: ${_list.length}");
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          child: AlertDialog(
            content: Text("Voulez-vous quitter l'application ?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("ANNULER"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("QUITTER"),
              ),
            ],
          )),
      child: Scaffold(
        floatingActionButton: SpeedDial(
          child: Icon(Icons.add),
          closedForegroundColor: Colors.white,
          closedBackgroundColor: colorPrimary,
          openForegroundColor: Colors.black,
          openBackgroundColor: colorPrimaryLight,
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
                backgroundColor: colorFirst,
                child: Icon(Icons.list),
                label: "Categorie",
                onPressed: () {
                  addCategorieDialog(
                      context,
                      Provider.of<Transactions>(context, listen: false)
                          .categories,
                      Provider.of<Transactions>(context, listen: false).types,
                      _profile.id);
                }),
            SpeedDialChild(
                backgroundColor: Colors.blue,
                child: Icon(Icons.account_balance_wallet),
                label: "Compte",
                onPressed: () {
                  addCompteDialog(
                      context,
                      Provider.of<Transactions>(context, listen: false).comptes,
                      Provider.of<Transactions>(context, listen: false)
                          .categories,
                      _profile.id);
                }),
            SpeedDialChild(
                backgroundColor: Colors.green,
                child: Icon(Icons.swap_vert),
                label: "Transaction",
                onPressed: () {
                  addTransactionDialog(
                      context,
                      Provider.of<Transactions>(context, listen: false).comptes,
                      _profile.id);
                }),
          ],
        ),
        // bottomNavigationBar: buildBottomAppBar(context, _selectedNavBarItem),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    colorPrimaryLight,
                    colorPrimary,
                    colorPrimaryDark,
                  ])),
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 1,
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Row(
                                children: [],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  color: colorPrimaryLight,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black01,
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                    )
                                  ],
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Hero(
                                  tag: "1001",
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/ic_launcher.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cash disponible",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Linecons.money,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Consumer<Transactions>(
                                        builder: (_, tr, __) => RichText(
                                            text: TextSpan(
                                                text:
                                                    "${NumberFormat('#,##0').format(tr.sumSolde.toInt())}",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                                children: [
                                              TextSpan(
                                                text:
                                                    ".${tr.sumSolde.toString().split('.')[1].substring(0, 1)}0${_profile.um}",
                                                style: TextStyle(
                                                    color: Colors.white38),
                                              ),
                                            ])),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.grey.shade200,
                    child: ListView(
                      padding: EdgeInsets.only(top: 60),
                      children: [
                        Text(
                          "Entrées",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                        ),
                        Consumer<Transactions>(
                          builder: (_, tr, __) {
                            //log(tr.types.toString());
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: putCategoriesTogether(
                                  tr.categoriesPerType(1), tr.sumIncome,
                                  z0: Colors.green.shade900,
                                  z1: Colors.green,
                                  z2: Colors.green.withOpacity(0.7),
                                  z3: Colors.green.withOpacity(0.2)),
                            );
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Sorties",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                        ),
                        Consumer<Transactions>(
                          builder: (_, tr, __) {
                            //log(tr.types.toString());
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: putCategoriesTogether(
                                  tr.categoriesPerType(2), tr.sumExpenses,
                                  z0: Colors.red.shade900,
                                  z1: Colors.red,
                                  z2: Colors.red.withOpacity(0.7),
                                  z3: Colors.red.withOpacity(0.2)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 160,
              right: 0,
              child: buildRDContainer(context),
            ),
          ],
        ),
      ),
    );
  }

  Container buildRDContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.90,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        /*gradient: LinearGradient(
          colors: [
            Colors.white,
            colorPrimaryLight,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),*/
        boxShadow: [
          BoxShadow(
            color: black005,
            blurRadius: 8,
            spreadRadius: 3,
            offset: Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<Transactions>(
            builder: (_, tr, __) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Recettes",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.green.shade600,
                              //size: 14,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${NumberFormat('#,##0.00').format(tr.sumIncome)}${_profile.um}",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dépenses",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                              //size: 14,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${NumberFormat('#,##0.00').format(tr.sumExpenses)}${_profile.um}",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "Lire suite >>",
              style: TextStyle(
                  color: colorPrimary,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
