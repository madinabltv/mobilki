import 'package:flutter/material.dart';
import 'lab1_screen.dart';
import 'lab2_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IU9 - Форма ввода'),
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
          ],
        ),
      ),
      body: Center(
        child: Text('Выберите лабораторную работу из меню'),
      ),
    );
  }
}
