import 'package:flutter/material.dart';
import 'settingpage.dart'; // SettingsPage import

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
            Icon(Icons.lightbulb, color: Colors.purple, size: 30),
            SizedBox(width: 10),
            Text(
              '똑똑',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: 0.8, // 총 비율 예시값 (80%)
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // 첫 번째 색상
                  backgroundColor: Colors.purple, // 나머지 부분 색상
                ),
              ),
              CircleAvatar(
                radius: 50,
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
