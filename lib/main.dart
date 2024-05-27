import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screen/home.dart';
import 'package:todo/model/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO APP',
      home: FutureBuilder<List<ToDo>>(
        future: loadToDoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display loading indicator while loading todo list
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Home(todoList: snapshot.data!);
          }
        },
      ),
    );
  }
}

Future<List<ToDo>> loadToDoList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? todoListJson = prefs.getString('todoList');
  if (todoListJson != null) {
    Iterable decoded = jsonDecode(todoListJson);
    return decoded.map((item) => ToDo.fromJson(item)).toList();
  } else {
    return [];
  }
}
