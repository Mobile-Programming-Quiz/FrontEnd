import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 추가
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

  // Firebase를 사용한 비밀번호 재설정 이메일 전송 로직
  void sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호 재설정 이메일이 전송되었습니다.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생: ${e.toString()}")),
      );
    }
  }

  void _password() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드에 의해 화면 크기 조정
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
      body: SingleChildScrollView( // 스크롤 가능하도록 변경
        child: Padding(
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
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        sendPasswordResetEmail(email); // 비밀번호 재설정 이메일 전송 호출
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("이메일을 입력하세요.")),
                        );
                      }
                    },
                    child: const Text('발송하기'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey, // primary를 foregroundColor로 변경
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 240), // 여백 유지
              // 비밀번호 찾기 버튼
              ElevatedButton(
                onPressed: _password,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // 회원가입 버튼과 동일한 배경색
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // 동일한 패딩 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // 동일한 모서리 반경
                  ),
                ),
                child: const Text(
                  '로그인하러 가기',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF), // 텍스트 색상 (흰색)
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                    fontSize: 20, // 텍스트 크기
                    fontFamily: 'MainFont', // 원하는 폰트 지정
                  ),
                ),
              ),
              const SizedBox(height: 20), // 추가 여백
            ],
          ),
        ),
      ),
    );
  }
}
