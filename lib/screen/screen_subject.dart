import 'package:flutter/material.dart';

class SubjectScreen extends StatefulWidget {
  final int remainingQuizzes; // 남은 퀴즈 수를 외부에서 전달받음

  SubjectScreen({required this.remainingQuizzes});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // 화면 너비
    final height = MediaQuery.of(context).size.height; // 화면 높이

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png', // Path to 'logo.png' in assets
          width: 150, // 화면 너비의 40%로 로고 크기 조정
        ),
        backgroundColor: Colors.white, // Change AppBar background to white
        centerTitle: true,
        elevation: 0, // Optional: remove shadow
        toolbarHeight: 100, // AppBar 높이를 화면 높이에 비례하게 설정

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "랭킹"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "마이페이지"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      body: Column(
        children: [
          // 슬라이드 박스
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.remainingQuizzes, // 동적으로 변경되는 슬라이드 갯수
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    width: width * 0.8, // 화면 너비의 80%
                    height: height * 0.4, // 화면 높이의 30%
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/quiz.jpeg', // 이미지 경로
                          width: width * 0.6, // 화면 너비의 60%로 이미지 크기 조정
                          height: height * 0.2, // 화면 높이의 20%로 이미지 크기 조정
                          fit: BoxFit.cover, // 이미지 크기 비율 유지
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "퀴즈 제목\n${index + 1} 페이지",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.05, // 화면 너비에 비례한 글자 크기
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Start 버튼과 하단 텍스트 (말풍선)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      width * 0.7, // 화면 너비의 70%
                      height * 0.08, // 화면 높이의 8%
                    ),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // 버튼 클릭 이벤트
                  },
                  child: Text(
                    "START",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.08, // 화면 너비의 5%로 글자 크기 조정
                      fontWeight: FontWeight.bold, // 굵은 텍스트
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                // 텍스트 박스 디자인
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple, // 박스 배경색
                    borderRadius: BorderRadius.circular(15), // 둥근 모서리
                  ),
                  child: Text(
                    widget.remainingQuizzes > 0
                        ? "${widget.remainingQuizzes}일 정도 늦었어요!!" // 남은 퀴즈에 따라 텍스트 변경
                        : "퀴즈를 모두 풀었어요!!", // 남은 퀴즈가 없을 때
                    style: TextStyle(
                      fontSize: width * 0.04, // 화면 너비의 4%로 글자 크기 조정
                      color: Colors.white, // 텍스트 색상
                    ),
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선 화살표를 그리는 커스텀 페인터
class BubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(10, 10);
    path.lineTo(-10, 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
