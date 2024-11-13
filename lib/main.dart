import 'package:flutter/material.dart';
import 'screens/login.dart'; // 로그인 화면 가져오기
import 'screens/splash.dart'; // 스플래시 화면 가져오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Main Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // 시작 화면을 스플래시 화면으로 설정
    );
  }
}
