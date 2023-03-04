import 'package:flutter/material.dart';
import 'package:todooapp/screens/homePage.dart';

class LetStartPage extends StatefulWidget {
  const LetStartPage({super.key});

  @override
  State<LetStartPage> createState() => _LetStartPageState();
}

class _LetStartPageState extends State<LetStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text('Todo App',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/writingsketch.jpeg',
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ListTile(
              title: Text("Welcome to TodoApp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
              subtitle: Text(
                'Todo will helps you to create,\nEdit,Delete the notes',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const HomePage())));
                }),
                child: Container(
                  width: 300,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      "Lets'Start",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
