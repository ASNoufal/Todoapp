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
        appBar: AppBar(title: Text('Notes')),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              navigatetonextpage();
            }),
        body: RefreshIndicator(
          onRefresh: getData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['_id'];

              return Slidable(
                startActionPane: ActionPane(
                  children: [
                    SlidableAction(
                      onPressed: (context) => deleteitems(id),
                      backgroundColor: Colors.red,
                      label: 'Delete',
                      icon: Icons.delete,
                    )
                  ],
                  motion: StretchMotion(),
                ),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigatetoeditpage(item);
                    },
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                ),
              );
            },
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
      print('Eroor');
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
      print('Eroor');
    }
  }

  Future<void> navigatetonextpage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddNotes(),
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
}
