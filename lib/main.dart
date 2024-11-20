import 'package:flutter/material.dart';
import 'package:quiz_app/screen/screen_home.dart';
import 'package:quiz_app/screen/screen_subject.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Quiz App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      // home: SubjectScreen(remainingQuizzes: 5),
    );
  }
}
