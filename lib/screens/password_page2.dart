import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login2.dart';
import 'password_page.dart';

class PasswordPage2 extends StatefulWidget {
  const PasswordPage2({super.key});

  @override
  State<PasswordPage2> createState() => _PasswordPage2State();
}

class _PasswordPage2State extends State<PasswordPage2> {
  int selectedYear = 2000;
  int selectedMonth = 1;
  int selectedDay = 1;

  final List<int> years = List<int>.generate(100, (index) => 1920 + index); // 1920 ~ 2019
  final List<int> months = List<int>.generate(12, (index) => index + 1); // 1 ~ 12
  final List<int> days = List<int>.generate(31, (index) => index + 1); // 1 ~ 31

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3), // 배경색 설정
      appBar: AppBar(
        backgroundColor: const Color(0xFF7E3AB5),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Image/Logo_L.png', // 로고 이미지 경로 설정
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'APPLOGO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // 생년월일 선택 레이블
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '생년월일',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 연도, 월, 일 선택 Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 연도 Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 70,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = years[index];
                      });
                    },
                    children: years
                        .map((year) => Center(child: Text('$year')))
                        .toList(),
                    scrollController: FixedExtentScrollController(
                      initialItem: years.indexOf(selectedYear),
                    ),
                  ),
                ),
                // 월 Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 70,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = months[index];
                      });
                    },
                    children: months
                        .map((month) => Center(child: Text('$month')))
                        .toList(),
                    scrollController: FixedExtentScrollController(
                      initialItem: months.indexOf(selectedMonth),
                    ),
                  ),
                ),
                // 일 Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 70, // 높이를 60으로 설정하여 더 많은 항목이 보이도록
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDay = days[index];
                      });
                    },
                    children: days
                        .map((day) => Center(child: Text('$day')))
                        .toList(),
                    scrollController: FixedExtentScrollController(
                      initialItem: days.indexOf(selectedDay),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 이름 입력 필드
            TextField(
              decoration: InputDecoration(
                hintText: '이름을 입력하세요',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 240),
            // 아이디 찾기 버튼
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF45136C), // 회원가입 버튼과 동일한 배경색
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // 동일한 패딩 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // 동일한 모서리 반경
                ),
              ),
              child: Text(
                '비밀번호 찾기',
                style: TextStyle(
                  color: Color(0xFFFFFFFF), // 텍스트 색상 (흰색)
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                  fontSize: 20, // 텍스트 크기
                  fontFamily: 'MainFont', // 원하는 폰트 지정
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
