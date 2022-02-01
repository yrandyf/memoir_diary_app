import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/firebase_options.dart';
import '../screens/signup_screen.dart';
import 'screens/add_photos.dart';
import 'screens/diary_writer_screen.dart';
import 'screens/home_main_tab.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        SignUpPage.routeName: (ctx) => SignUpPage(),
        LoginPage.routeName: (ctx) => LoginPage(),
        DiaryWriterScreen.routeName: (ctx) => DiaryWriterScreen(),
        MainHomeScreen.routeName: (ctx) => MainHomeScreen(),
        // ImagePickerScreen.routeName: (ctx) => ImagePickerScreen(),
      },
    );
  }
}
