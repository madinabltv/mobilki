import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  String _body = "";
  int _res = 0;

  void get_val() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.29.252:8888'));
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
      var response = await http.post(Uri.parse('http://192.168.29.252:8888/$value'));
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

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyForm(),
      ),
    );
