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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => AddNotes(
                        notes: 'AddNotes',
                      ))));
            }),
        body: RefreshIndicator(
          onRefresh: getData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Slidable(
                startActionPane: ActionPane(
                  children: [
                    SlidableAction(
                      onPressed: (context) => deleteitems(),
                      backgroundColor: Colors.red,
                      label: 'Delete',
                      icon: Icons.delete,
                    )
                  ],
                  motion: DrawerMotion(),
                ),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) =>
                              AddNotes(notes: 'EditNotes'))));
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

  void deleteitems() {}

  Future<void> getData() async {
    var url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
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
}
