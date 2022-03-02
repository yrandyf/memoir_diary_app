import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:memoir_diary_app/models/Entry.dart';

class ViewEntryScreen extends StatefulWidget {
  static const routeName = '/entryViewer';

  ViewEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ViewEntryScreenState createState() => _ViewEntryScreenState();
}

final _pageController = PageController();
int currentPage = 0;

List<Widget> pageIndicators(courselLength, currentIdx) {
  return List<Widget>.generate(
    courselLength,
    (page) {
      return Container(
        height: 10,
        width: 10,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: currentIdx == page ? Colors.white : Colors.black,
            shape: BoxShape.circle),
      );
    },
  );
}

class _ViewEntryScreenState extends State<ViewEntryScreen> {
  @override
  Widget build(BuildContext context) {
    Entry? selectedEntry = ModalRoute.of(context)!.settings.arguments as Entry;

    late final quill.QuillController _controller = quill.QuillController(
      document: quill.Document.fromJson(selectedEntry.content as List),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    print(selectedEntry.date);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
            ],
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            pinned: true,
            expandedHeight: selectedEntry.image_list!.isNotEmpty
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.10,
            flexibleSpace: FlexibleSpaceBar(
              background: Visibility(
                visible: selectedEntry.image_list!.length > 1,
                child: PageView.builder(
                  controller: _pageController,
                  pageSnapping: true,
                  onPageChanged: (page) {
                    setState(() => currentPage = page);
                  },
                  itemCount: selectedEntry.image_list!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(1),
                          child: Image.network(
                            selectedEntry.image_list![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: pageIndicators(
                                  selectedEntry.image_list!.length,
                                  currentPage),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    DateFormat('dd')
                                        .format(selectedEntry.date as DateTime),
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (DateFormat('MMMM, yyyy')
                                      .format(selectedEntry.date as DateTime)),
                                  style: const TextStyle(fontSize: 25),
                                ),
                                Text(
                                  DateFormat('EEEE, HH:mm a')
                                      .format(selectedEntry.date as DateTime),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                        Chip(
                          labelPadding: const EdgeInsets.only(
                              left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                          avatar: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.location_on_outlined),
                          ),
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          label: Flexible(
                              child: Text(selectedEntry.location.toString())),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Chip(
                            labelPadding: const EdgeInsets.only(
                                left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                            avatar: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.accessibility),
                            ),
                            padding: EdgeInsets.all(0),
                            backgroundColor: Colors.white,
                            label: Flexible(
                                child: Text(selectedEntry.position.toString())),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Chip(
                            labelPadding: const EdgeInsets.only(
                                left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                            avatar: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.tag_faces_outlined),
                            ),
                            padding: EdgeInsets.all(0),
                            backgroundColor: Colors.white,
                            label: Flexible(
                                child: Text(selectedEntry.mood.toString())),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        // Align(
                        //   alignment: Alignment.bottomLeft,
                        //   child:
                        // ),
                      ],
                    ),
                    Divider(),
                    quill.QuillEditor(
                      controller: _controller,
                      readOnly: true,
                      scrollController: ScrollController(),
                      scrollable: true,
                      focusNode: FocusNode(),
                      autoFocus: false,
                      expands: false,
                      maxHeight: null,
                      minHeight: null,
                      padding: EdgeInsets.zero,
                      showCursor: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
