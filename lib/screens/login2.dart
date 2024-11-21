import 'package:quiz_app/screens/password_page.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:quiz_app/screen/screen_home.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kakao SDK 초기화
    KakaoSdk.init(nativeAppKey: 'YOUR_KAKAO_NATIVE_APP_KEY'); // 실제 키로 대체하세요
  }

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _password_search() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordSearchPage()),
    );
  }

  Future<void> _kakaoLogin() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      // 성공 시 ChatPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print('카카오톡 로그인 실패: $e');
      // 오류 처리
    }
  }

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E3AB5),
      body: Center(
        child: SingleChildScrollView( // 추가된 부분
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150), // 상단 여백 조정
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
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: '아이디 (example@google.com)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _password_search,
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF954FCC),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(170, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // 버튼과 하단의 카카오톡 버튼 사이에 공간 추가
                GestureDetector(
                  onTap: _kakaoLogin,
                  child: Image.asset(
                    'assets/Image/kakaologinbtn.png', // 실제 카카오톡 버튼 이미지 경로로 변경
                    height: 60,
                  ),
                ),
                const SizedBox(height: 20), // 하단 여백
              ],
            ),
          ),
        ),
      ),
    );
  }
}
