import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNotes extends StatefulWidget {
  Map? todo;
  AddNotes({super.key, this.todo});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  // key will help to change to one to another
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Notes' : 'AddNotes'),
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
                isEdit ? updateData() : submitData();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }

    final id = todo['_id'];

    final title = titleController.text;
    final description = descriptionController.text;
    var url = 'https://api.nstack.in/v1/todos/$id';
    var body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    http.Response response = await http.put(Uri.parse(url),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Eroor');
    }
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
