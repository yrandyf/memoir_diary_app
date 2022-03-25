import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/pdf_service.dart';

class ExportDiary extends StatefulWidget {
  static const routeName = '/exportdiary';

  const ExportDiary({Key? key}) : super(key: key);

  @override
  State<ExportDiary> createState() => _ExportDiaryState();
}

class _ExportDiaryState extends State<ExportDiary> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Diary')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80, bottom: 19),
            child: SvgPicture.asset(
              'assets/images/login.svg',
              width: double.infinity,
              height: 260.0,
            ),
          ),
          SizedBox(
            width: 170,
            height: 70,
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text('This May Take a Second.'),
                      SizedBox(height: 8),
                      CircularProgressIndicator(color: Colors.blue),
                    ],
                  )
                : OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: const Text('Export All Entries'),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      final pdfFile = await PdfService.generateFile('ambo');
                      PdfService.openFile(pdfFile);
                      setState(() {
                        isLoading = false;
                      });
                    }),
          )
        ],
      ),
    );
  }
}
