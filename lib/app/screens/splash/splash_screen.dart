import 'package:akilipesa/app/controllers/app_info.dart';
import 'package:akilipesa/system/configs/color_presets.dart';
import 'package:akilipesa/system/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppInfo ai = Get.find<AppInfo>();

  @override
  void initState() {
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
                          Obx(() {
                            return Text(
                              "${ai.appInfo["projectName"]}",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            );
                          }),
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
                    gradient: const SweepGradient(colors: [
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
                  padding: const EdgeInsets.all(5),
                  child: const Hero(
                    tag: "1001",
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/s_logo1.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const LinearProgressIndicator(
                  minHeight: 5,
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
                    quote1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    website,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Obx(() {
                    return Text(
                      "${ai.appInfo['projectVersion']}(${ai.appInfo['projectCode']})",
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    );
                  }),
                ],
              ))),
        ],
      ),
    );
  }
}
