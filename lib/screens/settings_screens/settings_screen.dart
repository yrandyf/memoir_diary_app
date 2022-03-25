import 'package:flutter/material.dart';

import 'export_diary.dart';

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
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
