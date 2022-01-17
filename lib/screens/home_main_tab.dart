import 'package:flutter/material.dart';
import 'diary_writer_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(DiaryWriterScreen.routeName);
      },
      child: const Icon(Icons.edit_outlined),
    ));
  }
}
