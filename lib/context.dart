import 'dart:convert';
import 'dart:io';

import 'package:dartboard/models/http_types.dart';

class Context {
  HttpResponse response;
  HttpRequest request;
  int handlerIndex = 0;
  List<Handler> handlers = [];
  Map<String, String> urlParam;
  Map<String, String> queryParam;
  Map<String, dynamic> keys;
  Context({
    required this.response,
    required this.request,
    required this.urlParam,
    required this.queryParam,
    required this.keys,
  });

  void json(int s, dynamic data) async {
    response.statusCode = s;
    try {
      response.write(data.toJson());
    } catch (_) {
      response.write(jsonEncode(data));
    }
    await end();
  }

  void send(int s, String data) async {
    response.statusCode = s;
    response.write(data);
    await end();
  }

  String param(String key) {
    return urlParam[key] ?? '';
  }

  String query(String key) {
    return queryParam[key] ?? '';
  }

  void start() {
    while (handlerIndex < handlers.length) {
      handlers[handlerIndex](this);
      handlerIndex++;
    }
  }

  void next() {
    handlerIndex++;
    start();
  }

  Future<void> end() async {
    handlerIndex = handlers.length;
    await request.response.close();
  }
}
