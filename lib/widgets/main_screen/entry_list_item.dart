import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/entry_data_service.dart';
import '/screens/view_entry_screen.dart';
import '/widgets/main_screen/delete_entry.dart';
import '/models/Entry.dart';

class EntryListItem extends StatelessWidget {
  CollectionReference entryRef;

  EntryListItem({
    Key? key,
    required this.entry,
    required this.entryRef,
  }) : super(key: key);

  final Entry entry;

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
                  return EntryDeleteAlertDialog(
                      entryRef: entryRef, entry: entry);
                },
              )
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) => {},
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ViewEntryScreen.routeName, arguments: entry);
          Provider.of<EntryBuilderService>(context, listen: false)
              .setEntry(entry);
          print(entry.date);
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
                        visible: (entry.image_list!.isNotEmpty),
                        child: entry.image_list!.isNotEmpty
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
                                              entry.image_list![0]),
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
                                .format(entry.date as DateTime),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.run_circle_outlined,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(entry.position.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.mood,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(entry.mood.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('EEE, h:mm a').format(entry.date!),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${entry.contentSummery}',
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
