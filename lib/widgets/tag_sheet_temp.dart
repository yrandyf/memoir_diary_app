import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/models/Tag.dart';
import 'package:provider/provider.dart';
import '../services/entry_data_service.dart';
import '../services/firestore_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Future<dynamic> tagModalSheet(BuildContext context, _formKey, tagTextController,
    entryRef, tags, tagSearchSugestions) {
  List<dynamic>? selectedTags = [];
  String _selectedCity = '';
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Wrap(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: tagTextController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Tag',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add_box_outlined),
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Provider.of<FirestoreService>(
                                                    context,
                                                    listen: false)
                                                .createTag(
                                              Tag(
                                                  tag: tagTextController.text,
                                                  userId: FirebaseAuth.instance
                                                      .currentUser!.uid),
                                            );
                                            tags?.add(tagTextController.text);
                                            tagTextController.clear();
                                            print(
                                                'on tage adding button = $tags');
                                          }
                                        },
                                      );
                                      print('tag added');
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return tagSearchSugestions.where(
                                  (doc) => jsonEncode(doc)
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()),
                                );
                              },
                              itemBuilder: (context, suggestion) {
                                Tag tag = suggestion as Tag;
                                return ListTile(
                                  title: Text(tag.tag as String),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                Tag tag = suggestion as Tag;
                                tagTextController.text = tag.tag as String;
                                tags!.add(tag.tag);
                                tagTextController.clear();

                                print('on suggestionseected = $tags');
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please select a city';
                                }
                              },
                              onSaved: (value) {
                                tags!.add(value);
                                print('tags on saved print= ${tags}');
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            // RaisedButton(
                            //   child: Text('Submit'),
                            //   onPressed: () {
                            //     setState(() {
                            //       if (_formKey.currentState!.validate()) {
                            //         _formKey.currentState!.save();
                            //         print('meka thma eeka list eka = $tags');
                            //       }
                            //     });
                            //   },
                            // )
                          ],
                        ),
                      ),
                    ),
                    // Divider(),
                    tags == null
                        ? const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Assigned Tags',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: tags?.length,
                        itemBuilder: (context, index) {
                          return tags != null
                              ? ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  title: Text(tags![index]!.toString()),
                                  trailing: IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.redAccent),
                                      onPressed: () async {
                                        setState(() {
                                          tags?.removeAt(index);
                                          print('Tag removed! $tags');
                                        });
                                      }))
                              : const Center(
                                  child: Text('No Added Tags!'),
                                );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}