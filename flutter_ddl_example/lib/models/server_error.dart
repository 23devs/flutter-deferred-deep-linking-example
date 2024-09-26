class ServerError {
  int status;
  String name;
  String message;
  Object details;

  ServerError({
    required this.status,
    required this.name,
    required this.message,
    required this.details,
  });

  ServerError.fromJson(Map<String, dynamic> json)
      : status = json['error']['status'],
        name = json['error']['name'],
        message = json['error']['message'],
        details = json['error']['details'];
}

class ServerException implements Exception {
  final String message;

  ServerException({
    required this.message,
  });
}
