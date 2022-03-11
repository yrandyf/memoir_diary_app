import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import 'package:provider/provider.dart';

import '../services/entry_data_service.dart';
import 'edit_entry_screen.dart';

class ViewEntryScreen extends StatefulWidget {
  static const routeName = '/viewer';

  ViewEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ViewEntryScreenState createState() => _ViewEntryScreenState();
}

final _pageController = PageController(initialPage: 0);
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
    Entry? selectedEntry =
        Provider.of<EntryBuilderService>(context, listen: false).entry!;

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
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditEntryScreen.routeName),
              ),
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
              background: selectedEntry.image_list!.length == 1
                  ? Visibility(
                      visible: selectedEntry.image_list!.length == 1,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          selectedEntry.image_list?[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('Something Went Wrong!'),
                        ),
                      ),
                    )
                  : Visibility(
                      visible: selectedEntry.image_list!.length > 0,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  selectedEntry.image_list![index].toString(),
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blueAccent),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Something Went Wrong!'),
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Chip(
                        labelPadding: const EdgeInsets.only(
                            left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                        avatar: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.location_on_outlined),
                        ),
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                        label: Text(selectedEntry.location.toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
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
                          label: Text(selectedEntry.position.toString()),
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
                          label: Text(selectedEntry.mood.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: quill.QuillEditor(
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
            ),
          ),
        ],
      ),
    );
  }
}