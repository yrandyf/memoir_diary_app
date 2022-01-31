import 'package:flutter/material.dart';

class DiaryEntryList extends StatelessWidget {
  const DiaryEntryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Card(
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                title: Text('Title'),
                subtitle: Text('Sub Title'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Card(
//               elevation: 5,
//               margin: EdgeInsets.all(5),
//               child: 
//             ),
