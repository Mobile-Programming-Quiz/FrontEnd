import 'package:flutter/material.dart';
import 'package:quiz_app/model/model_quiz.dart';
import 'package:quiz_app/screen/screen_quiz.dart';
import 'package:quiz_app/screen/screen_ranking.dart';
import 'package:quiz_app/screen/screen_my_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the quiz list.
  List<Quiz> quizs = [
    Quiz.fromMap({
      'title': 'test',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }),
    Quiz.fromMap({
      'title': 'test2',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 1
    }),
    Quiz.fromMap({
      'title': 'test3',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 2
    }),
  ];

  // Initialize screens with quiz list.
  late final List<Widget> _screens = [
    HomeScreenContent(quizs: quizs), // Passing quiz list
    RankingScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png', // Path to 'logo.png' in assets
          width: 150, // Adjust width as needed
        ),
        backgroundColor: Colors.white, // Change AppBar background to white
        centerTitle: true,
        elevation: 0, // Optional: remove shadow
        toolbarHeight: 100,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨기기
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey, // Optional: set color for unselected items
        backgroundColor: Colors.white, // Set Bottom Navigation Bar background color to white
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final List<Quiz> quizs;
  HomeScreenContent({required this.quizs}); // Constructor to receive quiz list

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Container(
      color: Colors.white, // Set content background to white
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/quiz.jpeg', // Display 'quiz.jpeg' in body content
              width: width * 0.8,
            ),
          ),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          Text(
            '"오늘의 주제"',
            style: TextStyle(fontSize: width * 0.065, fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
          _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.'),
          _buildStep(width, '3. 만점을 향해 도전해보세요!'),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          Container(
            padding: EdgeInsets.only(bottom: width * 0.036),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.7, height * 0.08),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.08, // Increase font size here
                    fontWeight: FontWeight.bold, // Optional: make it bold
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WillPopScope(
                        onWillPop: () async => false, // Prevent back navigation
                        child: QuizScreen(
                          quizs: quizs, // Passing quiz list to QuizScreen
                        ),
                      ),
                      fullscreenDialog: true, // 전체 화면 대화 상자로 표시
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(70, width * 0.024, width * 0.048, width * 0.024), // Left padding of 30
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
