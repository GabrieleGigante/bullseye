import 'dart:io';

import 'package:bullseye/bullseye.dart';
import 'package:bullseye/context.dart';
import 'package:bullseye/models/http_types.dart';

Middleware exampleMiddleware = (String name) {
  return (Context c) {
    // print('middleware $name');
    c.response.headers.set('middleware-$name', 'done');
  };
};

void rootFunction(Context c) => c.json(HttpStatus.ok, {'Hello': 'world'});

class ExampleController {
  void index(Context c) {
    c.send(HttpStatus.ok, 'index');
  }

  void show(Context c) {
    c.send(HttpStatus.ok, 'show');
  }
}

void main(List<String> arguments) {
  final app = Bullseye(port: 5555);
  app.use(exampleMiddleware('1'));
  app.route(HttpMethod.GET, '/', handler: rootFunction);
  app.listen();
}
