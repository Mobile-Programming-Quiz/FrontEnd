import 'package:flutter/material.dart';
import 'package:quiz_app/model/model_quiz.dart';
import 'package:quiz_app/screen/screen_home.dart';
import 'package:quiz_app/screen/screen_ranking.dart';
import 'package:quiz_app/screen/screen_my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class ResultScreen extends StatefulWidget {
  final List<int> answers;
  final List<Quiz> quizs;

  ResultScreen({required this.answers, required this.quizs});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _selectedIndex = 0;
  bool _scoreUpdated = false;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print("initState 실행");

    int score = 0;
    for (int i = 0; i < widget.quizs.length; i++) {
      if (widget.quizs[i].answer == widget.answers[i]) {
        score += 1;
      }
    }

    int totalScore = score * 10;
    int maxScore = widget.quizs.length * 10;

    if (!_scoreUpdated) {
      print("점수 업데이트 시작: $totalScore/$maxScore");
      updateUserScore(totalScore, maxScore);
    } else {
      print("점수 업데이트가 이미 완료되었습니다.");
    }

    _screens = [
      HomeScreen(),
      RankingPageView(),
      MyPageScreen(),
    ];
  }



  bool _isUpdatingScore = false; // 상태 플래그 추가

  Future<void> updateUserScore(int totalScore, int maxScore) async {
    if (_isUpdatingScore || _scoreUpdated) return; // 이미 실행 중이거나 저장 완료된 경우 종료
    _isUpdatingScore = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("로그인된 사용자가 없습니다.");
      }

      final userDocRef = FirebaseFirestore.instance.collection('user').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        if (!snapshot.exists) {
          throw Exception("사용자 문서가 존재하지 않습니다.");
        }



        final currentData = snapshot.data()!;
        final int currentCorrectScore = currentData['correctScore']?.toInt() ?? 0;
        final int currentMaxScore = currentData['maxScore']?.toInt() ?? 0;

        // initState가 매번 두번씩 실행되는 것을 확인하여 절반의 값을 더하도록 수정함
        final updatedCorrectScore = currentCorrectScore + totalScore/2;
        final updatedMaxScore = currentMaxScore + maxScore/2;

        transaction.update(userDocRef, {
          'score': totalScore,
          'correctScore': updatedCorrectScore,
          'maxScore': updatedMaxScore,
        });
      });

      print("점수 저장 완료: $totalScore/$maxScore");
      _scoreUpdated = true; // 점수 저장 완료 상태로 설정
    } catch (e) {
      print("점수 저장 중 오류 발생: $e");
    } finally {
      _isUpdatingScore = false;
    }
  }






  Widget _buildResultContent() {
    int score = 0;
    for (int i = 0; i < widget.quizs.length; i++) {
      if (widget.quizs[i].answer == widget.answers[i]) {
        score += 1;
      }
    }

    int totalScore = score * 10;
    int maxScore = widget.quizs.length * 10;
    //
    // // Firestore에 점수 저장 (덮어쓰기)
    // updateUserScore(totalScore, maxScore);

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF7E3AB5), // 보라색 박스
                borderRadius: BorderRadius.circular(25),
              ),
              width: width * 0.85,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // 흰색 박스 추가
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          'Gomoph님의 점수는',
                          style: TextStyle(
                            fontSize: width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$totalScore',
                                style: TextStyle(
                                  fontSize: width * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00DD16), // 점수 색상
                                ),
                              ),
                              TextSpan(
                                text: '/$maxScore',
                                style: TextStyle(
                                  fontSize: width * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA8A8A8), // 총 점수 색상
                                ),
                              ),
                              TextSpan(
                                text: '점 입니다',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '내일 주제 투표하기!',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (int i = 1; i <= 4; i++)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF954FCC), // 버튼 배경색
                            foregroundColor: Colors.white, // 텍스트 색상
                            minimumSize: Size(width * 0.35, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                          onPressed: () {},
                          child: Text('주제$i'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E3AB5),
                    foregroundColor: Colors.white,
                    minimumSize: Size(width * 0.4, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1; // 1번 인덱스는 RankingScreen입니다.
                    });
                  },
                  child: Text(
                    '랭킹 보러 가기',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E3AB5),
                    foregroundColor: Colors.white,
                    minimumSize: Size(width * 0.2, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  onPressed: () {
                    _showShareDialog(context);
                  },
                  child: Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
          child: Image.asset(
            'images/logo.png',
            width: 150,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
      ),
      body: _selectedIndex == 0
          ? _buildResultContent()
          : _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent, // 배경을 투명하게 설정
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 20), // 하단에서 약간 띄우기 위한 마진 추가
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25), // 모든 모서리를 둥글게 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Share',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // 모달 창 닫기
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShareButton(
                        iconPath: 'images/kakao_icon.png', // 카카오톡 아이콘 이미지 경로
                        label: '카카오톡',
                        onPressed: () {
                          // 카카오톡 공유 로직
                        },
                      ),
                      _buildShareButton(
                        iconPath: 'images/instagram_icon.png', // 인스타그램 아이콘 이미지 경로
                        label: '인스타그램',
                        onPressed: () {
                          // 인스타그램 공유 로직
                        },
                      ),
                      _buildShareButton(
                        iconPath: 'images/save_icon.png', // 저장 아이콘 이미지 경로
                        label: '저장',
                        onPressed: () {
                          // 저장 로직
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }



  Widget _buildShareButton({required String iconPath, required String label, required VoidCallback onPressed}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
