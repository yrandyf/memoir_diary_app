import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import 'package:provider/provider.dart';

import '../services/entry_data_service.dart';
import '../utils/icon_switch.dart';
import '../widgets/main_screen/delete_entry.dart';
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
                onPressed: () {
                  // Provider.of<EntryBuilderService>(context, listen: false)
                  //     .setEntry(selectedEntry);
                  Navigator.of(context).pushNamed(EditEntryScreen.routeName);
                },
              ),
              PopupMenuButton(
                onSelected: (_) => {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EntryDeleteAlertDialog(entry: selectedEntry);
                    },
                  ).then((_) => Navigator.of(context).pop())
                },
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Color(0xFFFE4A49)),
                    ),
                    value: 1,
                  ),
                ],
              ),
            ],
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
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
                                          color: Colors.white),
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
                      if (selectedEntry.location != 'null')
                        Chip(
                          labelPadding: const EdgeInsets.only(
                              left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                          avatar: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.location_on_outlined),
                          ),
                          padding: const EdgeInsets.all(0),
                          // backgroundColor: Colors.white,
                          label: Text(selectedEntry.location.toString()),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      if (selectedEntry.position != null)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Chip(
                            labelPadding: const EdgeInsets.only(
                                left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                            avatar: IconButton(
                              onPressed: () {},
                              icon: setActivityIconListVIew(
                                  selectedEntry.position as String),
                            ),
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: Colors.white,
                            label: Text(selectedEntry.position.toString()),
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (selectedEntry.mood != null)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Chip(
                            labelPadding: const EdgeInsets.only(
                                left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                            avatar: IconButton(
                              onPressed: () {},
                              icon: setMoodIcon(selectedEntry.mood as String),
                            ),
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: Colors.white,
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
              padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: selectedEntry.tags!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Chip(
                        label: Text('#${selectedEntry.tags![index]}'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
