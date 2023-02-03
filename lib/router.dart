import 'package:dartboard/route.dart';
import 'package:dartboard/services/parse_path.dart';

import 'models/http_types.dart';

class Router {
  String basePath = '';
  List<Route> routes;
  List<Router> groups;
  Router({
    this.basePath = '',
    required this.routes,
    required this.groups,
  });

  List<Route> normalize() {
    List<Route> temp = [];
    // final String basePath = r.basePath;
    for (Route route in routes) {
      temp.add(route);
    }
    for (Router group in groups) {
      temp.addAll(group.normalize());
    }
    // routes = [];
    // groups = [];
    return temp;
  }

  void get(final String path, {final Handler? handler}) =>
      route(HttpMethod.GET, path, handler: handler);
  void post(final String path, {final Handler? handler}) =>
      route(HttpMethod.POST, path, handler: handler);
  void patch(final String path, {final Handler? handler}) =>
      route(HttpMethod.PATCH, path, handler: handler);
  void put(final String path, {final Handler? handler}) =>
      route(HttpMethod.PUT, path, handler: handler);
  void delete(final String path, {final Handler? handler}) =>
      route(HttpMethod.DELETE, path, handler: handler);
  void options(final String path, {final Handler? handler}) =>
      route(HttpMethod.OPTIONS, path, handler: handler);

  void route(final String v, final String path, {final Handler? handler}) {
    if (handler == null) {
      throw 'Error in handlers definition';
    }
    // ignore: unnecessary_null_comparison
    // if (handler != null) {
    //   throw 'field "handler" and "handlers" are both initialized';
    // }
    List<String> segments = [basePath];
    for (final String s in parsePath(path)) {
      segments.add(s);
    }
    routes.add(Route(method: v, path: segments.join('/'), handler: handler));
  }
}
