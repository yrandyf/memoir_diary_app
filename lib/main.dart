import 'package:flutter/material.dart';
import '../screens/signup_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        routes: {
          SignUpPage.routeName: (ctx) => SignUpPage(),
          LoginPage.routeName: (ctx) => LoginPage(),
        });
  }
}
