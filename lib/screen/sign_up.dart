import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 패키지 추가
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // LoginPage 파일을 import

const int Btn_Color1 = 0xFF888888; // 예시 색상 (회색)

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final textFieldStyle = const TextStyle(
    fontFamily: 'MainFont',
    fontSize: 16,
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();

  Future<void> checkDuplicateEmail(BuildContext context) async {
    final email = emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디를 입력해주세요.')),
      );
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 중복 아이디가 존재할 때
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('중복된 아이디가 존재합니다.')),
        );
      } else {
        // 사용 가능한 아이디
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용 가능한 아이디입니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  Future<void> saveUserData(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (password != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      // Firebase Authentication에 사용자 등록
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Firestore에 추가 사용자 정보 저장
      await FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'birthDate': birthDateController.text,
        'email': email,
        'school': schoolController.text,
        'score': 0, // score 필드 추가
        'correctScore':0, // 누적 정답
        'maxScore':0, // 누적 푼 문제
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7E3AB5),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 15),
                    Image.asset(
                      'assets/Image/Logo_L.png',
                      height: 80,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '똑똑',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'LogoFont',
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: '이름',
                        hintText: '',
                        labelStyle: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textStyle: textFieldStyle,
                        height: 50,
                        controller: nameController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: '생년월일',
                        hintText: '(YYYYMMDD)',
                        labelStyle: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textStyle: textFieldStyle,
                        height: 50,
                        controller: birthDateController,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              label: '아이디',
                              hintText: 'example@google.com',
                              textStyle: textFieldStyle,
                              labelStyle: TextStyle(
                                fontFamily: 'MainFont',
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                              height: 50,
                              controller: emailController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () => checkDuplicateEmail(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF45136C),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                '중복검사',
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
                      SizedBox(height: 10),
                      CustomTextField(
                        label: '비밀번호',
                        hintText: '비밀번호',
                        labelStyle: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textStyle: textFieldStyle,
                        height: 50,
                        controller: passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: '비밀번호 확인',
                        hintText: '비밀번호 확인',
                        labelStyle: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textStyle: textFieldStyle,
                        height: 50,
                        controller: confirmPasswordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: '학교(선택)',
                        hintText: '학교(선택)',
                        labelStyle: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textStyle: textFieldStyle,
                        height: 50,
                        controller: schoolController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => saveUserData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45136C),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
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
  final TextStyle? labelStyle;
  final double? width;
  final double? height;
  final TextEditingController? controller;

  CustomTextField({
    required this.label,
    this.hintText,
    this.obscureText = false,
    required this.textStyle,
    this.labelStyle,
    this.width,
    this.height,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: textStyle,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: labelStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'login.dart'; // LoginPage 파일을 import
//
// // 외부에서 Btn_Color1 변수를 정의
// const int Btn_Color1 = 0xFF888888; // 예시 색상 (회색)
//
// class SignupPage extends StatelessWidget {
//   const SignupPage({super.key});
//
//   // 텍스트 필드 스타일을 상수로 정의하지 않고 인스턴스 변수로 선언
//   final textFieldStyle = const TextStyle(
//     fontFamily: 'MainFont', // 원하는 폰트 패밀리 이름을 지정
//     fontSize: 16,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF7E3AB5), // 배경색 설정
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Align(
//             alignment: Alignment.topCenter, // 상단 정렬
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start, // 위쪽 정렬
//               children: [
//                 // 로고와 '부기부기' 텍스트
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 15), // 좌측 여백
//                     Image.asset(
//                       'assets/Image/Logo_L.png', // 로고 파일 경로 설정
//                       height: 80,
//                     ),
//                     SizedBox(width: 10), // 로고와 텍스트 사이의 간격 조정
//                     Text(
//                       '똑똑',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'LogoFont', // 원하는 폰트 설정
//                       ),
//                     ),
//                     SizedBox(width: 40), // 우측 여백
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 // 이름 입력 필드
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         label: '이름',
//                         hintText: '',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '생년월일',
//                         hintText: '(YYYYMMDD)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomTextField(
//                               label: '아이디',
//                               hintText: 'example@google.com',
//                               textStyle: textFieldStyle,
//                               labelStyle: TextStyle(
//                                 fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               height: 50,
//                             )
//                           ),
//                           SizedBox(width: 10), // 텍스트 필드와 버튼 사이 간격
//                           OutlinedButton(
//                             onPressed: () {
//                               // 버튼 클릭 시 동작 추가
//                             },
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(width: 2.0, color: const Color(0xFFBABABA)), // 테두리 두께 및 색상
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15.0), // 모서리 반경을 설정
//                               ),
//                               backgroundColor: const Color(0xFFE7E7E7), // 버튼의 배경색 설정
//                               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 패딩 조정
//                             ),
//                             child: Text(
//                               '인증번호',
//                               style: TextStyle(
//                                 color: Color(Btn_Color1), // 텍스트 색상 설정
//                                 fontWeight: FontWeight.bold, // 텍스트 스타일 설정
//                                 fontFamily: 'MainFont',
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomTextField(
//                               label: '인증번호',
//                               hintText: '인증번호를 입력하세요',
//                               labelStyle: TextStyle(
//                                 fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               textStyle: textFieldStyle,
//                               height: 50,
//                             ),
//                           ),
//                           SizedBox(width: 10), // 텍스트 필드와 버튼 사이 간격
//                           OutlinedButton(
//                             onPressed: () {
//                               // 버튼 클릭 시 동작 추가
//                             },
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(width: 2.0, color: const Color(0xFFBABABA)), // 테두리 두께 및 색상
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15.0), // 모서리 반경을 설정
//                               ),
//                               backgroundColor: const Color(0xFFE7E7E7), // 버튼의 배경색 설정
//                               padding: EdgeInsets.symmetric(horizontal: 32.8, vertical: 15), // 패딩 조정
//                             ),
//                             child: Text(
//                               '확인',
//                               style: TextStyle(
//                                 color: Color(Btn_Color1), // 텍스트 색상 설정
//                                 fontWeight: FontWeight.bold, // 텍스트 스타일 설정
//                                 fontFamily: 'MainFont',
//                                 fontSize: 15,
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
//                           fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '비밀번호 확인',
//                         hintText: '비밀번호 확인',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                       ),
//                       SizedBox(height: 10),
//                       CustomTextField(
//                         label: '학교(선택)',
//                         hintText: '학교(선택)',
//                         labelStyle: TextStyle(
//                           fontFamily: 'MainFont', // 원하는 폰트 패밀리 지정
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         textStyle: textFieldStyle,
//                         height: 50,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const LoginPage()),
//                     );
//                   },
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
// // 커스텀 텍스트 필드 위젯
// class CustomTextField extends StatelessWidget {
//   final String label;
//   final String? hintText;
//   final bool obscureText;
//   final TextStyle textStyle;
//   final TextStyle? labelStyle; // labelStyle 추가
//   final double? width;
//   final double? height;
//
//   CustomTextField({
//     required this.label,
//     this.hintText,
//     this.obscureText = false,
//     required this.textStyle,
//     this.labelStyle, // labelStyle 추가
//     this.width,
//     this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.0), // 둥근 모서리 설정
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16), // 텍스트 필드 안쪽 여백
//       alignment: Alignment.center,
//       child: TextFormField(
//         obscureText: obscureText,
//         style: textStyle,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hintText,
//           floatingLabelBehavior: FloatingLabelBehavior.never,
//           labelStyle: labelStyle, // labelStyle 설정
//           border: InputBorder.none, // 기본 테두리 제거
//         ),
//       ),
//     );
//   }
// }

