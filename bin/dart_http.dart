import 'dart:convert';

import 'package:dart_http/fetch.dart';
import 'package:http/http.dart' as http;

class HttpException implements Exception {
  int statusCode;

  HttpException({required this.statusCode});
}

class Post {
  late int userId;
  late int id;
  late String title;
  late String body;

  Post(
      {required this.userId,
      required this.id,
      required this.body,
      required this.title});

  Post.fromJSON(Map data) {
    id = data['id'];
    userId = data['userId'];
    title = data['title'];
    body = data['body'];
  }
}

Future<http.Response> get(Uri url) async {
  var response = await http.get(url);
  var statusCode = response.statusCode;

  if (statusCode >= 300 || statusCode < 200) {
    throw response;
  }
  return response;
}

void main(List<String> arguments) async {
  Uri uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  Fetch fetch = Fetch(uri: uri);

  fetch.get().then((value) {
    print("running success");
    return value;
  }).catchError((err) {
    if (err is http.Response) {
      print("Get error from catchError, Code: ${err.statusCode}");
    }
    return err;
  });

  try {
    var response = await get(uri);

    List<Post> result = [];
    json.decode(response.body).forEach((element) {
      result.add(Post.fromJSON(element));
    });
    print(result);
  } on http.Response catch (err) {
    print("Failed to get data, Code: ${err.statusCode}");
  }
}
