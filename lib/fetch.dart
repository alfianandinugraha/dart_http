import 'package:http/http.dart' as http;

class Fetch {
  Uri uri;

  Fetch({required this.uri});

  static bool isSuccess(int statusCode) =>
      statusCode >= 300 || statusCode < 200;

  Future<http.Response> get() async {
    var response = await http.get(uri);
    var statusCode = response.statusCode;

    if (Fetch.isSuccess(statusCode)) throw response;

    return response;
  }
}
