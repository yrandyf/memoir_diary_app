import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

  DateTime selectedEntryDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedEntryDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null && selectedDate != selectedEntryDate)
      setState(
        () {
          selectedEntryDate = selectedDate;
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text.Text(
            '${selectedEntryDate.day}/${selectedEntryDate.month}/${selectedEntryDate.year}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.my_location_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_a_photo),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  reverse: true,
                  child: QuillEditor(
                    controller: _controller,
                    readOnly: false,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: FocusNode(),
                    autoFocus: true,
                    expands: false,
                    maxHeight: null,
                    minHeight: null,
                    padding: EdgeInsets.zero,
                    placeholder: 'How was your day?',
                    showCursor: true,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
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
                    multiRowsDisplay: false,
                    showImageButton: false,
                    showVideoButton: false,
                    showCameraButton: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
