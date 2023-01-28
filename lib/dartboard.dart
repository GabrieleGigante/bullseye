// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

import 'package:dartboard/models/verb.dart';
import 'package:dartboard/services/parse_path.dart';

class DartBoard {
  late final Router router;
  final String address;
  final int port;
  late final Future<HttpServer> server;
  DartBoard({this.address = '0.0.0.0', required this.port}) {
    if (port.isNegative) {
      throw 'Negative ports are not allowed';
    }
    router = Router(routes: [], groups: []);
    server = HttpServer.bind(address, port);
  }

  void route(Method method, String path, {Handler? handler, List<Handler>? handlers}) =>
      router.route(method, path, handler: handler);

  void runHTTP() async {
    print('Running HTTP server on: http://$address:$port');
    final s = await server;
    final routes = _normalizeRouter(router);
    print("N of routes: " + routes.length.toString());
    await for (HttpRequest request in s) {
      bool hasMatch = false;
      Context context = Context(response: request.response, request: request);
      for (Route route in routes) {
        if (route.method.name != request.method) {
          continue;
        }
        final requestPath = parsePath(request.uri.path);
        if (pathMatch(route, requestPath)) {
          hasMatch = true;
          route.handler(context);
        }
      }
      if (!hasMatch) {
        default404Handler(context);
      }
      await request.response.close();
    }
  }

  void default404Handler(Context c) {
    c.json(Status.Notfound, 'Page ${c.request.uri.path} not found');
  }

  bool pathMatch(Route route, List<String> request) {
    if (request.length != route.pathSegments.length) {
      return false;
    }
    for (var i = 0; i < route.pathSegments.length; i++) {
      final routeSegment = route.pathSegments[i];
      final reqSegment = request[i];
      if (routeSegment.startsWith(':')) {
        continue;
      }
      if (routeSegment == reqSegment) {
        continue;
      }
      return false;
    }
    return true;
  }

  List<Route> _normalizeRouter(Router r) {
    List<Route> routes = [];
    // final String basePath = r.basePath;
    for (Route route in r.routes) {
      routes.add(route);
    }
    for (Router group in r.groups) {
      routes.addAll(_normalizeRouter(group));
    }
    return routes;
  }
}

class Router {
  String basePath = '';
  List<Route> routes;
  List<Router> groups;
  Router({
    this.basePath = '',
    required this.routes,
    required this.groups,
  });

  void route(Method v, String path, {Handler? handler}) {
    if (handler == null) {
      throw 'Error in handlers definition';
    }
    // ignore: unnecessary_null_comparison
    // if (handler != null) {
    //   throw 'field "handler" and "handlers" are both initialized';
    // }
    List<String> segments = [basePath];
    for (final String s in path.split('/').where((element) => element.trim().isNotEmpty)) {
      segments.add(s);
    }
    routes.add(Route(method: v, path: segments.join('/'), handler: handler));
  }
}

class Route {
  final Method method;
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

  Route copyWith({
    Method? method,
    String? path,
    String? pathSegments,
    Handler? handler,
  }) {
    return Route(
      method: method ?? this.method,
      path: path ?? this.path,
      handler: handler ?? this.handler,
    );
  }
}

class Context {
  HttpResponse response;
  HttpRequest request;
  Map<String, dynamic> keys;
  Context({
    required this.response,
    required this.request,
    this.keys = const {},
  });
  void json(int s, String data) {
    response.statusCode = HttpStatus.notFound;
    response.write(data);
  }
}
