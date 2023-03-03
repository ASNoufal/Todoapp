import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNotes extends StatelessWidget {
  String notes;
  AddNotes({super.key, required this.notes});
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // key will help to change to one to another

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notes),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: descriptionController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                submitData();
                Navigator.of(context).pop();
              },
              child: Text('Submit'))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    var url = 'https://api.nstack.in/v1/todos';
    var body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    http.Response response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      print('Eroor');
    }
  }
}
