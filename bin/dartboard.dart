import 'dart:io';

import 'package:dartboard/dartboard.dart';
import 'package:dartboard/http_types.dart';

void main(List<String> arguments) {
  final app = DartBoard(port: 5555);
  app.route(HttpMethod.GET, '/', handler: rootFunction);
  app.route(HttpMethod.GET, '/hello', handler: (Context c) {
    print('Hello!');
    c.json(HttpStatus.ok, "Hello");
  });
  app.route(HttpMethod.GET, '/world', handler: (Context c) {
    print('world!');
    c.json(HttpStatus.ok, "world!");
  });
  app.runHTTP();
}

final rootFunction = (Context c) {
  return c.json(HttpStatus.ok, 'pong');
};
