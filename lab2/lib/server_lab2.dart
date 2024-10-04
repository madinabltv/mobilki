import 'dart:convert';
import 'dart:io';

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv6, 8888);
  int count = 0;

  print('Сервер запущен на http://localhost:8888');

  await server.forEach((HttpRequest request) async {
    final response = request.response;
    String path = request.uri.path;

    // Добавление заголовков CORS
    response.headers.add(HttpHeaders.accessControlAllowOriginHeader, "*");
    response.headers.add(HttpHeaders.accessControlAllowMethodsHeader, "GET, POST, OPTIONS");
    response.headers.add(HttpHeaders.accessControlAllowHeadersHeader, "Content-Type");

    if (request.method == 'POST') {
      String numberString = path.substring(1);
      print("Обработка запроса: '$numberString'");

      int? c;

      try {
        c = int.parse(numberString);
        count = c;
      } catch (e) {
        print("Ошибка при преобразовании: $e");
        response.write('Неверный ввод. Пожалуйста, укажите целое число.');
        response.statusCode = HttpStatus.badRequest;
        await response.close();
        return;
      }

      if (c != null) { // Проверка, что c было успешно преобразовано
        print(c);
      }
    }

    response.write(jsonEncode({'value': count}));
    print("Count: $count");
    await response.close();
  });
}
