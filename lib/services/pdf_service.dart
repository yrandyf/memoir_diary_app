import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pdf/widgets.dart' as pdfw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:http/http.dart' show get;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/Entry.dart';

class PdfService {
  static Future<void> generateFile() async {
    String uid = await FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot<Map<String, dynamic>> userEntries = await FirebaseFirestore
        .instance
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .get();

    List<Entry> _entries = userEntries.docs.map((doc) {
      return Entry.fromDocument(doc);
    }).toList();

    PdfDocument pdfDoc = PdfDocument();

    for (int i = 0; i < _entries.length; i++) {
      final pdfPage = pdfDoc.pages.add();
      // final PdfGrid grid = PdfGrid();

      // Image Grid
      // if (_entries[i].image_list != null) {
      //   for (int i = 0; i < _entries[i].image_list!.length; i++) {
      //     grid.columns.add(count: _entries[i].image_list!.length);
      //     print('amount of columns ${_entries[i].image_list!.length}');
      //     var response = await get(Uri.parse(_entries[i].image_list![i]));
      //     print(_entries[i].image_list![i]);
      //     final PdfGridRow row = grid.rows.add();
      //     print('loop no $i');
      //     row.cells[i].value = PdfBitmap(response.bodyBytes);
      //   }
      //   grid.draw(page: pdfPage, bounds: const Rect.fromLTWH(0, 600, 400, 600));
      // }

      // Date
      pdfPage.graphics.drawString(
          _entries[i].date != null ? '${_entries[i].date}' : 'No Date',
          PdfStandardFont(PdfFontFamily.helvetica, 12,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 10, 600, 200));

      // Location
      pdfPage.graphics.drawString(
          _entries[i].location != null
              ? ' ${_entries[i].location as String}'
              : 'No Location',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(160, 10, 600, 200));

      // Tags
      PdfUnorderedList(
              text: _entries[i].tags != null
                  ? 'Tags: ${_entries[i].tags}'
                  : 'No Tags',
              font: PdfStandardFont(PdfFontFamily.helvetica, 12),
              marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.none),
              indent: 10,
              textIndent: 10,
              format: PdfStringFormat(lineSpacing: 2))
          .draw(page: pdfPage, bounds: const Rect.fromLTWH(350, 10, 0, 0));

      // Mood
      pdfPage.graphics.drawString(
          _entries[i].mood != null
              ? 'Mood: ${_entries[i].mood as String}'
              : 'Empty Mood',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 40, 0, 0));

      // Activity
      pdfPage.graphics.drawString(
          _entries[i].position != null
              ? 'Activity: ${_entries[i].position as String}'
              : 'Empty Mood',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(120, 40, 0, 0));

      // Image Hyperlinks
      if (_entries[i].image_list != null) {
        PdfUnorderedList(
                text: '${_entries[i].image_list}',
                style: PdfUnorderedMarkerStyle.none,
                font: PdfStandardFont(PdfFontFamily.helvetica, 12),
                indent: 10,
                textIndent: 10,
                format: PdfStringFormat(lineSpacing: 10))
            .draw(page: pdfPage, bounds: const Rect.fromLTWH(10, 300, 0, 0));
      }

      // Content Summery
      pdfPage.graphics.drawString(
          'Content: ${_entries[i].contentSummery as String}',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 150, 650, 600));
    }
    List<int> pdfBytes = pdfDoc.save();
    pdfDoc.dispose();
    saveAndOpenFile(pdfBytes, 'entryExport.pdf');
  }

  static Future<void> saveAndOpenFile(
      List<int> pdfBytes, String fileName) async {
    // Variable holds the path from directory.
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(pdfBytes, flush: true);
    OpenFile.open('$path/$fileName');
  }
}
