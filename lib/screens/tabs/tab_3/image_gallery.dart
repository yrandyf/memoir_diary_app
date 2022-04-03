import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/Entry.dart';
import 'view_images.dart';

class ImageGalleryTab extends StatefulWidget {
  const ImageGalleryTab({Key? key}) : super(key: key);

  @override
  State<ImageGalleryTab> createState() => _ImageGalleryTabState();
}

class _ImageGalleryTabState extends State<ImageGalleryTab> {
  var entryRef = FirebaseFirestore.instance
      .collection("entries")
      .orderBy("entry_date", descending: true);
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: entryRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> entries) {
        if (entries.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var userEntryList = entries.data!.docs
            .map((entry) {
              return Entry.fromDocument(entry);
            })
            .where((entry) =>
                entry.userId == FirebaseAuth.instance.currentUser!.uid &&
                entry.image_list!.isNotEmpty)
            .toList();

        return CustomScrollView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          userEntryList[index].image_list![0],
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
                      onTap: () => Navigator.of(context).pushNamed(
                          ImageViewer.routeName,
                          arguments: userEntryList[index].image_list));
                },
                childCount: userEntryList.length,
              ),
            ),
          ],
        );
      },
    ));
  }
}
