import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:smirl_version_checker/nv/device_app_infos.dart';

class AppInfo extends GetxController {
  var appInfo = <String, dynamic>{}.obs;

// Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    Map<String, dynamic> info = await DeviceAppInfos.appInfo.getInfo();

    appInfo['platformVersion'] = info["version"];
    appInfo['projectVersion'] = info["version"];
    appInfo['projectCode'] = info["buildNumber"];
    appInfo['projectAppID'] = info["idName"];
    appInfo['projectName'] = info["appName"];
  }

  @override
  onInit() async {
    super.onInit();
    _initPlatformState();
  }
}
