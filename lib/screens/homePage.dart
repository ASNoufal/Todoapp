import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todooapp/screens/addnotes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
          ),
          backgroundColor: Colors.green[200],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green[300],
            child: const Icon(Icons.add),
            onPressed: () {
              navigatetonextpage();
            }),
        body: RefreshIndicator(
          onRefresh: getData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text('No Notes'),
            ),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final id = item['_id'];

                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deleteitems(id),
                        backgroundColor:
                            const Color.fromARGB(255, 237, 114, 106),
                        label: 'Delete',
                        icon: Icons.delete,
                      )
                    ],
                  ),
                  child: Card(
                    color: Colors.green[200],
                    child: ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          navigatetoeditpage(item);
                        },
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }

  Future<void> deleteitems(String id) async {
    var url = 'https://api.nstack.in/v1/todos/$id';
    http.Response response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      final delete = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = delete;
      });
    } else {
      showSnackBar('Eroor');
    }
  }

  Future<void> getData() async {
    var url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = response.body;
      items = jsonDecode(data)['items'];
      setState(() {
        items;
      });
    } else {
      showSnackBar('Eroor');
    }
  }

  Future<void> navigatetonextpage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddNotes(),
    );
    await Navigator.of(context).push(route);
    getData();
  }

  Future<void> navigatetoeditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddNotes(todo: item),
    );
    await Navigator.of(context).push(route);
    getData();
  }

  void showSnackBar(String notes) {
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
