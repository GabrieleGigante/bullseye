// import 'dart:mirrors';

// import 'package:dolumns/dolumns.dart';

// import '../route.dart';

// void printRoutes(List<Route> routes) {
//   List<List<String>> d = [];
//   print('Number of handlers: ${routes.length}');
//   for (Route r in routes) {
//     final cm = reflect(r.handler) as ClosureMirror;
//     final fn = MirrorSystem.getName(cm.function.qualifiedName)
//         .replaceAll('<anonymous closure>', 'anonymousClosure');

//     String pn = r.path;
//     if (pn.isEmpty) {
//       pn = '/';
//     }
//     if (r.method == '*') {
//       continue;
//     }
//     d.add([r.method, '-', pn, '-->', fn]);
//   }
//   print(dolumnify(d));
// }
