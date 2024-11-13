import 'package:flutter/material.dart';
import 'package:quiz_app/screen/screen_home.dart';
import 'package:quiz_app/screen/screen_ranking_school.dart';
import 'package:quiz_app/screen/screen_ranking_total.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // const 생성자 추가

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ranking App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(),
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


