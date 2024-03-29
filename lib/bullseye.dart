import 'dart:io';

import 'package:bullseye/services/parse_path.dart';

import 'context.dart';
import 'models/http_types.dart';
import 'route.dart';
import 'router.dart';

export 'dart:io';
export 'context.dart';
export 'models/http_types.dart';
export 'route.dart';
export 'router.dart';

class Bullseye {
  late final Router router;
  final String address;
  final int port;
  late final Future<HttpServer> server;
  Bullseye({this.address = '0.0.0.0', required this.port}) {
    if (port.isNegative) {
      throw 'You can\'t listen on a negative port';
    }
    router = Router(routes: [], groups: []);
    server = HttpServer.bind(address, port);
  }

  void get(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.GET, path, handler: handler);
  void post(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.POST, path, handler: handler);
  void patch(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.PATCH, path, handler: handler);
  void put(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.PUT, path, handler: handler);
  void delete(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.DELETE, path, handler: handler);
  void options(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.OPTIONS, path, handler: handler);
  void connect(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.CONNECT, path, handler: handler);
  void trace(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.TRACE, path, handler: handler);
  void head(final String path, {final Handler? handler}) =>
      router.route(HttpMethod.HEAD, path, handler: handler);
  void use(Handler middleware) => router.route('*', '*', handler: middleware);

  void route(final String method, final String path, {final Handler? handler}) =>
      router.route(method, path, handler: handler);

  Router group(final String path) {
    final r = Router(routes: [], groups: [], basePath: path);
    router.groups.add(r);
    return r;
  }

  void listen() async {
    print('Running HTTP server on: http://$address:$port');
    final s = await server;
    final routes = router.normalize();
    // printRoutes(routes);
    await for (HttpRequest request in s) {
      Context context = Context(
        response: request.response,
        request: request,
        pathParam: {},
        queryParam: {},
        keys: {},
      );
      for (Route route in routes) {
        if (route.method != request.method && route.method != '*') {
          continue;
        }
        final requestPath = parsePath(request.uri.path);
        if (pathMatch(route, requestPath, context)) {
          context.handlers.add(route.handler);
        }
      }
      if (context.handlers.isEmpty) {
        default404Handler(context);
      } else {
        context.start();
      }
      await context.end();
    }
  }

  void default404Handler(Context c) {
    c.json(HttpStatus.notFound, 'Page ${c.request.uri.path} not found');
  }

  bool pathMatch(Route route, List<String> request, Context c) {
    if (request.length != route.pathSegments.length && route.method != '*') {
      return false;
    }
    if (route.path == '*' || route.path == '/*') {
      return true;
    }
    for (var i = 0; i < route.pathSegments.length; i++) {
      final routeSegment = route.pathSegments[i];
      String reqSegment = '';
      if (i < request.length) {
        reqSegment = request[i];
      }
      if (routeSegment.startsWith(':') || routeSegment.startsWith('*')) {
        c.pathParam[routeSegment.substring(1)] = reqSegment;
        continue;
      }
      if (routeSegment == reqSegment) {
        continue;
      }
      return false;
    }
    return true;
  }
}
