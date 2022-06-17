import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';
import 'package:akilipesa/application/pages/home_page.dart';
import 'package:akilipesa/application/pages/login_page.dart';
import 'package:akilipesa/application/pages/pages_selector_page.dart';
import 'package:akilipesa/application/pages/register_page.dart';
import 'package:akilipesa/application/pages/splash_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginWatcher>(context, listen: false).tryLogin(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SplashPage(),
      home: Consumer<LoginWatcher>(
        builder: (_, lw, __) {
          switch (lw.logState) {
            case 0:
              return LoginPage();
            case 1:
              return PagesSelectorPage();
            case 2:
              return RegisterPage();
            //return HomePage();
            default:
              return SplashPage();
          }
        },
      ),
    );
  }
}
