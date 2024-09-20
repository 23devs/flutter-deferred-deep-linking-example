import 'dart:io';
import 'package:flutter/material.dart';
import 'package:public_ip_address/public_ip_address.dart';

class DeviceInfo {
  int? deviceWidth;
  int? deviceHeight;
  String? ip;
  String? os;
  String? timestamp;

  DeviceInfo({
    this.deviceWidth,
    this.deviceHeight,
    this.ip,
    this.os,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'deviceWidth': deviceWidth,
        'deviceHeight': deviceHeight,
        'ip': ip,
        'os': os,
        'timestamp': timestamp,
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

  Future<void> setDeviceInfo(BuildContext context) async {
    deviceWidth = getDeviceWidth(context);
    deviceHeight = getDeviceHeight(context);
    os = getDeviceOS();
    ip = await getPublicIP();
    timestamp = getTimeStamp();
  }
}
