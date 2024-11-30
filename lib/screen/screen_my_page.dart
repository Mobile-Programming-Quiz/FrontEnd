import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setting_pages/setting.dart'; // SettingsPage import

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _name = '로딩 중...'; // 기본 이름
  String _school = '로딩 중...'; // 기본 학교
  double _correctRate = 0.0; // 초기 정답률
  int _correctScore = 0;
  int _maxScore = 0;

  // 각 점수 초기화
  int _scienceScore = 0;
  int _historyScore = 0;
  int _characterScore = 0;
  int _mathScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Firestore 데이터 로드
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("로그인된 사용자가 없습니다.");
      }

      print("사용자 UID: ${user.uid}");

      final userDoc = await FirebaseFirestore.instance
          .collection('user') // Firestore 컬렉션 이름 확인
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        print("Firestore 데이터: $data");

        setState(() {
          _name = data['name'] ?? '이름 없음';
          _school = data['school'] ?? '학교 없음';
          _correctScore = (data['correctScore'] as num).toInt();
          _maxScore = (data['maxScore'] as num).toInt();
          _correctRate = _correctScore / _maxScore;

          // 각 점수 업데이트
          _scienceScore = (data['scienceScore'] as num).toInt();
          _historyScore = (data['historyScore'] as num).toInt();
          _characterScore = (data['characterScore'] as num).toInt();
          _mathScore = (data['mathScore'] as num).toInt();
        });
      } else {
        print("사용자 문서가 Firestore에 없습니다.");
        setState(() {
          _name = '사용자 정보 없음';
          _school = '학교 정보 없음';
        });
      }
    } catch (e) {
      print("사용자 데이터 로드 중 오류 발생: $e");
      setState(() {
        _name = '오류 발생';
        _school = '오류 발생';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // 프로필과 상단 간격
            _buildProfileSection(context),
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
                  value: _correctRate, // 정답률
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
            _name, // Firestore에서 가져온 이름
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            _school, // Firestore에서 가져온 학교 이름
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '퀴즈 정답률 - ${(_correctRate * 100).toStringAsFixed(1)}%', // Firestore에서 계산한 정답률
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
            '지금까지 총 ${(_maxScore / 10).toInt()}개의 상식을 습득하셨어요!!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          // 점수 비율을 바 반영
          _buildStatBar('과학', _scienceScore / 100, Colors.blue),
          SizedBox(height: 10),
          _buildStatBar('역사', _historyScore / 100, Colors.orange),
          SizedBox(height: 10),
          _buildStatBar('인물', _characterScore / 100, Colors.green),
          SizedBox(height: 10),
          _buildStatBar('수학', _mathScore / 100, Colors.purple),
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
                widthFactor: percentage.clamp(0.0, 1.0), // 비율 제한
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



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'setting_pages/setting.dart'; // SettingsPage import
//
// class MyPageScreen extends StatefulWidget {
//   const MyPageScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyPageScreen> createState() => _MyPageScreenState();
// }
//
// class _MyPageScreenState extends State<MyPageScreen> {
//   String _name = '로딩 중...'; // 기본 이름
//   String _school = '로딩 중...'; // 기본 학교
//   double _correctRate = 0.0; // 초기 정답률
//   int _correctScore =0;
//   int _maxScore=0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData(); // Firestore 데이터 로드
//   }
//
//   Future<void> _fetchUserData() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception("로그인된 사용자가 없습니다.");
//       }
//
//       print("사용자 UID: ${user.uid}");
//
//       final userDoc = await FirebaseFirestore.instance
//           .collection('user') // Firestore 컬렉션 이름 확인
//           .doc(user.uid)
//           .get();
//
//       if (userDoc.exists && userDoc.data() != null) {
//         final data = userDoc.data()!;
//         print("Firestore 데이터: $data");
//
//         setState(() {
//           _name = data['name'] ?? '이름 없음';
//           _school = data['school'] ?? '학교 없음';
//           _correctScore = (data['correctScore'] as num).toInt();
//           _maxScore = (data['maxScore'] as num).toInt();
//           _correctRate = _correctScore / _maxScore;
//         });
//       } else {
//         print("사용자 문서가 Firestore에 없습니다.");
//         setState(() {
//           _name = '사용자 정보 없음';
//           _school = '학교 정보 없음';
//         });
//       }
//     } catch (e) {
//       print("사용자 데이터 로드 중 오류 발생: $e");
//       setState(() {
//         _name = '오류 발생';
//         _school = '오류 발생';
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20), // 프로필과 상단 간격
//             _buildProfileSection(context), // context 전달
//             SizedBox(height: 20), // 프로필과 비율 섹션 간격
//             _buildStatisticsSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileSection(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.grey[200], // 배경색
//         borderRadius: BorderRadius.circular(15), // 둥근 모서리
//       ),
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 height: 120,
//                 width: 120,
//                 child: CircularProgressIndicator(
//                   value: _correctRate, // 정답률
//                   strokeWidth: 8,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // 첫 번째 색상
//                   backgroundColor: Colors.purple, // 나머지 부분 색상
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.person,
//                   size: 50,
//                   color: Colors.purple,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             _name, // Firestore에서 가져온 이름
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           Text(
//             _school, // Firestore에서 가져온 학교 이름
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.black54,
//             ),
//           ),
//           SizedBox(height: 5),
//           Text(
//             '퀴즈 정답률 - ${(_correctRate * 100).toStringAsFixed(1)}%', // Firestore에서 계산한 정답률
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.purple,
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight, // 오른쪽 상단 정렬
//             child: IconButton(
//               icon: Icon(Icons.settings, color: Colors.grey[700]), // 설정 아이콘
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsPage(), // SettingsPage로 이동
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatisticsSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '지금까지 총 ${(_maxScore / 10).toInt()}개의 상식을 습득하셨어요!!',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           _buildStatBar('과학', 0.8, Colors.blue),
//           SizedBox(height: 10),
//           _buildStatBar('역사', 0.6, Colors.orange),
//           SizedBox(height: 10),
//           _buildStatBar('인물', 0.7, Colors.green),
//           SizedBox(height: 10),
//           _buildStatBar('수학', 0.9, Colors.purple),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatBar(String category, double percentage, Color color) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             category,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 8,
//           child: Stack(
//             children: [
//               Container(
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300], // 배경 막대 색상
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               FractionallySizedBox(
//                 widthFactor: percentage, // 비율에 따른 너비
//                 child: Container(
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
