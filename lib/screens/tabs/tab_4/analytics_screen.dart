import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../models/Activity_Pie_Class.dart';
import '../../../models/MoodPieChartClass.dart';
import '../../../services/firestore_service.dart';
import '../../../utils/icon_switch.dart';
import 'dart:async';
import 'dart:ui' as dart_ui;
import 'package:path_provider/path_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Entry> _entries = [];
  List<String> moods = ['Happy', 'Sad', 'Average', 'Dissatisfied'];
  List<String> actvities = ['Standing', 'Walking', 'Sitting', 'Nap'];
  List<MoodPieChartClass> _moodData = [];
  List<ActivityPieChartClass> _actData = [];
  TooltipBehavior? _toolTipBehaviour;
  TooltipBehavior? _toolTipBehaviour2;
  final GlobalKey<SfCircularChartState> _chartKey = GlobalKey();
  final GlobalKey<SfCircularChartState> _chartKey2 = GlobalKey();

  Future getDocs() async {
    QuerySnapshot<Map<String, dynamic>> userEntries = await FirebaseFirestore
        .instance
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .get();

    _entries = userEntries.docs.map((doc) {
      return Entry.fromDocument(doc);
    }).toList();

    setState(() {
      for (int i = 0; i < moods.length; i++) {
        _moodData.add(MoodPieChartClass(
            mood: moods[i],
            moodCount: _entries.where((e) => e.mood == moods[i]).length));
      }
      for (int i = 0; i < actvities.length; i++) {
        _actData.add(ActivityPieChartClass(
            activity: actvities[i],
            actCount:
                _entries.where((e) => e.position == actvities[i]).length));
      }
    });
  }

  @override
  void initState() {
    _toolTipBehaviour = TooltipBehavior(enable: true);
    _toolTipBehaviour2 = TooltipBehavior(enable: true);
    getDocs();
    setState(() {});
    super.initState();
  }

  Future<List<int>> _readImageData() async {
    final dart_ui.Image data =
        await _chartKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirestoreService>(context, listen: false).getEntries(uid);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(
                height: 65,
                width: double.infinity,
                child: Card(
                  child: ListTile(
                      leading: const Text('Total Entries',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500)),
                      trailing: Text(_entries.length.toString(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500))),
                )),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                mainAxisExtent: 115,
                childAspectRatio: 1),
            delegate: SliverChildBuilderDelegate((context, index) {
              MoodPieChartClass mood = _moodData[index];
              return Card(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(mood.mood),
                      setMoodIconLarge(moods[index]),
                      Text(mood.moodCount.toString())
                    ]),
              );
            }, childCount: _moodData.length - 1),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 475,
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: SfCircularChart(
                  key: _chartKey2,
                  title: ChartTitle(
                      text: 'Activity Statistics',
                      alignment: ChartAlignment.near),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  tooltipBehavior: _toolTipBehaviour2,
                  series: <CircularSeries>[
                    DoughnutSeries<ActivityPieChartClass, String?>(
                        dataSource: _actData,
                        xValueMapper: (ActivityPieChartClass activity, _) =>
                            activity.activity,
                        yValueMapper: (ActivityPieChartClass activity, _) =>
                            activity.actCount,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 475,
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: SfCircularChart(
                  key: _chartKey,
                  title: ChartTitle(
                      text: 'Mood Statistics', alignment: ChartAlignment.near),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  tooltipBehavior: _toolTipBehaviour,
                  series: <CircularSeries>[
                    PieSeries<MoodPieChartClass, String?>(
                        dataSource: _moodData,
                        xValueMapper: (MoodPieChartClass mood, _) => mood.mood,
                        yValueMapper: (MoodPieChartClass mood, _) =>
                            mood.moodCount,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 65,
              width: double.infinity,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  OutlinedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      child: const Text('Generate Report'),
                      onPressed: () async {
                        var document = PdfDocument();
                        PdfPage page = document.pages.add();

                        dart_ui.Image data = await _chartKey.currentState!
                            .toImage(pixelRatio: 1.0);

                        final bytes = await data.toByteData(
                            format: dart_ui.ImageByteFormat.png);

                        final Uint8List imageBytes = bytes!.buffer.asUint8List(
                            bytes.offsetInBytes, bytes.lengthInBytes);

                        page.graphics.drawImage(PdfBitmap(imageBytes),
                            const Rect.fromLTWH(80, 30, 300, 350));

                        dart_ui.Image data2 = await _chartKey2.currentState!
                            .toImage(pixelRatio: 1.0);

                        final bytes2 = await data2.toByteData(
                            format: dart_ui.ImageByteFormat.png);

                        final Uint8List imageBytes2 = bytes2!.buffer
                            .asUint8List(
                                bytes2.offsetInBytes, bytes2.lengthInBytes);

                        page.graphics.drawImage(PdfBitmap(imageBytes2),
                            const Rect.fromLTWH(80, 400, 300, 350));

                        var byteData = document.save();
                        document.dispose();
                        Directory directory =
                            await getExternalStorageDirectory() as Directory;
                        String path = directory.path;
                        File file = File('$path/diarystats.pdf');
                        await file.writeAsBytes(byteData, flush: true);
                        OpenFile.open('$path/diarystats.pdf');
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// body: SizedBox(
//   height: 700,
//   width: double.infinity,
//   child: SfCircularChart(
//     title: ChartTitle(text: 'Mood Statistics'),
//     legend: Legend(
//         isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
//     tooltipBehavior: _toolTipBehaviour,
//     series: <CircularSeries>[
//       PieSeries<MoodPieChartClass, String?>(
//           dataSource: _moodData,
//           xValueMapper: (MoodPieChartClass mood, _) => mood.mood,
//           yValueMapper: (MoodPieChartClass mood, _) => mood.moodCount,
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//           enableTooltip: true)
//     ],
//   ),
// ),
