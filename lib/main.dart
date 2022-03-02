import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/firebase_options.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/activty_temp.dart';
import 'screens/diary_writer_screen.dart';
import 'screens/tabs/tab_1_main/home_main_tab.dart';
import 'screens/auth/login_screen.dart';
import 'screens/view_entry_screen.dart';

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
        ActivityRecognitionApp.routeName: (ctx) => ActivityRecognitionApp(),
        ViewEntryScreen.routeName: (ctx) => ViewEntryScreen(),
      },
    );
  }
}
