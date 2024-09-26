import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

class DeviceInfo {
  int? deviceWidth;
  String? os;

  DeviceInfo({
    this.deviceWidth,
    this.os,
  });

  Map<String, dynamic> toJson() => {
        'deviceWidth': deviceWidth,
        'os': os,
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

  Future<void> setDeviceInfo() async {
    deviceWidth = getDeviceWidth();
    os = getDeviceOS();
  }
}
