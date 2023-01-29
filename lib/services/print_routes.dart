import 'dart:mirrors';

import 'package:dolumns/dolumns.dart';

import '../dartboard.dart';

void printRoutes(List<Route> routes) {
  List<List<String>> d = [];
  print('Number of endpoints: ${routes.length}');
  for (Route r in routes) {
    final cm = reflect(r.handler) as ClosureMirror;
    final fn = MirrorSystem.getName(cm.function.qualifiedName)
        .replaceAll('<anonymous closure>', 'anonymousClosure');

    String pn = r.path;
    if (pn.isEmpty) {
      pn = '/';
    }
    d.add([r.method.name, '-', pn, '-->', fn]);
  }
  print(dolumnify(d));
}
