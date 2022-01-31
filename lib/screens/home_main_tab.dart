import 'package:flutter/material.dart';
import 'package:memoir_diary_app/screens/temp.dart';
import 'package:memoir_diary_app/widgets/main_screen/diary_entry_list.dart';
import 'package:memoir_diary_app/widgets/main_screen/flexible_space_widget.dart';
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
          Navigator.of(context).pushNamed(DiaryWriterScreen.routeName);
        },
        child: const Icon(Icons.edit_outlined),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              background: FlexibleSpaceBackground(),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DiaryEntryList(),
                GetInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
