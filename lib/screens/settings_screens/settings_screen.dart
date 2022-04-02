import 'package:flutter/material.dart';

import 'auth_settings_screen.dart';
import 'export_diary.dart';
import 'set_reminder.dart';
import 'theming.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.import_export_rounded),
            title: const Text('Export Diary'),
            onTap: () =>
                {Navigator.of(context).pushNamed(ExportDiary.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Appearances'),
            onTap: () =>
                {Navigator.of(context).pushNamed(ThemeSettings.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Reminder'),
            onTap: () =>
                {Navigator.of(context).pushNamed(ReminderSettings.routeName)},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Privacy'),
            onTap: () =>
                {Navigator.of(context).pushNamed(AuthSettings.routeName)},
          ),
        ],
      ),
    );
  }
}
