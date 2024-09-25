import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:public_ip_address/public_ip_address.dart';

class DeviceInfo {
  int? deviceWidth;
  String? ip;
  String? os;

  DeviceInfo({
    this.deviceWidth,
    this.ip,
    this.os,
  });

  Map<String, dynamic> toJson() => {
        'deviceWidth': deviceWidth,
        // 'deviceHeight': deviceHeight,
        'ip': ip,
        'os': os,
      };

  int getDeviceWidth() {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Dimensions in logical pixels (dp)
    Size size = view.physicalSize;
    int width = (size.width / view.devicePixelRatio).toInt();
    return width;
  }

  // int getDeviceHeight() {
  //   FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  //   // Dimensions in logical pixels (dp)
  //   Size size = view.physicalSize;
  //   int height = (size.height / view.devicePixelRatio).toInt();
  //   return height;
  // }

  Future<String> getPublicIP() async {
    return await IpAddress().getIp();
  }

  String getDeviceOS() {
    if (Platform.isAndroid) {
      return 'android';
    }
    return 'ios';
  }

  String getTimeStamp() {
    return DateTime.now().toUtc().toIso8601String();
  }

  Future<void> setDeviceInfo() async {
    deviceWidth = getDeviceWidth();
    os = getDeviceOS();
    ip = await getPublicIP();
  }
}
