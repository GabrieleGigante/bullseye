import 'package:bullseye/bullseye.dart';

void helloWorld(Context c) => c.json(HttpStatus.ok, {'Hello': 'world'});

Handler exampleMiddleware(String name) {
  return (Context c) {
    // print('middleware $name');
    c.response.headers.set('middleware-$name', 'done');
  };
}

void main(List<String> arguments) {
  final app = Bullseye(port: 5555);
  app.use(exampleMiddleware('1'));
  app.get('/', handler: helloWorld);
  app.listen();
}
