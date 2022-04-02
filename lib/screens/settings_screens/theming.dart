import 'package:flutter/material.dart';
import '../../models/AuthSwitchState.dart';
import '../../models/LockScreen.dart';

class ThemeSettings extends StatefulWidget {
  static const routeName = '/themeSettings';
  const ThemeSettings({Key? key}) : super(key: key);

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  bool isSwitched = false;
  // @override
  // void initState() {
  //   AuthSwitchState().getAuthState().then((state) {
  //     setState(() {
  //       isSwitched = state;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearances')),
      body: ListTile(
        title: const Text('Switch Theme'),
        subtitle: const Text('Switch Between Light/ Dark Themes'),
        trailing: Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          },
          activeTrackColor: Colors.blue,
          activeColor: Colors.blueAccent,
        ),
        onTap: () => {},
      ),
    );
  }
}
