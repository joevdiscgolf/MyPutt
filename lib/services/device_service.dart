import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class DeviceService {
  DeviceService() {
    _loadDeviceId();
  }

  void _loadDeviceId() async {
    _deviceId = await _getId();
  }

  String? _deviceId;

  String? get getDeviceId => _deviceId;

  static Future<bool> isPhysicalDevice() async {
    if (Platform.isIOS) {
      return deviceInfo.iosInfo.then((info) => info.isPhysicalDevice);
    } else if (Platform.isAndroid) {
      return deviceInfo.androidInfo.then((info) => info.isPhysicalDevice);
    } else {
      return false;
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
