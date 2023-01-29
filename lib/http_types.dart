// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dartboard/dartboard.dart';

enum HttpMethod { GET, POST, PATCH, PUT, DELETE, OPTIONS }

typedef Handler = Function(Context);
