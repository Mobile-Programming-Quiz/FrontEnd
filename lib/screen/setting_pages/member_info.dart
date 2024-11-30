import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setting.dart'; // 마이페이지 import

class MemberInfoPage extends StatefulWidget {
  @override
  _MemberInfoPageState createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController(); // 현재 비밀번호 입력 추가
  final TextEditingController _schoolController = TextEditingController();

  bool isEmailAvailable = false; // 이메일 사용 가능 여부 플래그

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose(); // 컨트롤러 해제
    _schoolController.dispose();
    super.dispose();
  }

  // 이메일 중복 확인
  Future<void> _checkEmailAvailability() async {
    try {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일을 입력해주세요.')),
        );
        return;
      }

      // Firestore에서 해당 이메일이 사용 중인지 확인
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isEmailAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
        );
      } else {
        setState(() {
          isEmailAvailable = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용 가능한 이메일입니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 확인 중 오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("로그인된 사용자가 없습니다.");

      final userDocRef = FirebaseFirestore.instance.collection('user').doc(user.uid);

      Map<String, dynamic> updates = {};
      bool passwordChanged = false; // 비밀번호 변경 여부 플래그

      if (_emailController.text.isNotEmpty) {
        if (!isEmailAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이메일 중복 확인을 해주세요.')),
          );
          return;
        }

        updates['email'] = _emailController.text.trim();
        await user.updateEmail(_emailController.text.trim()); // Firebase Authentication 이메일 변경
      }

      if (_passwordController.text.isNotEmpty) {
        if (_currentPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('현재 비밀번호를 입력해주세요.')),
          );
          return;
        }

        try {
          // 재인증
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text.trim(),
          );
          await user.reauthenticateWithCredential(credential);

          // 비밀번호 업데이트
          await user.updatePassword(_passwordController.text.trim());
          passwordChanged = true; // 비밀번호 변경 성공 플래그
        } catch (e) {
          if (e.toString().contains('wrong-password')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('현재 비밀번호가 올바르지 않습니다.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('비밀번호 변경 실패: ${e.toString()}')),
            );
          }
          return; // 비밀번호 변경 실패 시 아래 코드 실행하지 않음
        }
      }

      if (_schoolController.text.isNotEmpty) {
        updates['school'] = _schoolController.text.trim();
      }

      if (updates.isNotEmpty || passwordChanged) {
        if (updates.isNotEmpty) {
          await userDocRef.update(updates); // Firestore 업데이트
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보가 성공적으로 수정되었습니다.')),
        );

        // 마이페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()), // MyPageScreen으로 이동
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('변경할 내용을 입력해주세요.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          width: 150,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF7E3AB5),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildTextField('현재 비밀번호 입력', _currentPasswordController, isPassword: true), // 현재 비밀번호 입력 추가
                    SizedBox(height: 20),
                    _buildTextField('새 비밀번호 입력', _passwordController, isPassword: true),
                    SizedBox(height: 20),
                    _buildTextField('학교 변경', _schoolController),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateUserInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7E3AB5),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(double.infinity, 50),
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
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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
