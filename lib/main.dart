import 'package:flutter/material.dart';
import 'settingpage.dart'; // SettingsPage 파일 import
import 'mypage.dart'; // MyPage import
import 'member_info_page.dart'; // MemberInfoPage import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '똑똑',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: NavigationPage(), // 네비게이션 바를 통한 화면 관리
    );
  }
}

// NavigationPage 정의
class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 2; // '마이페이지'를 기본 화면으로 설정

  // 각 탭에 해당하는 페이지 정의
  final List<Widget> _pages = [
    Center(child: Text('홈 화면')), // 간단한 홈 화면
    Center(child: Text('랭킹 화면')), // 간단한 랭킹 화면
    Mypage(), // 마이페이지
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // 현재 선택된 화면
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경색 흰색
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // 그림자 색상
              spreadRadius: 3, // 그림자 확산
              blurRadius: 5, // 그림자 흐림 정도
              offset: Offset(0, -2), // 그림자 방향 (위쪽)
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // 네비게이션 바 배경색 흰색
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Image/HomeIcon.png')),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Image/RankIcon.png')),
              label: '랭킹',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Image/MypageIcon.png')),
              label: '마이페이지',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.purple, // 선택된 아이템 색상
          unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
          onTap: (index) {
            setState(() {
              _currentIndex = index; // 탭 변경
            });
          },
          elevation: 0, // 기본 그림자 제거
        ),
      ),
    );
  }
}

// MyPage에서 설정 화면을 표시
class Mypage extends StatelessWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Image/Logo_L.png', // 로고 이미지 경로
              height: 50, // 로고 크기
            ),
            SizedBox(width: 12), // 로고와 텍스트 사이 간격
            Text(
              '똑똑',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 36, // 텍스트 크기 더 크게 설정
                fontWeight: FontWeight.bold, // 두껍게
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // 프로필과 상단 간격
            _buildProfileSection(context), // context 전달
            SizedBox(height: 20), // 프로필과 비율 섹션 간격
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200], // 배경색
        borderRadius: BorderRadius.circular(15), // 둥근 모서리
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(150, 150),
                painter: MultiCirclePainter(), // 커스텀 페인터 추가
              ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '홍길동',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            '한성대학교',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '퀴즈 정답률 - 80%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.purple,
            ),
          ),
          Align(
            alignment: Alignment.topRight, // 오른쪽 상단 정렬
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.grey[700]), // 설정 아이콘
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(), // SettingsPage로 이동
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지금까지 총 ___개의 상식을 습득하셨어요!!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          _buildStatBar('과학', 0.8, Colors.blue),
          SizedBox(height: 10),
          _buildStatBar('정치', 0.6, Colors.orange),
          SizedBox(height: 10),
          _buildStatBar('사회', 0.7, Colors.green),
          SizedBox(height: 10),
          _buildStatBar('인문', 0.9, Colors.purple),
          SizedBox(height: 10),
          _buildStatBar('수학', 0.5, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildStatBar(String category, double percentage, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // 배경 막대 색상
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage, // 비율에 따른 너비
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MultiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final List<Color> colors = [
      Colors.blue, // 과학
      Colors.orange, // 정치
      Colors.green, // 사회
      Colors.purple, // 인문
      Colors.pink, // 수학
    ];

    final List<double> percentages = [0.2, 0.3, 0.15, 0.25, 0.1];
    double startAngle = -90.0;

    for (int i = 0; i < colors.length; i++) {
      final sweepAngle = percentages[i] * 360;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 75),
        radians(startAngle),
        radians(sweepAngle),
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double radians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }
}
