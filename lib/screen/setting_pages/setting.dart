import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/screen/login.dart'; // 로그인 페이지 import (로그아웃 후 이동할 페이지)
import 'member_info.dart'; // 회원정보 페이지 import

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png', // Path to 'logo.png' in assets
          width: 150, // Adjust width as needed
        ),
        backgroundColor: Colors.white, // Change AppBar background to white
        centerTitle: true,
        elevation: 0, // Optional: remove shadow
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // 화면 상단 여백 최소화

          // 메뉴 리스트
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // 리스트 좌우 여백 제거
              children: [
                Divider(height: 1, thickness: 1, color: Colors.grey), // 첫 번째 구분선
                _buildMenuItem(context, '회원정보수정', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberInfoPage()), // 이동 코드 추가
                  );
                }),
                _buildMenuItem(context, '로그아웃', () {
                  _showLogoutDialog(context); // 로그아웃 팝업 표시
                }),
                _buildMenuItem(context, '회원탈퇴', () {
                  _showWithdrawalDialog(context); // 회원탈퇴 팝업 표시
                }),
                _buildMenuItem(context, 'FAQ_자주묻는 질문', () {
                  print('FAQ 눌림');
                }),
                _buildMenuItem(context, '테마 변경', () {
                  print('테마 변경 눌림');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 로그아웃 팝업 함수
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 둥근 모서리
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '로그아웃 하시겠습니까?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDialogButton(
                      context,
                      label: '확인',
                      color: Colors.purple,
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
                          Navigator.pop(context); // 팝업 닫기
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 페이지로 이동
                          );
                        } catch (e) {
                          print('로그아웃 실패: $e');
                          Navigator.pop(context); // 팝업 닫기
                        }
                      },
                    ),
                    _buildDialogButton(
                      context,
                      label: '취소',
                      color: Colors.grey,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 회원탈퇴 팝업 함수
  void _showWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 둥근 모서리
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '탈퇴',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '정말 탈퇴하시겠습니까?\n기록이 모두 삭제되며\n다시 복구할 수 없습니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDialogButton(
                      context,
                      label: '탈퇴',
                      color: Colors.purple,
                      onPressed: () {
                        print('탈퇴 확인');
                        Navigator.pop(context);
                      },
                    ),
                    _buildDialogButton(
                      context,
                      label: '취소',
                      color: Colors.grey,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 공통 다이얼로그 버튼 생성
  Widget _buildDialogButton(BuildContext context,
      {required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // 메뉴 아이템을 생성하는 함수
  Widget _buildMenuItem(BuildContext context, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20), // 텍스트를 살짝 오른쪽으로 이동
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          tileColor: Colors.grey[100],
          onTap: onTap,
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey),
      ],
    );
  }
}
