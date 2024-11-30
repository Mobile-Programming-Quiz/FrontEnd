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
  bool _hasVotedToday = false; // 초기값 false로 선언
  late final List<Widget> _screens;

  // 사용자 이름 상태 변수 추가
  String _userName = "로딩 중..."; // 초기값 설정

  @override
  void initState() {
    super.initState();

    checkVotingStatus();
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

  // Firestore에서 사용자 이름 가져오기
  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _userName = "로그인이 필요합니다.";
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          _userName = userDoc.data()!['name'] ?? "알 수 없는 사용자";
        });
      } else {
        setState(() {
          _userName = "사용자 정보 없음";
        });
      }
    } catch (e) {
      print("사용자 이름 가져오기 오류: $e");
      setState(() {
        _userName = "오류 발생: ${e.toString()}";
      });
    }
  }




  bool _isUpdatingScore = false; // 상태 플래그 추가

  Future<void> checkVotingStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    final docRef = FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .collection('votes')
        .doc(todayString);

    final doc = await docRef.get();
    setState(() {
      _hasVotedToday = doc.exists;
    });
  }

  Future<void> castVote(String voteCategory) async {
    // 사용자가 이미 투표했는지 확인
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    final userVoteDoc = FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .collection('votes')
        .doc(todayString);

    // 하루에 한 번만 투표 가능
    final userVoteSnapshot = await userVoteDoc.get();
    if (userVoteSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오늘은 이미 투표하셨습니다.')),
      );
      return;
    }

    // 투표 컬렉션 업데이트
    final voteDoc = FirebaseFirestore.instance.collection('vote').doc(voteCategory);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final voteSnapshot = await transaction.get(voteDoc);
      if (!voteSnapshot.exists) {
        throw Exception("투표 문서가 존재하지 않습니다.");
      }
      final currentVoteNumber = voteSnapshot.data()?['voteNumber'] ?? 0;
      transaction.update(voteDoc, {
        'voteNumber': currentVoteNumber + 1,
      });
      transaction.set(userVoteDoc, {
        'votedAt': FieldValue.serverTimestamp(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('투표가 완료되었습니다.')),
    );
  }

  Future<void> updateUserScore(int totalScore, int maxScore) async {
    if (_isUpdatingScore || _scoreUpdated) return; // 이미 실행 중이거나 저장 완료된 경우 종료
    _isUpdatingScore = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("로그인된 사용자가 없습니다.");
      }

      final userDocRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final todaySubjectDocRef = FirebaseFirestore.instance.collection('vote').doc('todaySubject');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDocRef);
        final todaySubjectSnapshot = await transaction.get(todaySubjectDocRef);

        if (!userSnapshot.exists) {
          throw Exception("사용자 문서가 존재하지 않습니다.");
        }

        if (!todaySubjectSnapshot.exists) {
          throw Exception("오늘의 주제 문서가 존재하지 않습니다.");
        }

        // 현재 사용자 데이터와 todaySubject 데이터 가져오기
        final currentData = userSnapshot.data()!;
        final todaySubject = todaySubjectSnapshot.data()?['todaySubject'] ?? '';

        final int currentCorrectScore = currentData['correctScore']?.toInt() ?? 0;
        final int currentMaxScore = currentData['maxScore']?.toInt() ?? 0;

        // 현재 점수 가져오기
        int scienceScore = currentData['scienceScore']?.toInt() ?? 0;
        int historyScore = currentData['historyScore']?.toInt() ?? 0;
        int mathScore = currentData['mathScore']?.toInt() ?? 0;
        int characterScore = currentData['characterScore']?.toInt() ?? 0;

        // todaySubject에 따라 점수 추가
        if (todaySubject == 'science') {
          scienceScore += 5;
        } else if (todaySubject == 'history') {
          historyScore += 5;
        } else if (todaySubject == 'math') {
          mathScore += 5;
        } else if (todaySubject == 'character') {
          characterScore += 5;
        }

        // 총 점수 계산
        final updatedCorrectScore = currentCorrectScore + totalScore / 2;
        final updatedMaxScore = currentMaxScore + maxScore / 2;

        // 사용자 문서 업데이트
        transaction.update(userDocRef, {
          'score': totalScore,
          'correctScore': updatedCorrectScore,
          'maxScore': updatedMaxScore,
          'scienceScore': scienceScore,
          'historyScore': historyScore,
          'mathScore': mathScore,
          'characterScore': characterScore,
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
    fetchUserName();
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
                          '$_userName님의 점수는',
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
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF954FCC), // 버튼 배경색
                        foregroundColor: Colors.white, // 텍스트 색상
                        minimumSize: Size(width * 0.35, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),

                        onPressed: () => castVote('science'),
                        child: Text('과학',style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF954FCC), // 버튼 배경색
                        foregroundColor: Colors.white, // 텍스트 색상
                        minimumSize: Size(width * 0.35, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),

                        onPressed: () => castVote('history'),
                        child: Text('역사',style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                      ),
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF954FCC), // 버튼 배경색
                        foregroundColor: Colors.white, // 텍스트 색상
                        minimumSize: Size(width * 0.35, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),

                        onPressed: () => castVote('character'),
                        child: Text('인물',style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                      ),
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF954FCC), // 버튼 배경색
                        foregroundColor: Colors.white, // 텍스트 색상
                        minimumSize: Size(width * 0.35, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),

                        onPressed: () => castVote('math'),
                        child: Text('수학',style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
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
