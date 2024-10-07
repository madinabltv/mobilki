import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: Text('IU9 - Форма ввода'),
        backgroundColor: Colors.blue,
      ),



      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Меню',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Lab 1'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lab1Screen()),
                );
              },
            ),
            ListTile(
              title: Text('Lab 2'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lab2Screen()),
                );
              },
            ),
            ListTile(
              title: Text('Lab 3'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lab3Screen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Выберите лабораторную работу из меню'),
      ),
    );
  }
}

class Lab1Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Lab1ScreenState();
}

class Lab1ScreenState extends State<Lab1Screen> {
  final _formKey = GlobalKey<FormState>();
  String _body = "";
  int _res = 0;

  void get_val() async {
    try {
      var response = await http.get(Uri.parse('http://172.20.10.3:8888'));
      if (response.statusCode == 200) {
        var mes = jsonDecode(response.body);
        setState(() {
          _res = mes['value'];
        });
      } else {
        print('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void send_val(int value) async {
    try {
      var response = await http.post(Uri.parse('http://172.20.10.3:8888/$value'));
      if (response.statusCode != 200) {
        print('Failed to send data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void incrementCounter() {
    setState(() {
      _res++;
    });
    send_val(_res);
  }

  void _dicrementCounter() {
    setState(() {
      _res--;
    });
    send_val(_res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Форма ввода'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Тестовое поле:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите значение',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Тестовое поле - не заполнено!';
                  } else {
                    _body = value;
                    send_val(int.parse(value));
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Отправить данные'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Форма заполнена!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Получить данные'),
                onPressed: get_val,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '$_res',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('+'),
                    onPressed: incrementCounter,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('-'),
                    onPressed: _dicrementCounter,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Lab2Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Lab2ScreenState();
}

class Lab2ScreenState extends State<Lab2Screen> {
  final _formKey = GlobalKey<FormState>();
  String _body = "";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _sendRequest(_body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Форма заполнена!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendRequest(String value) {
    http.post(
      Uri.parse('http://iocontrol.ru/api/sendData/aboba_abobus/bibaboba/${value}'),
      body: {'name': 'test', 'num': '10'},
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).catchError((error) {
      print("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Устанавливаем желтый фон для страницы
      appBar: AppBar(
        title: Text('Lab 2 - Форма ввода'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Тестовое поле:',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: 'Введите значение',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Тестовое поле - не заполнено!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _body = value!;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text('Отправить данные'),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Используем backgroundColor вместо primary
                        foregroundColor: Colors.blue, // Используем foregroundColor для цвета текста
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Lab3Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Lab3ScreenState();
}

class Lab3ScreenState extends State<Lab3Screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animation'),
        ),
        body: Center(
          child: AnimatedCircle(),
        ),
      ),
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  @override
  _AnimatedCircleState createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _radius = 50.0;
  Color _circleColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: _radius, end: _radius * 3).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateRadius(double value) {
    setState(() {
      _radius = value;
      _animation = Tween<double>(begin: _radius, end: _radius * 3).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
    });
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
  }

  void _stopAnimation() {
    _controller.stop();
  }

  void _changeColor(Color color) {
    setState(() {
      _circleColor = color;
    });
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите цвет'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _circleColor,
              onColorChanged: _changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _animation.value,
          height: _animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _circleColor,
          ),
        ),
        SizedBox(height: 20),
        Slider(
          value: _radius,
          min: 10.0,
          max: 100.0,
          divisions: 18,
          label: _radius.round().toString(),
          onChanged: _updateRadius,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startAnimation,
              child: Text('Go'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _stopAnimation,
              child: Text('Stop'),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _openColorPicker,
          child: Text('Поменять цвет'),
        ),
      ],
    );
  }

}
