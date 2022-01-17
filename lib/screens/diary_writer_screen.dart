import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter/src/widgets/text.dart' as Text;

class DiaryWriterScreen extends StatefulWidget {
  static const routeName = '/writer';

  const DiaryWriterScreen({Key? key}) : super(key: key);

  @override
  _DiaryWriterScreenState createState() => _DiaryWriterScreenState();
}

class _DiaryWriterScreenState extends State<DiaryWriterScreen> {
  late final QuillController _controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: null,
          child: Text.Text('Date'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.my_location_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: SizedBox(
                height: 500,
                child: Expanded(
                  child: QuillEditor(
                    controller: _controller,
                    readOnly: false,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: FocusNode(),
                    autoFocus: false,
                    expands: false,
                    // maxHeight: 300,
                    // minHeight: 300,
                    padding: EdgeInsets.zero,
                    placeholder: 'How was your day?',
                    showCursor: true,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(
                top: 35,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: QuillToolbar.basic(
                toolbarIconSize: 25,

                toolbarSectionSpacing: 10,
                controller: _controller,
                // showDividers: false,
                showSmallButton: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                // showHeaderStyle: false,
                // showListNumbers: false,
                // showListCheck: false,
                showCodeBlock: false,
                // showIndent: false,
                showLink: false,
                // showHistory: false,
                showHorizontalRule: false,
                multiRowsDisplay: false,
                showImageButton: false,
                showVideoButton: false,
                showCameraButton: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
