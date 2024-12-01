import 'package:flutter/material.dart';
import 'package:quiz_app/model/model_quiz.dart';
import 'package:quiz_app/screen/screen_quiz.dart';
import 'package:quiz_app/screen/screen_ranking_page_view.dart';
import 'package:quiz_app/screen/screen_my_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/screen/screen_subject.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Quiz> quizs = [];
  String? todaySubject;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final todaySubjectDoc = await FirebaseFirestore.instance
          .collection('vote')
          .doc('todaySubject')
          .get();

      todaySubject = todaySubjectDoc.data()?['todaySubject'] as String?;



      if (todaySubject == null) {
        throw Exception('오늘의 주제가 설정되지 않았습니다.');
      }

      final doc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(todaySubject) // todaySubject 동적 사용
          .get();

      final data = doc.data();
      final quizList = data?['quizList'] as List<dynamic>?;

      if (quizList != null) {
        setState(() {
          quizs = quizList.map((quiz) => Quiz.fromMap(quiz)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('퀴즈 데이터를 가져오는 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // 동적으로 스크린 리스트 반환
  List<Widget> getScreens() {
    return [
      HomeScreenContent(quizs: quizs, todaySubject: todaySubject), // todaySubject 전달
      RankingPageView(),
      MyPageScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 화면
          : getScreens()[_selectedIndex], // 동적으로 스크린 렌더링
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}


class HomeScreenContent extends StatelessWidget {
  final List<Quiz> quizs;
  final String? todaySubject;

  HomeScreenContent({required this.quizs, required this.todaySubject});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Container(
      color: Colors.white, // Set content background to white
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              _getImagePathForSubject(), // Display 'quiz.jpeg' in body content
              width: width * 0.8,
            ),
          ),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          Text(
            '"오늘의 퀴즈 : ${_getSubjectName()} "',
            style: TextStyle(fontSize: width * 0.065, fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
          _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.'),
          _buildStep(width, '3. 만점을 향해 도전해보세요!'),
          Padding(padding: EdgeInsets.all(width * 0.024)),
          Container(
            padding: EdgeInsets.only(bottom: width * 0.036),
            child: Column(
              children: [
                // START 버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.7, height * 0.08),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.08, // Increase font size here
                      fontWeight: FontWeight.bold, // Optional: make it bold
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WillPopScope(
                          onWillPop: () async => false, // Prevent back navigation
                          child: QuizScreen(
                            quizs: quizs, // Passing quiz list to QuizScreen
                          ),
                        ),
                        fullscreenDialog: true, // 전체 화면 대화 상자로 표시
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // 이전 문제 풀러 가기 버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.7, height * 0.04),
                    backgroundColor: Colors.grey, // 버튼 색상 변경
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    '안 푼 문제 풀러 가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06, // 글자 크기 약간 작게 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectScreen(
                          remainingQuizzes: 5, // 예시로 남은 퀴즈 수 전달
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _getSubjectName() {
    // 특정 조건에 따라 todaySubject 값 수정
    if (todaySubject == "character") {
      return "인물";
    }
    else if (todaySubject == "history") {
      return "역사";
    }
    else if (todaySubject == "math") {
      return "수학";
    }
    else if (todaySubject == "science") {
      return "과학";
    }
    else return "";
  }

  // todaySubject 값에 따라 이미지 경로를 반환하는 함수 추가
  String _getImagePathForSubject() {
    if (todaySubject == "character") {
      return 'images/character.png';
    } else if (todaySubject == "history") {
      return 'images/history.png';
    } else if (todaySubject == "math") {
      return 'images/math.png';
    } else if (todaySubject == "science") {
      return 'images/science.png';
    }
    // 기본 로고 이미지 반환
    return 'images/quiz.jpeg';
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(70, width * 0.024, width * 0.048, width * 0.024), // Left padding of 30
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.check_box, size: width * 0.04),
          Padding(padding: EdgeInsets.only(right: width * 0.024)),
          Text(title),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:quiz_app/model/model_quiz.dart';
// import 'package:quiz_app/screen/screen_quiz.dart';
// import 'package:quiz_app/screen/screen_ranking.dart';
// import 'package:quiz_app/screen/screen_my_page.dart';
// import 'package:quiz_app/screen/screen_subject.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../main.dart'; // screen_subject 추가
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   // 퀴즈 데이터를 Firestore에서 가져오기 위해 비동기 로딩
//   List<Quiz> quizs = [];
//   bool _isLoading = true; // 로딩 상태
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizzes(); // Firestore에서 데이터 가져오기
//   }
//
//   // Firestore에서 데이터를 가져오는 메서드
//   Future<void> _fetchQuizzes() async {
//     try {
//       final quizCollection = FirebaseFirestore.instance
//           .collection('quizzes') // Firestore에서 'quizzes' 컬렉션 사용
//           .doc('science') // 'science' 문서 선택
//           .get();
//
//       // Firestore에서 데이터를 가져옴
//       final quizData = await quizCollection;
//       final quizList = quizData.data()?['quizList'] as List<dynamic>?;
//
//       if (quizList != null) {
//         setState(() {
//           // Firestore 데이터 파싱하여 Quiz 모델로 변환
//           quizs = quizList.map((quiz) => Quiz.fromMap(quiz)).toList();
//           _isLoading = false; // 로딩 상태 종료
//         });
//       }
//     } catch (e) {
//       print('퀴즈 데이터를 가져오는 중 오류 발생: $e');
//       setState(() {
//         _isLoading = false; // 오류 발생 시 로딩 상태 종료
//       });
//     }
//   }
//   // Initialize screens with quiz list.
//   late final List<Widget> _screens = [
//     HomeScreenContent(quizs: quizs), // Passing quiz list
//     RankingPageView(),
//     MyPageScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Set background color to white
//       appBar: AppBar(
//         title: Image.asset(
//           'images/logo.png', // Path to 'logo.png' in assets
//           width: 150, // Adjust width as needed
//         ),
//         backgroundColor: Colors.white, // Change AppBar background to white
//         centerTitle: true,
//         elevation: 0, // Optional: remove shadow
//         toolbarHeight: 100,
//         automaticallyImplyLeading: false, // 뒤로가기 버튼 숨기기
//       ),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '랭킹'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Colors.grey, // Optional: set color for unselected items
//         backgroundColor: Colors.white, // Set Bottom Navigation Bar background color to white
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
// class HomeScreenContent extends StatelessWidget {
//   final List<Quiz> quizs;
//   HomeScreenContent({required this.quizs}); // Constructor to receive quiz list
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//     double height = screenSize.height;
//
//     return Container(
//       color: Colors.white, // Set content background to white
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Image.asset(
//               'images/quiz.jpeg', // Display 'quiz.jpeg' in body content
//               width: width * 0.8,
//             ),
//           ),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           Text(
//             '"오늘의 주제"',
//             style: TextStyle(fontSize: width * 0.065, fontWeight: FontWeight.bold),
//           ),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
//           _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.'),
//           _buildStep(width, '3. 만점을 향해 도전해보세요!'),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           Container(
//             padding: EdgeInsets.only(bottom: width * 0.036),
//             child: Column(
//               children: [
//                 // START 버튼
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(width * 0.7, height * 0.08),
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   ),
//                   child: Text(
//                     'START',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: width * 0.08, // Increase font size here
//                       fontWeight: FontWeight.bold, // Optional: make it bold
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WillPopScope(
//                           onWillPop: () async => false, // Prevent back navigation
//                           child: QuizScreen(
//                             quizs: quizs, // Passing quiz list to QuizScreen
//                           ),
//                         ),
//                         fullscreenDialog: true, // 전체 화면 대화 상자로 표시
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 // 이전 문제 풀러 가기 버튼
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(width * 0.7, height * 0.04),
//                     backgroundColor: Colors.grey, // 버튼 색상 변경
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                   child: Text(
//                     '안 푼 문제 풀러 가기',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: width * 0.06, // 글자 크기 약간 작게 설정
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubjectScreen(
//                           remainingQuizzes: 5, // 예시로 남은 퀴즈 수 전달
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStep(double width, String title) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(70, width * 0.024, width * 0.048, width * 0.024), // Left padding of 30
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Icon(Icons.check_box, size: width * 0.04),
//           Padding(padding: EdgeInsets.only(right: width * 0.024)),
//           Text(title),
//         ],
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:quiz_app/model/model_quiz.dart';
// import 'package:quiz_app/screen/screen_quiz.dart';
// import 'package:quiz_app/screen/screen_ranking_page_view.dart';
// import 'package:quiz_app/screen/screen_my_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quiz_app/screen/screen_subject.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   List<Quiz> quizs = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizzes();
//   }
//
//   Future<void> _fetchQuizzes() async {
//     try {
//       // 먼저 todaySubject 데이터를 가져오기
//       final todaySubjectDoc = await FirebaseFirestore.instance
//           .collection('vote')
//           .doc('todaySubject')
//           .get();
//
//       final todaySubject = todaySubjectDoc.data()?['todaySubject'] as String?;
//       if (todaySubject == null) {
//         throw Exception('오늘의 주제가 설정되지 않았습니다.');
//       }
//
//       // todaySubject 기반으로 퀴즈 데이터를 가져오기
//       final doc = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(todaySubject) // 동적으로 todaySubject 사용
//           .get();
//
//       final data = doc.data();
//       final quizList = data?['quizList'] as List<dynamic>?;
//
//       if (quizList != null) {
//         setState(() {
//           quizs = quizList.map((quiz) => Quiz.fromMap(quiz)).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('퀴즈 데이터를 가져오는 중 오류 발생: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // 동적으로 스크린 리스트 반환
//   List<Widget> getScreens() {
//     return [
//       HomeScreenContent(quizs: quizs), // 동적 데이터 반영
//       RankingPageView(),
//       MyPageScreen(),
//     ];
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Image.asset(
//           'images/logo.png',
//           width: 150,
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         toolbarHeight: 100,
//         automaticallyImplyLeading: false,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator()) // 로딩 화면
//           : getScreens()[_selectedIndex], // 동적으로 스크린 렌더링
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '랭킹'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
//
// class HomeScreenContent extends StatelessWidget {
//   final List<Quiz> quizs;
//   HomeScreenContent({required this.quizs});
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//     double height = screenSize.height;
//
//     return Container(
//       color: Colors.white, // Set content background to white
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Image.asset(
//               'images/quiz.jpeg', // Display 'quiz.jpeg' in body content
//               width: width * 0.8,
//             ),
//           ),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           Text(
//             '"오늘의 주제"',
//             style: TextStyle(fontSize: width * 0.065, fontWeight: FontWeight.bold),
//           ),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
//           _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.'),
//           _buildStep(width, '3. 만점을 향해 도전해보세요!'),
//           Padding(padding: EdgeInsets.all(width * 0.024)),
//           Container(
//             padding: EdgeInsets.only(bottom: width * 0.036),
//             child: Column(
//               children: [
//                 // START 버튼
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(width * 0.7, height * 0.08),
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   ),
//                   child: Text(
//                     'START',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: width * 0.08, // Increase font size here
//                       fontWeight: FontWeight.bold, // Optional: make it bold
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WillPopScope(
//                           onWillPop: () async => false, // Prevent back navigation
//                           child: QuizScreen(
//                             quizs: quizs, // Passing quiz list to QuizScreen
//                           ),
//                         ),
//                         fullscreenDialog: true, // 전체 화면 대화 상자로 표시
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 // 이전 문제 풀러 가기 버튼
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(width * 0.7, height * 0.04),
//                     backgroundColor: Colors.grey, // 버튼 색상 변경
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                   child: Text(
//                     '안 푼 문제 풀러 가기',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: width * 0.06, // 글자 크기 약간 작게 설정
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubjectScreen(
//                           remainingQuizzes: 5, // 예시로 남은 퀴즈 수 전달
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildStep(double width, String title) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(70, width * 0.024, width * 0.048, width * 0.024), // Left padding of 30
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Icon(Icons.check_box, size: width * 0.04),
//           Padding(padding: EdgeInsets.only(right: width * 0.024)),
//           Text(title),
//         ],
//       ),
//     );
//   }
// }
