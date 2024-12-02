//원래 signup 페이지
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 패키지 추가
// import 'package:firebase_auth/firebase_auth.dart';
// import 'login.dart'; // LoginPage 파일을 import
//
// const int Btn_Color1 = 0xFF888888; // 예시 색상 (회색)
//
// class SignupPage extends StatelessWidget {
//   SignupPage({super.key});
//
//   final textFieldStyle = const TextStyle(
//     fontFamily: 'MainFont',
//     fontSize: 16,
//   );
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController birthDateController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController schoolController = TextEditingController();
//
//   Future<void> checkDuplicateEmail(BuildContext context) async {
//     final email = emailController.text;
//
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('아이디를 입력해주세요.')),
//       );
//       return;
//     }
//
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('user')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // 중복 아이디가 존재할 때
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('중복된 아이디가 존재합니다.')),
//         );
//       } else {
//         // 사용 가능한 아이디
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('사용 가능한 아이디입니다.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('오류 발생: $e')),
//       );
//     }
//   }
//
//   Future<void> saveUserData(BuildContext context) async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (password != confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
//       );
//       return;
//     }
//
//     try {
//       // Firebase Authentication에 사용자 등록
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//
//       // Firestore에 추가 사용자 정보 저장
//       await FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set({
//         'name': nameController.text,
//         'birthDate': birthDateController.text,
//         'email': email,
//         'school': schoolController.text,
//         'score': 0, // score 필드 추가
//         'correctScore':0, // 누적 정답
//         'maxScore':0, // 누적 푼 문제
//         'scienceScore':0, //과학
//         'historyScore':0, //역사
//         'characterScore':0, //인물
//         'mathScore':0, //수학
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('회원가입 성공!')),
//       );
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('회원가입 실패: $e')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF7E3AB5),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 15),
//                     Image.asset(
//                       'assets/Image/Logo_L.png',
//                       height: 80,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       '똑똑',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'LogoFont',
//                       ),
//                     ),
//                     SizedBox(width: 40),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         label: '이름',
//                         hintText: '',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: nameController,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '생년월일',
//                         hintText: '(YYYYMMDD)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: birthDateController,
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: CustomTextField(
//                               label: '아이디',
//                               hintText: 'example@google.com',
//                               textStyle: textFieldStyle,
//                               labelStyle: TextStyle(
//                                 fontFamily: 'MainFont',
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               height: 50,
//                               controller: emailController,
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                             flex: 1,
//                             child: ElevatedButton(
//                               onPressed: () => checkDuplicateEmail(context),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF45136C),
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: Text(
//                                 '중복검사',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '비밀번호',
//                         hintText: '비밀번호',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: passwordController,
//                         obscureText: true,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '비밀번호 확인',
//                         hintText: '비밀번호 확인',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: confirmPasswordController,
//                         obscureText: true,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '학교(선택)',
//                         hintText: '학교(선택)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: schoolController,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => saveUserData(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF45136C),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       color: Color(0xFFFFFFFF),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomTextField extends StatelessWidget {
//   final String label;
//   final String? hintText;
//   final bool obscureText;
//   final TextStyle textStyle;
//   final TextStyle? labelStyle;
//   final double? width;
//   final double? height;
//   final TextEditingController? controller;
//
//   CustomTextField({
//     required this.label,
//     this.hintText,
//     this.obscureText = false,
//     required this.textStyle,
//     this.labelStyle,
//     this.width,
//     this.height,
//     this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       alignment: Alignment.center,
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: textStyle,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hintText,
//           floatingLabelBehavior: FloatingLabelBehavior.never,
//           labelStyle: labelStyle,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 패키지 추가
// import 'package:firebase_auth/firebase_auth.dart';
// import 'login.dart'; // LoginPage 파일을 import
//
// const int Btn_Color1 = 0xFF888888; // 예시 색상 (회색)
//
// class SignupPage extends StatelessWidget {
//   SignupPage({super.key});
//
//   final textFieldStyle = const TextStyle(
//     fontFamily: 'MainFont',
//     fontSize: 16,
//   );
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController birthDateController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController schoolController = TextEditingController();
//
//   bool isEmailVerified = false; // 이메일 인증 상태 추가
//   bool isVerificationEmailSent = false; // 인증 이메일 발송 여부 추가
//
//   // 이메일 인증 이메일 발송과 중복 검사 동시 처리
//   Future<void> sendVerificationEmailAndCheckDuplicate(BuildContext context) async {
//     final email = emailController.text.trim();
//
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('이메일을 입력해주세요.')),
//       );
//       return;
//     }
//
//     try {
//       // Firestore에서 중복 이메일 체크
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('user')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // 중복된 이메일이 있을 경우
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('중복된 이메일이 존재합니다.')),
//         );
//         return; // 중복된 이메일이 있으면 함수 종료
//       }
//
//       // 중복되지 않은 이메일에 대해 인증 이메일 발송
//       await FirebaseAuth.instance.sendSignInLinkToEmail(
//         email: email,
//         actionCodeSettings: ActionCodeSettings(
//           url: 'https://quizapp-7d724.firebaseapp.com', // Firebase에서 기본 제공하는 URL 사용
//           handleCodeInApp: true,
//           androidPackageName: 'com.example.QuizApp',
//           androidInstallApp: true,
//           androidMinimumVersion: '21',
//         ),
//       );
//
//       isVerificationEmailSent = true; // 인증 이메일 발송 상태 업데이트
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('인증 이메일이 발송되었습니다. 이메일을 확인해주세요.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('이메일 발송 실패: $e')),
//       );
//     }
//   }
//
//
//
//   // 이메일 인증 확인 함수
//   Future<void> checkEmailVerified(BuildContext context) async {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       await user.reload(); // 사용자 정보를 새로고침
//       isEmailVerified = user.emailVerified; // 이메일 인증 상태 업데이트
//
//       if (isEmailVerified) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('이메일 인증이 아직 완료되지 않았습니다.')),
//         );
//       }
//     }
//   }
//
//   Future<void> saveUserData(BuildContext context) async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (password != confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
//       );
//       return;
//     }
//
//     // 이메일 인증 확인
//     if (!isVerificationEmailSent) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('이메일 인증이 필요합니다. 이메일을 확인해주세요.')),
//       );
//       return;
//     }
//
//     try {
//       // Firebase Authentication 계정 생성
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//
//       // Firestore에 사용자 정보 저장
//       await FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set({
//         'name': nameController.text,
//         'birthDate': birthDateController.text,
//         'email': email,
//         'school': schoolController.text,
//         'score': 0,
//         'correctScore': 0,
//         'maxScore': 0,
//         'scienceScore': 0,
//         'historyScore': 0,
//         'characterScore': 0,
//         'mathScore': 0,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('회원가입 성공!')),
//       );
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('회원가입 실패: $e')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF7E3AB5),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 15),
//                     Image.asset(
//                       'assets/Image/Logo_L.png',
//                       height: 80,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       '똑똑',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'LogoFont',
//                       ),
//                     ),
//                     SizedBox(width: 40),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         label: '이메일',
//                         hintText: '',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: emailController,
//                       ),
//                       SizedBox(height: 10),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => sendVerificationEmailAndCheckDuplicate(context),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF45136C),
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: const Text(
//                                 '인증 이메일 발송',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10), // 버튼 간 간격 추가
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => checkEmailVerified(context),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF45136C),
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: const Text(
//                                 '인증 확인',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '이름',
//                         hintText: '',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: nameController,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '생년월일',
//                         hintText: '(YYYYMMDD)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: birthDateController,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '비밀번호',
//                         hintText: '비밀번호',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: passwordController,
//                         obscureText: true,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '비밀번호 확인',
//                         hintText: '비밀번호 확인',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: confirmPasswordController,
//                         obscureText: true,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '학교(선택)',
//                         hintText: '학교(선택)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont',
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                         controller: schoolController,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => saveUserData(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF45136C),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       color: Color(0xFFFFFFFF),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomTextField extends StatelessWidget {
//   final String label;
//   final String? hintText;
//   final bool obscureText;
//   final TextStyle textStyle;
//   final TextStyle? labelStyle;
//   final double? width;
//   final double? height;
//   final TextEditingController? controller;
//
//   CustomTextField({
//     required this.label,
//     this.hintText,
//     this.obscureText = false,
//     required this.textStyle,
//     this.labelStyle,
//     this.width,
//     this.height,
//     this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       alignment: Alignment.center,
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: textStyle,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hintText,
//           floatingLabelBehavior: FloatingLabelBehavior.never,
//           labelStyle: labelStyle,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
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
              ElevatedButton(
                onPressed: () => createAccountAndSendVerification(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45136C),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '계정 생성 및 인증 이메일 발송',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
