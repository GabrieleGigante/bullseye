import 'dart:io';

import 'package:dartboard/dartboard.dart';
import 'package:dartboard/models/verb.dart';

void main(List<String> arguments) {
  // final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3030);
  // await for (HttpRequest request in server) {
  //   request.response.write('Hello from a Dart server');
  //   await request.response.close();
  // }

  final app = DartBoard(port: 4444);
  app.route(Method.GET, '/', handler: (Context c) => c.json(200, 'pong'));
  app.route(Method.GET, '/hello', handler: (Context c) {
    print('Hello!');
    c.json(Status.OK, "Hello");
  });
  app.route(Method.GET, '/world', handler: (Context c) {
    print('world!');
    c.json(Status.OK, "world!");
  });
  app.runHTTP();
}
