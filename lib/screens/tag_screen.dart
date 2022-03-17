// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:provider/provider.dart';
// import '../models/Tag.dart';
// import '../services/entry_data_service.dart';
// import '../services/firestore_service.dart';

// class TagSelectionScreen extends StatefulWidget {
//   static const routeName = '/tags';
//   const TagSelectionScreen({Key? key}) : super(key: key);

//   @override
//   State<TagSelectionScreen> createState() => _TagSelectionScreenState();
// }

// class _TagSelectionScreenState extends State<TagSelectionScreen> {
//   List<dynamic>? selectedTags = [];
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final tagTextController = TextEditingController();
//   List? tags = [];
//   List tagSearchSugestions = [];
//   String _selectedCity = 'asdasd';

//   Future getDocs() async {
//     tagSearchSugestions = (await Provider.of<FirestoreService>(context,
//                 listen: false)
//             .getSearch())
//         .map((tags) {
//           return Tag.fromDocument(tags);
//         })
//         .where(
//             (entry) => entry.userId == FirebaseAuth.instance.currentUser!.uid)
//         .toList();
//     print(tagSearchSugestions);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getDocs();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
//             child: Wrap(
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       children: <Widget>[
//                         TypeAheadFormField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                             controller: tagTextController,
//                             decoration: InputDecoration(
//                               labelText: 'Enter Tag',
//                               suffixIcon: IconButton(
//                                 icon: const Icon(Icons.add_box_outlined),
//                                 onPressed: () {
//                                   setState(
//                                     () {
//                                       Provider.of<FirestoreService>(context,
//                                               listen: false)
//                                           .createTag(
//                                         Tag(
//                                             tag: tagTextController.text,
//                                             userId: FirebaseAuth
//                                                 .instance.currentUser!.uid),
//                                       );
//                                       tags?.add(tagTextController.text);
//                                       tagTextController.clear();
//                                       print('on tage adding button = $tags');
//                                     },
//                                   );
//                                   print('tage added');
//                                   ;
//                                   print(
//                                       'tags in provider = ${Provider.of<EntryBuilderService>(context, listen: false).entry?.tags}');
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                           ),
//                           suggestionsCallback: (pattern) {
//                             return tagSearchSugestions.where(
//                               (doc) => jsonEncode(doc)
//                                   .toLowerCase()
//                                   .contains(pattern.toLowerCase()),
//                             );
//                           },
//                           itemBuilder: (context, suggestion) {
//                             Tag tag = suggestion as Tag;
//                             return ListTile(
//                               title: Text(tag.tag as String),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             Tag tag = suggestion as Tag;
//                             tagTextController.text = tag.tag as String;
//                             tags!.add(tag.tag);
//                             // Provider.of<EntryBuilderService>(context,
//                             //         listen: false)
//                             //     .setTag(tags as List);
//                             print('on suggestionseected = $tags');
//                             print(
//                                 'tags in provider = ${Provider.of<EntryBuilderService>(context, listen: false).entry?.tags}');
//                           },
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please select a city';
//                             }
//                           },
//                           onSaved: (value) {
//                             // tags!.add(value);
//                             Provider.of<EntryBuilderService>(context,
//                                     listen: false)
//                                 .setTag(tags as List);
//                             print(
//                                 'tags in provider = ${Provider.of<EntryBuilderService>(context, listen: false).entry?.tags}');
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10.0,
//                         ),
//                         RaisedButton(
//                           child: Text('Submit'),
//                           onPressed: () {
//                             setState(() {
//                               if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();
//                                 print('meka thma eeka list eka = $tags');
//                                 print(
//                                     'tags in provider = ${Provider.of<EntryBuilderService>(context, listen: false).entry?.tags}');
//                               }
//                             });
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Divider(),
//                 tags == null
//                     ? const Padding(
//                         padding: EdgeInsets.only(left: 15),
//                         child: Text('Assigned Tags',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       )
//                     : Container(),
//                 SizedBox(
//                   height: 200,
//                   child: ListView.builder(
//                     itemCount: tags?.length,
//                     itemBuilder: (context, index) {
//                       return tags != null
//                           ? ListTile(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5.0)),
//                               title: Text(tags![index]!.toString()),
//                               trailing: IconButton(
//                                   icon: const Icon(Icons.remove_circle,
//                                       color: Colors.redAccent),
//                                   onPressed: () async {
//                                     setState(() {
//                                       // tags?.removeAt(index);
//                                       print(tags);
//                                       Provider.of<EntryBuilderService>(context,
//                                               listen: false)
//                                           .setSummery(_selectedCity);

//                                       print(
//                                           'tags in provider = ${Provider.of<EntryBuilderService>(context, listen: false).entry?.contentSummery}');
//                                     });
//                                   }))
//                           : const Center(
//                               child: Text('No Added Tags!'),
//                             );
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
