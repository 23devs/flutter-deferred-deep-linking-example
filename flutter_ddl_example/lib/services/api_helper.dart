class ApiHelper {
  static const int timeoutDuration = 10;
  static const String apiPath = '/api/';
  static const String _scheme = 'https';
  static const String _host = 'api-mobile-apps-examples.23devs.com';
  static int? _port;

  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    return headers;
  }

  static Uri buildUri(String subpath, [bool isApi = true]) {
    final String path = isApi ? '$apiPath$subpath' : subpath;
    return Uri(
      scheme: _scheme,
      host: _host,
      port: _port,
      path: path,
    );
  }

  static Uri buildUriWithParams(
    String subpath,
    Map<String, String> queryParameters,
  ) {
    return Uri(
      scheme: _scheme,
      host: _host,
      port: _port,
      path: '$apiPath$subpath',
      queryParameters: queryParameters,
    );
  }
}
