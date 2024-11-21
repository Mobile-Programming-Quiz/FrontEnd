import 'package:quiz_app/screens/login2.dart';
import 'package:quiz_app/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screen/screen_home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void nav_login() {
    // 로그인 로직 추가
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage2()),
    );
  }

  void nav_signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E3AB5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7E3AB5),
        elevation: 0, // AppBar 그림자 제거
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 125.0, left: 16.0, right: 16.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start, // Column을 위쪽 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 로고 이미지
            Image.asset(
              'assets/Image/Logo_L.png', // 실제 이미지 경로로 변경
              height: 150,
            ),
            const SizedBox(height: 5),
            const Text(
              '똑똑',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'LogoFont',
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 30),

            // 회원가입 및 로그인 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: nav_signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45136C), // 버튼 배경색
                    foregroundColor: Colors.white, // 버튼 텍스트 색상
                    minimumSize: const Size(150, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontFamily: 'MainFont',
                      fontSize: 22, // 텍스트 크기 조정
                      fontWeight: FontWeight.bold, // 필요 시 텍스트 굵기 조정
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: nav_login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF954FCC), // 로그인 버튼 배경색
                    foregroundColor: Colors.white, // 로그인 버튼 텍스트 색상
                    minimumSize: const Size(150,65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'MainFont',
                      fontSize: 22, // 텍스트 크기 조정
                      fontWeight: FontWeight.bold, // 필요 시 텍스트 굵기 조정
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
