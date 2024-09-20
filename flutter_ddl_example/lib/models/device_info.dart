import 'dart:io';
import 'package:flutter/material.dart';
import 'package:public_ip_address/public_ip_address.dart';

class DeviceInfo {
  late int deviceWidth;
  late int deviceHeight;
  late String ip;
  late String os;
  late DateTime timestamp;

  DeviceInfo({
    required this.deviceWidth,
    required this.deviceHeight,
    required this.ip,
    required this.os,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'deviceWidth': deviceWidth,
        'deviceHeight': deviceHeight,
        'ip': ip,
        'os': os,
        'timestamp': timestamp.toIso8601String(),
      };

  int getDeviceWidth(BuildContext context) {
    final Size size = View.of(context).physicalSize;
    int width = size.width.toInt();
    return width;
  }

  int getDeviceHeight(BuildContext context) {
    final Size size = View.of(context).physicalSize;
    int height = size.height.toInt();
    return height;
  }

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
}
