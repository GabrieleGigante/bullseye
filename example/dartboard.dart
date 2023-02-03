import 'dart:io';

import 'package:dartboard/context.dart';
import 'package:dartboard/dartboard.dart';
import 'package:dartboard/models/http_types.dart';

exampleMiddleware(String name) {
  return (Context c) {
    // print('middleware $name');
    c.response.headers.set('middleware-$name', 'done');
  };
}

// ignore: prefer_function_declarations_over_variables
final rootFunction = (Context c) {
  print('pong');
  return c.json(HttpStatus.ok, 'pong');
};

void main(List<String> arguments) {
  final app = DartBoard(port: 5555);
  app.use(exampleMiddleware('1'));
  app.route(HttpMethod.GET, '/', handler: rootFunction);
  app.use(exampleMiddleware('2'));
  app.route(HttpMethod.GET, '/hello', handler: (Context c) {
    print('Hello!');
    c.json(HttpStatus.ok, "Hello");
  });
  app.runHTTP();
}
