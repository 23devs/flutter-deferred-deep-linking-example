// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/device_info.dart';
import '../models/server_error.dart';
import '../models/url_details.dart';
import 'api_helper.dart';

class DeviceInfoClient {
  static const String urlAccessDatasUrl = 'url-access-datas';
  static const String checkUrlAccessDatasUrl = '$urlAccessDatasUrl/check';

  static Future<UrlDetails> checkDeviceInfo() async {
    try {
      final DeviceInfo info = DeviceInfo();
      await info.setDeviceInfo();

      final http.Response response = await http
          .post(
            ApiHelper.buildUri(checkUrlAccessDatasUrl),
            headers: ApiHelper.buildHeaders(),
            body: jsonEncode(info),
          )
          .timeout(const Duration(seconds: ApiHelper.timeoutDuration));
      if (response.statusCode == HttpStatus.ok) {
        return UrlDetails.fromJson(jsonDecode(response.body));
      } else {
        ServerError error = ServerError.fromJson(jsonDecode(response.body));
        throw ServerException(message: error.message);
      }
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Unable to set connection');
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
