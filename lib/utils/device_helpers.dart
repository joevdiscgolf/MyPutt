import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class DeviceHelpers {
  static Future<bool> isPhysicalDevice() async {
    if (Platform.isIOS) {
      return deviceInfo.iosInfo.then((info) => info.isPhysicalDevice);
    } else if (Platform.isAndroid) {
      return deviceInfo.androidInfo
          .then((info) => info.isPhysicalDevice ?? false);
    } else {
      return false;
    }
  }
}
