import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/models/Tag.dart';
import 'package:provider/provider.dart';
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
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: tagTextController,
                                focusNode: FocusNode(),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add_box_outlined),
                                    onPressed: () {},
                                  ),
                                  labelText: 'Enter Tag',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return tagSearchSugestions.where((doc) =>
                                    jsonEncode(doc)
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()));
                              },
                              itemBuilder: (context, suggestion) {
                                Tag? tag = suggestion as Tag?;
                                return ListTile(
                                  title: Text(
                                      suggestion?.tag.toString() as String),
                                );
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  Tag? tag = suggestion as Tag?;
                                  tags.add(
                                      suggestion?.tag.toString() as String);
                                });
                                print(tags);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please select a city';
                                }
                              },
                              onSaved: (value) => _selectedCity = value!,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            // RaisedButton(
                            //   child: Text('Submit'),
                            //   onPressed: () {
                            //     if (_formKey.currentState.validate()) {
                            //       _formKey.currentState.save();
                            //       Scaffold.of(context).showSnackBar(SnackBar(
                            //           content: Text(
                            //               'Your Favorite City is ${_selectedCity}')));
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Divider(),
                    tags != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Assigned Tags',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        itemCount: tags.length,
                        itemBuilder: (context, index) {
                          return tags != null
                              ? ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  title: Text(tags[index].toString()),
                                  trailing: IconButton(
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.redAccent),
                                      onPressed: () {}))
                              : Center(
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
