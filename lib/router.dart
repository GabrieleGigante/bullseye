import 'package:bullseye/route.dart';
import 'package:bullseye/services/parse_path.dart';

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
  void connect(final String path, {final Handler? handler}) =>
      route(HttpMethod.CONNECT, path, handler: handler);
  void trace(final String path, {final Handler? handler}) =>
      route(HttpMethod.TRACE, path, handler: handler);
  void head(final String path, {final Handler? handler}) =>
      route(HttpMethod.HEAD, path, handler: handler);
  void use(Handler middleware) => route('*', '*', handler: middleware);

  void route(final String v, final String path, {final Handler? handler}) {
    List<String> segments = [];
    for (final String s in parsePath('$basePath/$path')) {
      segments.add(s);
    }
    if (handler == null) {
      throw 'Handler is required';
    }
    routes.add(Route(method: v, path: segments.join('/'), handler: handler));
  }
}
