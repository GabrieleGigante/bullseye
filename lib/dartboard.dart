// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartboard/models/http_types.dart';
import 'package:dartboard/router.dart';
import 'package:dartboard/services/parse_path.dart';
// import 'package:dartboard/services/print_routes.dart';

import 'context.dart';
import 'route.dart';

class DartBoard {
  late final Router router;
  final String address;
  final int port;
  late final Future<HttpServer> server;
  DartBoard({this.address = '0.0.0.0', required this.port}) {
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
  void route(final String method, final String path, {final Handler? handler}) =>
      router.route(method, path, handler: handler);
  void use(Handler middleware) => router.route('*', '*', handler: middleware);

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
          response: request.response, request: request, urlParam: {}, queryParam: {}, keys: {});
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
        c.urlParam[routeSegment.substring(1)] = reqSegment;
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
