import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';
import '../screens/tabs/tab_2/calender_screen.dart';
import '../screens/tabs/tab_1_main/home_main_tab.dart';
import '../services/images_service.dart';
import 'side_bar.dart';
import '../screens/auth/login_screen.dart';
import '../services/firebase_user_auth.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/main';

  final User user;

  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool _isSendingVerification = false;
  // bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: SideBar(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(SearchBar.routeName))
                ],
                title: const Text('Memoire'),
                pinned: true,
                floating: true,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Icon(Icons.home)),
                    Tab(child: Icon(Icons.date_range_rounded)),
                    Tab(child: Icon(Icons.photo_camera_back)),
                    Tab(child: Icon(Icons.map)),
                    Tab(child: Icon(Icons.bar_chart_rounded)),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              MainHomeScreen(),
              CalendarScreen(),
              Icon(Icons.date_range, size: 350),
              Icon(Icons.photo_camera_back, size: 350),
              Icon(Icons.bar_chart, size: 350),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   Provider.of<ImagesService>(context, listen: false).clear();
  // }
}
