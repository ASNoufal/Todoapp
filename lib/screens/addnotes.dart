import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNotes extends StatefulWidget {
  final Map? todo;
  const AddNotes({super.key, this.todo});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text(isEdit ? 'Edit Notes' : 'AddNotes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: descriptionController,
              maxLength: 100,
              decoration: const InputDecoration(
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
            },
            child: Text(isEdit ? 'Update' : 'Submit'),
          )
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
      showSnackBarid('UPDATE SUCCESFULLY');
      Navigator.of(context).pop();
    } else {
      showSnackBarid('Eroor');
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
      showSnackBarid('SUBMIT SUCCESFULLY');
      Navigator.of(context).pop();
    } else {
      showSnackBarid('Eroor');
    }
  }

  void showSnackBarid(String notes) {
    final snackBar = SnackBar(
      content: Text(
        notes,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
