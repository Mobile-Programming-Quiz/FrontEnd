import 'package:quiz_app/screen/password_page2.dart';
import 'package:flutter/material.dart';
import '../screen/login2.dart'; // LoginPage2를 가져오기

class PasswordSearchPage extends StatefulWidget {
  const PasswordSearchPage({super.key});

  @override
  State<PasswordSearchPage> createState() => _PasswordSearchPageState();
}

class _PasswordSearchPageState extends State<PasswordSearchPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  void _password() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordPage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3), // 배경색 조정
      appBar: AppBar(
        backgroundColor: const Color(0xFF7E3AB5),
        elevation: 0, // AppBar 그림자 제거
        centerTitle: true,
        title: const Text(
          '똑똑',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'LogoFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 위쪽 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 120),
            // 이메일 입력 필드
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '이메일을 입력하세요',
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
                suffixIcon: TextButton(
                  onPressed: () {
                    // 인증번호 전송 로직 추가
                  },
                  child: const Text('인증번호'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey, // primary를 foregroundColor로 변경
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 인증번호 입력 필드
            TextField(
              controller: _verificationController,
              decoration: InputDecoration(
                hintText: '인증번호',
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
                suffixIcon: TextButton(
                  onPressed: () {
                    // 인증번호 확인 로직 추가
                  },
                  child: const Text('확인'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey, // primary를 foregroundColor로 변경
                  ),
                ),
              ),
            ),
            const SizedBox(height: 240),
            // 비밀번호 찾기 버튼
            ElevatedButton(
              onPressed: _password,
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
