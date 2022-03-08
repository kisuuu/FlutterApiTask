// @dart=2.9
import 'package:flutter/material.dart';

import 'Screens/LoginForm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login with Signup',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginForm(),
    );
  }
}
