// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/device_info.dart';
import 'api_helper.dart';

class DeviceInfoClient {
  static const String urlAccessDatasUrl = 'url-access-datas';
  static const String checkUrlAccessdatasUrl = '$urlAccessDatasUrl/check';

  static Future<void> checkDeviceInfo() async {
    try {
      final DeviceInfo info = DeviceInfo();
      await info.setDeviceInfo();

      print(info.screenWidth);
      print(info.os);
      print(info.version);

      await http
          .post(
            ApiHelper.buildUri(checkUrlAccessdatasUrl),
            headers: ApiHelper.buildHeaders(),
            body: jsonEncode(info),
          )
          .timeout(const Duration(seconds: ApiHelper.timeoutDuration));
    } catch (e) {
      print(e.toString());
      throw Error();
    }
  }
}
