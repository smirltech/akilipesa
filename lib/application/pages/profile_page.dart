import 'package:akilipesa/application/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/core/presets.dart';
import 'package:akilipesa/application/dialogs/password_modif_dialog.dart';
import 'package:akilipesa/application/models/Profile.dart';
import 'package:akilipesa/application/pages/home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  int _selectedNavBarItem = 4;

  @override
  void initState() {
    super.initState();

    Provider.of<LoginWatcher>(context, listen: false).profile;
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
      child: Consumer<LoginWatcher>(builder: (_, pw, __) {
        Profile prof = pw.profile;
        return Scaffold(
          key: this._scaffoldState,
          floatingActionButton: FloatingActionButton(
              mini: true,
              backgroundColor: colorPrimary,
              child: Icon(FontAwesome.eye),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildDetailBottomSheet(prof.bio),
                );
              }),
          //  bottomNavigationBar: buildBottomAppBar(context, _selectedNavBarItem),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      colorPrimaryLight,
                      colorPrimary,
                      colorPrimaryDark,
                    ])),
                    child: SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  profileIcon,
                                  color: Colors.white,
                                ),
                                Text(
                                  "$app_name",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    /* IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: default_icon_size,
                                      ),
                                      onPressed: () {},
                                    ), */
                                    GestureDetector(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text(
                                                "Se Déconnecter",
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                  "Vous êtes au point de vous déconnecter, Continuer?"),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "ANNULER",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Provider.of<LoginWatcher>(
                                                            context,
                                                            listen: false)
                                                        .logoutNow();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "DÉCONNECTER",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ));
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        //Navigator.of(context).pop(this);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SettingsPage()),
                                        );
                                      },
                                      child: Icon(
                                        Linecons.money,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
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
                                      backgroundImage: AssetImage(
                                          "assets/images/ic_launcher.png"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${prof.nomComplet}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        /* Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ), */
                                        Text(
                                          "${prof.email}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            FontAwesome5.user_edit,
                                            color: Colors.white,
                                            size: default_icon_size,
                                          ),
                                          onTap: () => passwordModifierDialog(
                                              context,
                                              prof.id,
                                              prof.email,
                                              prof.password, onDone: (profile) {
                                            /*  Provider.of<LoginWatcher>(context,
                                                    listen: false)
                                                .profile = profile; */
                                          }),
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
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ListView(
                                /*  gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2), */
                                children: [
                                  //row 0
                                  HeadedTile(
                                    title: Text(
                                      "${prof.prenom}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "Prenom",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),

                                  HeadedTile(
                                    title: Text(
                                      "${prof.nom}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "Nom",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),
                                  //row 1
                                  HeadedTile(
                                    title: Text(
                                      (prof.sexe == 'm') ? 'Homme' : 'Femme',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "Sexe",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),
                                  HeadedTile(
                                    title: Text(
                                      "${prof.email}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "email",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),

                                  //row 2
                                  HeadedTile(
                                    title: Text(
                                      "${prof.last_login}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "Dernière Connexion",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),

                                  HeadedTile(
                                    title: Text(
                                      "${prof.created}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      "Créé",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    headerColor: colorPrimary.withOpacity(0.6),
                                    footerColor: colorPrimaryLight,
                                  ),
                                ],
                                //GridTile(child: null),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailBottomSheet(String description) {
    return Card(
      child: Container(
        color: colorPrimaryLight.withOpacity(0.4),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "QUI JE SUIS:",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Divider(
                thickness: 1,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(description),
            ),
          ],
        ),
      ),
    );
  }
}
