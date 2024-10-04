import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      appBar: AppBar(
        title: Text('Lab 2 - Форма ввода'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Тестовое поле:',
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
