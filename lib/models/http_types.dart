// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import '../context.dart';

class HttpMethod {
  static String GET = 'GET';
  static String POST = 'POST';
  static String PATCH = 'PATCH';
  static String PUT = 'PUT';
  static String DELETE = 'DELETE';
  static String HEAD = 'HEAD';
  static String OPTIONS = 'OPTIONS';
  static String CONNECT = 'CONNECT';
  static String TRACE = 'TRACE';
}

typedef Handler = void Function(Context);
typedef HandlerList = List<Handler>;
typedef Middleware = Handler Function(String);
