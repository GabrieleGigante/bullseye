// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dartboard/dartboard.dart';

import '../context.dart';

class HttpMethod {
  static String GET = 'GET';
  static String POST = 'POST';
  static String PATCH = 'PATCH';
  static String PUT = 'PUT';
  static String DELETE = 'DELETE';
  static String OPTIONS = 'OPTIONS';
}

typedef Handler = Function(Context);

// typedef Middleware = Handler Function();
