
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/core/utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController _controlleremail = TextEditingController();
  TextEditingController _controllerpassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<LoginWatcher>(context, listen: false).tryLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    colorPrimaryLight,
                    colorPrimary,
                    colorPrimaryDark,
                  ])),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 50),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$app_name",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
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
                                      spreadRadius: 3)
                                ],
                                border:
                                    Border.all(width: 1.5, color: Colors.white),
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
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ouvrir Session",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 220,
              right: 50,
              left: 50,
              child: isLoading == false
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      // width: MediaQuery.of(context).size.width * 0.85,
                      height: 340,
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
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidate: true,
                              validator: (txt) {
                                return (txt.isEmpty || txt.contains("@"))
                                    ? ""
                                    : "email incorrect !";
                              },
                              controller: _controlleremail,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                prefixIcon: Icon(Icons.person),
                                labelText: "email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _controllerpassword,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                prefixIcon: Icon(Icons.lock),
                                labelText: "mot de passe",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                loginNow();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text("Ouvrir"),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            FlatButton(
                              onPressed: () {
                                launchRegisterForm();
                              },
                              child: Text(
                                "S'enregistrer",
                                style: TextStyle(color: colorSecond),
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
                          ))),
            ),
            Positioned(
                bottom: 30,
                left: 0,
                right: 0,
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
                ))),
          ],
        ),
      ),
    );
  }

  void launchRegisterForm() {
    Provider.of<LoginWatcher>(context, listen: false).logState = 2;
  }

  void loginNow() {
    setState(() {
      isLoading = true;
    });
    String email = _controlleremail.text;
    String upass = _controllerpassword.text;
    //log("$uname ==== $upass");
    if ((email != null && email.isNotEmpty) &&
        (upass != null && upass.isNotEmpty)) {
      // log("$uname ==== $upass");
      login2(
        email: email,
        password: upass,
        onLogin: (profile) {
          //log(profile.toString());
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
        },
      );
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
}
