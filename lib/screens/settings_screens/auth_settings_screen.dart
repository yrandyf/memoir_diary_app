import 'package:flutter/material.dart';

import '../../models/AuthSwitchState.dart';
import '../../models/LockScreen.dart';

class AuthSettings extends StatefulWidget {
  static const routeName = '/authSettings';
  const AuthSettings({Key? key}) : super(key: key);

  @override
  State<AuthSettings> createState() => _AuthSettingsState();
}

class _AuthSettingsState extends State<AuthSettings> {
  bool isSwitched = false;
  @override
  void initState() {
    AuthSwitchState().getAuthState().then((state) {
      setState(() {
        isSwitched = state;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentcation')),
      body: ListTile(
        title: const Text('Privacy Settings'),
        subtitle: const Text('Privacy Protection with Fingerprint'),
        trailing: Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
            LockScreen(context).userAuth(path: 'settings', value: value);
          },
          activeTrackColor: Colors.blue,
          activeColor: Colors.blueAccent,
        ),
        onTap: () => {Navigator.of(context).pushNamed(AuthSettings.routeName)},
      ),
    );
  }
}
