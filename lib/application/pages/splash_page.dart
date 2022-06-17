import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/configs/color_presets.dart';
import 'package:akilipesa/application/configs/inits.dart';
import 'package:akilipesa/application/controllers/app_info.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Map<String, String> appInfo;

  @override
  void initState() {
    appInfo = Provider.of<AppInfo>(context, listen: false).appInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 170,
            right: 50,
            left: 50,
            child: Center(
                child: Container(
                    //height: 180,
                    // width: 180,
                    //padding: EdgeInsets.all(100),
                    child: Column(
              children: [
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    // color: colorPrimaryLight,
                    gradient: SweepGradient(colors: [
                      Colors.red,
                      Colors.green,
                      Colors.yellow,
                      Colors.amber
                    ]),
                    boxShadow: [
                      BoxShadow(color: black01, blurRadius: 8, spreadRadius: 3)
                    ],
                    border: Border.all(width: 1.5, color: Colors.white),
                    borderRadius: BorderRadius.circular(150.0),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Hero(
                    tag: "1001",
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/s_logo1.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                LinearProgressIndicator(
                  minHeight: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Connexion en cours, veuillez patienter...!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
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
                  /* Text(
                    "${appInfo['projectVersion']}(${appInfo['projectCode']})",
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ), */
                ],
              ))),
        ],
      ),
    );
  }
}
