import 'dart:io';

import 'package:dartboard/context.dart';
import 'package:dartboard/dartboard.dart';
import 'package:dartboard/models/http_types.dart';

Middleware exampleMiddleware = (String name) {
  return (Context c) {
    // print('middleware $name');
    c.response.headers.set('middleware-$name', 'done');
  };
};

final rootFunction = (Context c) {
  // print('pong');
  c.send(HttpStatus.ok, 'pong');
  return;
};

class ExampleController {
  void index(Context c) {
    c.send(HttpStatus.ok, 'index');
  }

  void show(Context c) {
    c.send(HttpStatus.ok, 'show');
  }
}

void main(List<String> arguments) {
  final app = DartBoard(port: 5555);
  app.route(HttpMethod.GET, '/', handler: ExampleController().index);
  app.listen();
}
