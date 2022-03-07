import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/images_service.dart';

displayImagePicker(BuildContext context, images) async {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Images to Your Entry'),
          content: Container(
            width: MediaQuery.of(context).size.width * .9,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: images.length + 1,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo_rounded),
                          onPressed: () {
                            Provider.of<ImagesService>(context, listen: false)
                                .chooseImages(images);
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        ),
                      )
                    : GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            images.removeAt(index - 1);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                images[index - 1],
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        ),
      );
    },
  );
}
