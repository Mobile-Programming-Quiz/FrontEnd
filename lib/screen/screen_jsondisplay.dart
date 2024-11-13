import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JsonDisplayScreen extends StatelessWidget {
  final List<dynamic> jsonData;

  JsonDisplayScreen({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          final item = jsonData[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                item.toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
