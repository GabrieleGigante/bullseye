import 'package:dartboard/services/parse_path.dart';

import 'models/http_types.dart';

class Route {
  final String method;
  final String path;
  late final List<String> pathSegments;
  final Handler handler;
  Route({
    required this.method,
    required this.path,
    required this.handler,
  }) {
    pathSegments = parsePath(path);
  }
}
