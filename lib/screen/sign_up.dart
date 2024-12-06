import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();

  bool isEmailVerified = false; // 이메일 인증 상태
  User? user; // 현재 사용자

  Future<void> createAccountAndSendVerification(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
      return;
    }

    try {
      // Firebase Authentication을 통해 계정 생성
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;

      // 이메일 인증 발송
      await user!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 이메일이 발송되었습니다. 이메일을 확인해주세요.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계정 생성 실패: $e')),
      );
    }
  }

  // 이메일 인증 확인 함수
  Future<void> checkEmailVerified(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload(); // 사용자 정보를 새로고침
      isEmailVerified = user.emailVerified; // 이메일 인증 상태 업데이트

      if (isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증이 아직 완료되지 않았습니다.')),
        );
      }
    }
  }

  Future<void> saveUserData(BuildContext context) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정을 먼저 생성하고 인증을 완료해주세요.')),
      );
      return;
    }

    try {
      // 사용자 정보 새로고침
      await user!.reload();
      user = FirebaseAuth.instance.currentUser; // 새로고침 후 사용자 다시 가져오기
      isEmailVerified = user!.emailVerified;

      if (!isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증이 완료되지 않았습니다.')),
        );
        return;
      }

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
        'name': nameController.text.trim(),
        'birthDate': birthDateController.text.trim(),
        'email': user!.email,
        'school': schoolController.text.trim(),
        'score': 0,
        'correctScore': 0,
        'maxScore': 0,
        'scienceScore': 0,
        'historyScore': 0,
        'characterScore': 0,
        'mathScore': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );

      // 회원가입 완료 후 페이지 이동
      Navigator.of(context).pop(); // 예: 이전 페이지로 돌아가기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E3AB5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                label: '이메일',
                hintText: '',
                textStyle: const TextStyle(fontSize: 16),
                controller: emailController,
                height: 50,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: '비밀번호',
                hintText: '비밀번호',
                textStyle: const TextStyle(fontSize: 16),
                controller: passwordController,
                height: 50,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () => createAccountAndSendVerification(context),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color(0xFF45136C),
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              //   child: const Text(
              //     '계정 생성 및 인증 이메일 발송',
              //     style: TextStyle(color: Colors.white, fontSize: 16),
              //   ),
              // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => createAccountAndSendVerification(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF45136C),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                '인증 이메일 발송',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // 버튼 간 간격 추가
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async => await checkEmailVerified(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF45136C),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                '인증 확인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              const SizedBox(height: 20),
              CustomTextField(
                label: '이름',
                hintText: '',
                textStyle: const TextStyle(fontSize: 16),
                controller: nameController,
                height: 50,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: '생년월일',
                hintText: '(YYYYMMDD)',
                textStyle: const TextStyle(fontSize: 16),
                controller: birthDateController,
                height: 50,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: '학교 (선택)',
                hintText: '',
                textStyle: const TextStyle(fontSize: 16),
                controller: schoolController,
                height: 50,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => saveUserData(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45136C),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextStyle textStyle;
  final TextEditingController? controller;
  final double? height;

  const CustomTextField({
    required this.label,
    this.hintText,
    this.obscureText = false,
    required this.textStyle,
    this.controller,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: textStyle,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
