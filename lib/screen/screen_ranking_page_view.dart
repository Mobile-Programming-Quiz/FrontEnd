import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_ranking_school.dart'; // 학교 랭킹 페이지
import 'screen_ranking_total.dart'; // 전체 랭킹 페이지

class RankingPageView extends StatefulWidget {
  const RankingPageView({super.key});

  @override
  _RankingPageViewState createState() => _RankingPageViewState();
}

class _RankingPageViewState extends State<RankingPageView> {
  int _currentIndex = 0; // 현재 PageView 페이지 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          SchoolRankingPage(), // 학교 랭킹 페이지
          TotalRankingPage(), // 전체 랭킹 페이지
        ],
      ),

    );
  }
}
