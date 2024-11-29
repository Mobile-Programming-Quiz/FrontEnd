// import 'package:flutter/material.dart';
// import 'package:quiz_app/screen/screen_home.dart';
// import 'package:quiz_app/screen/screen_ranking_school.dart';
// import 'package:quiz_app/screen/screen_ranking_total.dart';
// import 'package:quiz_app/screen/splash.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My Quiz App',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: HomeScreen(),
//       home: const SplashScreen(),
//     );
//   }
// }
//
// class RankingPageView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         children: const [
//           SchoolRankingPage(), // 학교 랭킹 페이지
//           TotalRankingPage(),  // 전체 랭킹 페이지
//         ],
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core 추가
import 'firebase_options.dart'; // Firebase 옵션 파일 추가
import 'package:quiz_app/screen/screen_home.dart';
import 'package:quiz_app/screen/screen_ranking_school.dart';
import 'package:quiz_app/screen/screen_ranking_total.dart';
import 'package:quiz_app/screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase 초기화 전 필수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 구성 파일 사용
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // 초기 화면으로 SplashScreen 설정
    );
  }
}

class RankingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          SchoolRankingPage(), // 학교 랭킹 페이지
          TotalRankingPage(),  // 전체 랭킹 페이지
        ],
      ),
    );
  }
}
