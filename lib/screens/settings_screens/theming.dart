import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme.dart';
import '../../models/theme_switch_state.dart';
import '../../models/LockScreen.dart';

class ThemeSettings extends StatefulWidget {
  static const routeName = '/themeSettings';
  const ThemeSettings({Key? key}) : super(key: key);

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  bool isSwitched = false;
  @override
  void initState() {
    ThemeSwitchState().getSwitchState().then((state) {
      setState(() {
        isSwitched = state;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearances')),
      body: Consumer<ThemeChanger>(
        builder: (context, themeChanger, child) {
          return ListTile(
            title: const Text('Switch Theme'),
            subtitle: const Text('Switch Between Light/ Dark Themes'),
            trailing: Switch(
              value: themeChanger.darkTheme,
              onChanged: (value) async {
                themeChanger.toggleTheme();
              },
              activeTrackColor: Colors.blue,
              activeColor: Colors.blueAccent,
            ),
            onTap: () => {},
          );
        },
      ),
    );
  }
}
