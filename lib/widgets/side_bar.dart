import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/screens/auth/login_screen.dart';
import 'package:memoir_diary_app/services/firebase_user_auth.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Memoire',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.10,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Finest Digital Diary Experience!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.blueGrey,
                  ),
                ),
                const Divider(),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              FireBaseAuth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
