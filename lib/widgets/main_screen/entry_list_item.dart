import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../screens/edit_entry_screen.dart';
import '../../services/entry_data_service.dart';
import '../../utils/icon_switch.dart';
import '/screens/view_entry_screen.dart';
import '/widgets/main_screen/delete_entry.dart';
import '../../models/Entry.dart';

class EntryListItem extends StatefulWidget {
  var entryRef;

  EntryListItem({
    Key? key,
    required this.entry,
    required this.entryRef,
  }) : super(key: key);

  final Entry entry;

  @override
  State<EntryListItem> createState() => _EntryListItemState();
}

class _EntryListItemState extends State<EntryListItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => {
              showDialog(
                context: context,
                builder: (context) {
                  return EntryDeleteAlertDialog(entry: widget.entry);
                },
              )
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).pushNamed(EditEntryScreen.routeName);
              Provider.of<EntryBuilderService>(context, listen: false)
                  .setEntry(widget.entry);
              print(widget.entry.date);
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ViewEntryScreen.routeName, arguments: widget.entry);
          Provider.of<EntryBuilderService>(context, listen: false)
              .setEntry(widget.entry);
          print(widget.entry.date);
        },
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: (widget.entry.image_list!.isNotEmpty),
                        child: widget.entry.image_list!.isNotEmpty
                            ? Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.only(bottom: 12),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.35,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              widget.entry.image_list![0]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('MMMM d, yyyy')
                                .format(widget.entry.date as DateTime),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (widget.entry.position != null)
                            setActivityIconListVIew(
                                widget.entry.position.toString()),
                          if (widget.entry.position != null)
                            const SizedBox(
                              width: 5,
                            ),
                          if (widget.entry.position != null)
                            Text(widget.entry.position.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                          if (widget.entry.mood != null)
                            setMoodIconListView(widget.entry.mood.toString()),
                          if (widget.entry.mood != null)
                            const SizedBox(
                              width: 5,
                            ),
                          if (widget.entry.mood != null)
                            Text(widget.entry.mood.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('EEE, h:mm a').format(widget.entry.date!),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.entry.contentSummery}',
                        overflow: TextOverflow.fade,
                        maxLines: 4,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
