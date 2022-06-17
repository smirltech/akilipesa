import 'dart:convert';
import 'dart:developer';

import 'package:akilipesa/application/models/Monnaie.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/custom_sqls.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/dbm.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/models/Profile.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  bool isLoading = false;

  TextEditingController _controllerpassword = TextEditingController();

  TextEditingController _controllernom = TextEditingController();
  TextEditingController _controllerprenom = TextEditingController();

  TextEditingController _controllerbio = TextEditingController();
  TextEditingController _controlleremail = TextEditingController();

  //List<DropdownMenuItem<Monnaie>> _mntdrops;
  List<Monnaie> _monnaies;

  String _sex = 'm';
  Monnaie _monnaie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<LoginWatcher>(context, listen: false).tryLogin(context);
    _monnaies = Provider.of<LoginWatcher>(context, listen: false).monnaies;
    _monnaie = _monnaies.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
   // _monnaies = Provider.of<LoginWatcher>(context, listen: false).monnaies;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            colorPrimaryLight,
            colorPrimary,
            colorPrimaryDark,
          ])),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      color: Colors.white,
                      onPressed: () => launchLoginForm(),
                    ),
                    Text(
                      "$app_name",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
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
                              color: black01, blurRadius: 8, spreadRadius: 3)
                        ],
                        border: Border.all(width: 1.5, color: Colors.white),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Hero(
                        tag: "1001",
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/s_logo1.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enregistrement",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: isLoading == false
                      ? Container(
                          // height: 500,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Form(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidate: true,
                                          validator: (txt) {
                                            return (txt.isEmpty ||
                                                    txt.contains("@"))
                                                ? ""
                                                : "email incorrect !";
                                          },
                                          controller: _controlleremail,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            prefixIcon:
                                                Icon(Icons.account_circle),
                                            labelText: "email",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _controllerpassword,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            prefixIcon: Icon(Icons.lock),
                                            labelText: "password",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    //height: 20,
                                    ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _controllerprenom,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            prefixIcon: Icon(Icons.edit),
                                            labelText: "Prenom",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _controllernom,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            prefixIcon: Icon(Icons.edit),
                                            labelText: "Nom",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField(
                                          value: _sex,
                                          onChanged: (sex) {
                                            _sex = sex;
                                            log("Sexe changed to $sex");
                                          },
                                          //controller: _controllernom,
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(
                                                "Homme",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              value: 'm',
                                            ),
                                            DropdownMenuItem(
                                              child: Text(
                                                "Femme",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              value: 'f',
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            // prefixIcon: Icon(Icons.person),
                                            labelText: "Sexe",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    // height: 20,
                                    ),
                                Expanded(
                                  child: TextField(
                                    controller: _controllerbio,
                                    maxLines: 20,
                                    minLines: 19,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.chat),
                                      labelText: "Biographie",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    registerNow();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text("Enregistrer"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            height: 100,
                            width: 120,
                            //padding: EdgeInsets.all(100),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Connexion en cours, veuillez patienter...!",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "$quote1",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "$website",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "$app_version",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerNow() {
    setState(() {
      isLoading = true;
    });

    String upass = _controllerpassword.text;

    String _nom = _controllernom.text;
    String _prenom = _controllerprenom.text;

    String _msex = _sex;
    String _bio = _controllerbio.text;
    String _email = _controlleremail.text;
    //log("$uname ==== $upass");
    if ((_email != null && _email.isNotEmpty) &&
        (upass != null && upass.isNotEmpty)) {
      // log("$uname ==== $upass");
      DBM
          .base_query(A_REGISTER_URL,
              getSaveProfile(_email, upass, _nom, _prenom, _msex, _bio))
          .then((value) {
        log(value.body);
        Profile profile = Profile.fromMap(jsonDecode(value.body));
        setState(() {
          isLoading = false;
        });
        if (profile != null) {
          profile.saveProfile();
          Provider.of<LoginWatcher>(context, listen: false).profile = profile;
          Provider.of<Transactions>(context, listen: false)
              .initTransactions(profile.id);
          Provider.of<LoginWatcher>(context, listen: false).logState = 1;
        } else
          Provider.of<LoginWatcher>(context, listen: false).logState = 0;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Login Error"),
          content: Text("Check username or password and try to log in again"),
        ),
      );
    }
  }

  void launchLoginForm() {
    Provider.of<LoginWatcher>(context, listen: false).logState = 0;
  }





  List<DropdownMenuItem> buildDroppy(List<Monnaie> monn) {
    return monn
        .map(
          (elem) => DropdownMenuItem(
            child: Text("${elem.um}"),
            value: elem,
          ),
        )
        .toList();
  }
}
