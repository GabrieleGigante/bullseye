import 'dart:io';

import 'package:bullseye/bullseye.dart';

void helloWorld(Context c) => c.json(HttpStatus.ok, {'Hello': 'world'});

void main(List<String> arguments) {
  final app = Bullseye(port: 5555);
  app.get('/', handler: helloWorld);
  app.listen();
}
