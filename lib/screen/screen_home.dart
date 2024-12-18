import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/model/model_quiz.dart';
import 'package:quiz_app/screen/screen_quiz.dart';
import 'package:quiz_app/screen/screen_ranking_page_view.dart';
import 'package:quiz_app/screen/screen_my_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/screen/screen_subject.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Quiz> quizs = [];
  String? todaySubject;
  bool _isLoading = true;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchQuizzes() async {
    try {
      // 'vote' 컬렉션에서 'todaySubject' 문서 가져오기
      final todaySubjectDoc = await FirebaseFirestore.instance
          .collection('vote')
          .doc('todaySubject')
          .get();

      todaySubject = todaySubjectDoc.data()?['todaySubject'] as String?;
      int? subjectSet = todaySubjectDoc.data()?['${todaySubject}Set'] as int?;

      if (todaySubject == null || subjectSet == null) {
        throw Exception('오늘의 주제 또는 주제 설정 값이 없습니다.');
      }

      // 해당 주제에 대한 퀴즈 리스트 가져오기
      final doc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(todaySubject)
          .get();

      final data = doc.data();
      final quizList = data?['quizList'] as List<dynamic>?;

      if (quizList != null) {
        setState(() {
          // used 필드와 subjectSet 값이 동일한 문제만 필터링
          quizs = quizList
              .where((quiz) => quiz['used'] == subjectSet) // 필터 조건
              .map((quiz) => Quiz.fromMap(quiz))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('퀴즈 데이터를 가져오는 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // 동적으로 스크린 리스트 반환
  List<Widget> getScreens() {
    return [
      HomeScreenContent(quizs: quizs, todaySubject: todaySubject, currentUser: currentUser), // 현재 사용자 전달
      RankingPageView(),
      MyPageScreen(),
    ];
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
        title: Image.asset(
          'images/logo.png',
          width: 150,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 화면
          : getScreens()[_selectedIndex], // 동적으로 스크린 렌더링
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
}

class HomeScreenContent extends StatelessWidget {
  final List<Quiz> quizs;
  final String? todaySubject;
  final User? currentUser;

  HomeScreenContent({required this.quizs, required this.todaySubject, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    if (currentUser == null) {
      return Center(child: Text("로그인 상태를 확인해주세요."));
    }

    // Firestore에서 실시간으로 사용자의 score 값을 가져오기
    Stream<DocumentSnapshot> userScoreStream = FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser!.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userScoreStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("사용자 정보를 가져올 수 없습니다."));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final userScore = userData?['score'] as int? ?? 0;

        bool isStartButtonEnabled = userScore == 0;

        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  _getImagePathForSubject(),
                  width: width * 0.8,
                ),
              ),
              Padding(padding: EdgeInsets.all(width * 0.024)),
              Text(
                '"오늘의 퀴즈 : ${_getSubjectName()}"',
                style: TextStyle(fontSize: width * 0.065, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.all(width * 0.024)),
              _buildStep(width, '1. 해당 주제에 대한 퀴즈 10개를 풀어보세요.'),
              _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.\n힌트는 최대 3개까지만 볼 수 있습니다.'),
              _buildStep(width, '3. 만점을 향해 도전해보세요!'),
              Padding(padding: EdgeInsets.all(width * 0.024)),
              Container(
                padding: EdgeInsets.only(bottom: width * 0.036),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width * 0.7, height * 0.08),
                        backgroundColor: isStartButtonEnabled ? Colors.deepPurple : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        'START',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: isStartButtonEnabled
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WillPopScope(
                              onWillPop: () async => false,
                              child: QuizScreen(
                                quizs: quizs,
                              ),
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                          : null,
                    ),
                    SizedBox(height: 10), // 버튼과 문구 사이 여백
                    if (!isStartButtonEnabled)
                      Text(
                        '오늘의 퀴즈를 이미 푸셨습니다.',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.red, // 문구 색상
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSubjectName() {
    if (todaySubject == "character") return "인물";
    if (todaySubject == "history") return "역사";
    if (todaySubject == "math") return "수학";
    if (todaySubject == "science") return "과학";
    return "";
  }

  String _getImagePathForSubject() {
    if (todaySubject == "character") return 'images/character.png';
    if (todaySubject == "history") return 'images/history.png';
    if (todaySubject == "math") return 'images/math.png';
    if (todaySubject == "science") return 'images/science.png';
    return 'images/quiz.jpeg';
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(70, width * 0.024, width * 0.048, width * 0.024),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.check_box, size: width * 0.04),
          Padding(padding: EdgeInsets.only(right: width * 0.024)),
          Text(title),
        ],
      ),
    );
  }
}
