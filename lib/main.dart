import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper/layouts/home_layout.dart';
import 'package:notekeeper/shared/cubit/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.purple
      ),
      home: HomeLayout(),
    );
  }
}
