// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/device_info.dart';
import 'api_helper.dart';

class DeviceInfoClient {
  static const String deviceInfosUrl = 'device-infos';
  static const String setInfoUrl = '$deviceInfosUrl/check';

  static Future<bool> checkDeviceInfo(BuildContext context) async {
    try {
      final DeviceInfo info = DeviceInfo();
      await info.setDeviceInfo(context);

      print(info.deviceHeight);
      print(info.deviceWidth);
      print(info.os);
      print(info.ip);
      print(info.timestamp);

      final http.Response response = await http
          .post(
            ApiHelper.buildUri(setInfoUrl),
            headers: ApiHelper.buildHeaders(),
            body: jsonEncode(info),
          )
          .timeout(const Duration(seconds: ApiHelper.timeoutDuration));
      if (response.statusCode == HttpStatus.ok) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Error();
    }
  }
}
