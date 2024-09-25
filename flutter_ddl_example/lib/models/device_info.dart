import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:public_ip_address/public_ip_address.dart';

class DeviceInfo {
  int? deviceWidth;
  //int? deviceHeight;
  String? ip;
  String? os;
  String? timestamp;

  DeviceInfo({
    this.deviceWidth,
    //this.deviceHeight,
    this.ip,
    this.os,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'deviceWidth': deviceWidth,
        // 'deviceHeight': deviceHeight,
        'ip': ip,
        'os': os,
        'timestamp': timestamp,
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
    //deviceHeight = getDeviceHeight();
    os = getDeviceOS();
    ip = await getPublicIP();
    timestamp = getTimeStamp();
  }
}
