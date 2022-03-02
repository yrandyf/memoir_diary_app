import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/models/Entry.dart';

class EntryDeleteAlertDialog extends StatelessWidget {
  const EntryDeleteAlertDialog({
    Key? key,
    required this.entryRef,
    required this.entry,
  }) : super(key: key);

  final CollectionReference<Object?> entryRef;
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Selected Entry?'),
      content: Text('Are you sure?'),
      actions: [
        TextButton(
            child: Text('Abort'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop()),
        TextButton(
          child: Text('Delete'),
          onPressed: () {
            entryRef.doc(entry.entryId).delete();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
