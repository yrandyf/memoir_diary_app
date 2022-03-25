import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdfw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/Entry.dart';

class PdfService {
  static Future<File> generateFile(String text) async {
    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = pdfw.Font.ttf(font);
    final pdf = pdfw.Document();
    String uid = await FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot<Map<String, dynamic>> userEntries = await FirebaseFirestore
        .instance
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .get();

    List<Entry> _entries = userEntries.docs.map((doc) {
      return Entry.fromDocument(doc);
    }).toList();

    for (int i = 0; i < _entries.length; i++) {
      Entry entry = _entries[i];

      final quill.QuillController _controller = quill.QuillController(
        document: quill.Document.fromJson(entry.content as List),
        selection: const TextSelection.collapsed(offset: 0),
      );
      pdf.addPage(
        pdfw.MultiPage(
          build: (context) => [],
        ),
      );
    }
    return saveDocument(name: 'entryDoc.pdf', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required pdfw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print(url);

    await OpenFile.open(url);
  }
}
