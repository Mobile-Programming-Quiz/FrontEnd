import 'package:flutter/material.dart';

class MemberInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // AppBar 그림자 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        toolbarHeight: 80, // AppBar 높이
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Image/Logo_L.png', // 로고 이미지 경로
              height: 50, // 로고 크기
            ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20), // 상단 여백
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // 배경색
                  borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.purple,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            print('사진 변경 클릭');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE7E7E7), // 연한 회색
                            side: BorderSide(
                              color: Color(0xFFBABABA), // 테두리 색상
                              width: 1.5,
                            ),
                            elevation: 0, // 그림자 제거
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            '사진 변경하기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7E7E7E), // 텍스트 색상
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // 간격 추가
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('닉네임 변경'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            print('중복 확인 클릭');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE7E7E7), // 연한 회색
                            side: BorderSide(
                              color: Color(0xFFBABABA), // 테두리 색상
                              width: 1.5,
                            ),
                            elevation: 0, // 그림자 제거
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            '중복확인',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7E7E7E), // 텍스트 색상
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // 필드 간 간격
                    _buildTextField('비밀번호 변경'),
                    SizedBox(height: 20),
                    _buildTextField('학교 변경'),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        print('수정하기 클릭');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7E3AB5), // 보라색
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(double.infinity, 50), // 버튼 넓이 설정
                      ),
                      child: Text(
                        '수정하기',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // 그림자 효과
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/Image/HomeIcon.png'),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/Image/RankIcon.png'),
              ),
              label: '랭킹',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/Image/MypageIcon.png'),
              ),
              label: '마이페이지',
            ),
          ],
          currentIndex: 2,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pop(context);
                break;
              case 1:
                print('랭킹 탭 클릭');
                break;
              case 2:
                print('마이페이지 탭 클릭');
                break;
            }
          },
        ),
      ),
    );
  }

  // 텍스트 필드 생성 함수
  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
