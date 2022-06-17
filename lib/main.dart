import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akilipesa/application/app.dart';
import 'package:akilipesa/application/controllers/Transactions.dart';
import 'package:akilipesa/application/controllers/app_info.dart';
import 'package:akilipesa/application/controllers/login_watcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppInfo()),
      ChangeNotifierProvider.value(value: LoginWatcher()),
      ChangeNotifierProvider.value(value: Transactions()),
    ],
    child: App(),
  ));
}
