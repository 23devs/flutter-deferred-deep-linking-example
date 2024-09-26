class UrlDetails {
  String url;

  UrlDetails({
    required this.url,
  });

  UrlDetails.fromJson(Map<String, dynamic> json) : url = json['url'];
}
