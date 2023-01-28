List<String> parsePath(String path) =>
    path.split('?').first.split('/').where((element) => element.trim().isNotEmpty).toList();
