// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfo {
  int? screenWidth;
  String? os;
  String? version;

  DeviceInfo({this.screenWidth, this.os, this.version});

  Map<String, dynamic> toJson() => {
        'screenWidth': screenWidth,
        'os': os,
        'version': os,
      };

  int getDeviceWidth() {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize;
    int width = (size.width / view.devicePixelRatio).toInt();
    return width;
  }

  String getDeviceOS() {
    if (Platform.isAndroid) {
      return 'android';
    }
    return 'ios';
  }

  Future<String> getVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String version = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      version = androidInfo.version.release;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      version = iosInfo.systemVersion;
    }

    print('Running on $version');

    return version;
  }

  Future<void> setDeviceInfo() async {
    screenWidth = getDeviceWidth();
    os = getDeviceOS();
    version = await getVersion();
  }
}
