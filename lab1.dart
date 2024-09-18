import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isButtonOn = false; // Переменная для отслеживания состояния кнопки

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleButton() {
    setState(() {
      _isButtonOn = !_isButtonOn;
      if (_isButtonOn) {
        _sendRequest('1');
      } else {
        _sendRequest('0');
      }
    });
  }

  void _sendRequest(String state) {
    final url = Uri.parse("http://iocontrol.ru/api/sendData/aboba_abobus/aboba/$state");
    http.get(url).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).catchError((error) {
      print("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium, 
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _toggleButton,
              child: Text(_isButtonOn ? 'Turn Off' : 'Turn On'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
