// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dartboard/dartboard.dart';

enum Method { GET, POST, PATCH, PUT, DELETE, OPTIONS }

class Status {
  static int OK = 200;
  static int Created = 201;
  static int BadRequest = 400;
  static int Notfound = 404;
  static int InternalServerError = 500;
}

typedef Handler = Function(Context);
