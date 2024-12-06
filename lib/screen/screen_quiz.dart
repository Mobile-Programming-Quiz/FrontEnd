// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:lottie/lottie.dart';
// import '../model/model_quiz.dart';
// import 'screen_result.dart';
//
// class QuizScreen extends StatefulWidget {
//   final List<Quiz> quizs;
//
//   QuizScreen({required this.quizs});
//
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   List<int> _answers = [];
//   List<Color> _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//   int _currentIndex = 0;
//   int _selectedIndex = -1;
//   SwiperController _controller = SwiperController();
//   int _remainingTime = 20;
//   late Timer _timer;
//   bool _isAnimating = false;
//   String? _currentAnimation;
//   bool _isHintVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _answers = List.filled(widget.quizs.length, -1); // 정답 초기화
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingTime > 0) {
//         setState(() {
//           _remainingTime--;
//         });
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   // 다음 문제로 이동
//   void _nextQuestion() {
//     if (_currentIndex < widget.quizs.length - 1) {
//       setState(() {
//         _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//         _selectedIndex = -1;
//         _currentIndex += 1;
//         _controller.next();
//         _remainingTime = 20;
//         _isHintVisible = false;
//       });
//     } else {
//       _timer.cancel();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             answers: _answers,
//             quizs: widget.quizs,
//           ),
//         ),
//       );
//     }
//   }
//
//   // 애니메이션을 표시
//   void _showAnimation(String fileName) {
//     setState(() {
//       _isAnimating = true;
//       _currentAnimation = fileName;
//     });
//
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isAnimating = false;
//         _currentAnimation = null;
//       });
//
//       if (_currentIndex == widget.quizs.length - 1) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultScreen(
//               answers: _answers,
//               quizs: widget.quizs,
//             ),
//           ),
//         );
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//
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
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             // 남은 시간 상태바
//             Container(
//               width: width * 0.85,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: (width * 0.85) * (_remainingTime / 20),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       '남은 시간: $_remainingTime 초',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // 문제 및 선택지
//             SizedBox(
//               height: screenSize.height * 0.6,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: width * 0.85,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.deepPurple),
//                       color: Colors.transparent,
//                     ),
//                     child: Swiper(
//                       controller: _controller,
//                       physics: NeverScrollableScrollPhysics(),
//                       loop: false,
//                       itemCount: widget.quizs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return _buildQuizCard(widget.quizs[index], width);
//                       },
//                     ),
//                   ),
//                   // Lottie 애니메이션
//                   if (_isAnimating && _currentAnimation != null)
//                     Lottie.asset(
//                       'images/$_currentAnimation',
//                       width: 200,
//                       height: 200,
//                       fit: BoxFit.contain,
//                     ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//
//             // 힌트 버튼
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.lightbulb_outline,
//                     color: Colors.deepPurple,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isHintVisible = !_isHintVisible;
//                     });
//                   },
//                 ),
//                 if (_isHintVisible)
//                   Container(
//                     margin: EdgeInsets.only(left: 8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.yellow[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.deepPurple),
//                     ),
//                     child: Text(
//                       widget.quizs[_currentIndex].hint ?? '힌트가 없습니다.',
//                       style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuizCard(Quiz quiz, double width) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           'Q${_currentIndex + 1}.',
//           style: TextStyle(
//             fontSize: width * 0.06,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           quiz.title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: width * 0.048,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 20),
//         ..._buildCandidates(width, quiz),
//         SizedBox(height: 40),
//         // NEXT 버튼
//         ElevatedButton(
//           child: Text(
//             _currentIndex == widget.quizs.length - 1 ? '결과보기' : 'NEXT',
//             style: TextStyle(
//               fontSize: width * 0.06,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.deepPurple,
//             minimumSize: Size(width * 0.7, 70),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           onPressed: _answers[_currentIndex] == -1
//               ? null
//               : () {
//             setState(() {
//               for (int i = 0; i < 4; i++) {
//                 if (i == quiz.answer) {
//                   _answerColors[i] = Colors.green;
//                 } else if (i == _selectedIndex) {
//                   _answerColors[i] = Colors.red;
//                 } else {
//                   _answerColors[i] = Colors.transparent;
//                 }
//               }
//             });
//
//             bool isCorrect = _answers[_currentIndex] == quiz.answer;
//             String fileName = isCorrect ? "correct.json" : "wrong.json";
//
//             _showAnimation(fileName);
//           },
//         ),
//       ],
//     );
//   }
//
//   List<Widget> _buildCandidates(double width, Quiz quiz) {
//     return List.generate(4, (i) {
//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             _selectedIndex = i;
//             _answers[_currentIndex] = i;
//
//             for (int j = 0; j < 4; j++) {
//               _answerColors[j] = j == i ? Colors.deepPurple : Colors.transparent;
//             }
//           });
//         },
//         child: Container(
//           width: width * 0.7,
//           margin: EdgeInsets.symmetric(vertical: 8),
//           padding: EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: _answerColors[i],
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.deepPurple, width: 2),
//           ),
//           child: Center(
//             child: Text(
//               quiz.candidates[i],
//               style: TextStyle(
//                 fontSize: width * 0.05,
//                 fontWeight: FontWeight.bold,
//                 color: _answerColors[i] == Colors.transparent ? Colors.black : Colors.white,
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:lottie/lottie.dart';
import '../model/model_quiz.dart';
import 'screen_result.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final List<Quiz> quizs;

  QuizScreen({required this.quizs});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> _answers = [];
  List<Color> _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
  int _currentIndex = 0;
  int _selectedIndex = -1;
  SwiperController _controller = SwiperController();
  int _remainingTime = 20;
  late Timer _timer;
  bool _isAnimating = false;
  String? _currentAnimation;
  bool _isHintVisible = false;

  @override
  void initState() {
    super.initState();
    // used 필드가 false인 문제들만 필터링하여 10개만 랜덤으로 선택하도록 수정
    List<Quiz> availableQuizzes = widget.quizs.where((quiz) => quiz.used == false).toList();
    availableQuizzes.shuffle();
    widget.quizs.clear();
    widget.quizs.addAll(availableQuizzes.take(10));

    // 선택된 10문제의 used 필드를 true로 변경
    widget.quizs.forEach((quiz) => quiz.used = true);

    _answers = List.filled(10, -1); // 정답 초기화
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  // 다음 문제로 이동
  void _nextQuestion() {
    if (_currentIndex < 9) { // 총 10문제만 출제되므로
      setState(() {
        _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
        _selectedIndex = -1;
        _currentIndex += 1;
        _controller.next();
        _remainingTime = 20;
        _isHintVisible = false;
      });
    } else {
      _timer.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            answers: _answers,
            quizs: widget.quizs.sublist(0, 10), // 첫 10문제만 결과화면에 전달
          ),
        ),
      );
    }
  }

  // 애니메이션을 표시
  void _showAnimation(String fileName) {
    setState(() {
      _isAnimating = true;
      _currentAnimation = fileName;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isAnimating = false;
        _currentAnimation = null;
      });

      if (_currentIndex == 9) { // 마지막 문제였을 경우 결과화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              answers: _answers,
              quizs: widget.quizs.sublist(0, 10),
            ),
          ),
        );
      } else {
        _nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // 남은 시간 상태바
            Container(
              width: width * 0.85,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Container(
                    width: (width * 0.85) * (_remainingTime / 20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Center(
                    child: Text(
                      '남은 시간: $_remainingTime 초',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 문제 및 선택지
            SizedBox(
              height: screenSize.height * 0.6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple),
                      color: Colors.transparent,
                    ),
                    child: Swiper(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      loop: false,
                      itemCount: 10, // 문제 개수 10개로 제한
                      itemBuilder: (BuildContext context, int index) {
                        return _buildQuizCard(widget.quizs[index], width);
                      },
                    ),
                  ),
                  // Lottie 애니메이션
                  if (_isAnimating && _currentAnimation != null)
                    Lottie.asset(
                      'images/$_currentAnimation',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // 힌트 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHintVisible = !_isHintVisible;
                    });
                  },
                ),
                if (_isHintVisible)
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    child: Text(
                      widget.quizs[_currentIndex].hint ?? '힌트가 없습니다.',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Q${_currentIndex + 1}.',
          style: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          quiz.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.048,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ..._buildCandidates(width, quiz),
        SizedBox(height: 40),
        // NEXT 버튼
        ElevatedButton(
          child: Text(
            _currentIndex == 9 ? '결과보기' : 'NEXT',
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            minimumSize: Size(width * 0.7, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _answers[_currentIndex] == -1
              ? null
              : () {
            setState(() {
              for (int i = 0; i < 4; i++) {
                if (i == quiz.answer) {
                  _answerColors[i] = Colors.green;
                } else if (i == _selectedIndex) {
                  _answerColors[i] = Colors.red;
                } else {
                  _answerColors[i] = Colors.transparent;
                }
              }
            });

            bool isCorrect = _answers[_currentIndex] == quiz.answer;
            String fileName = isCorrect ? "correct.json" : "wrong.json";

            _showAnimation(fileName);
          },
        ),
      ],
    );
  }

  List<Widget> _buildCandidates(double width, Quiz quiz) {
    return List.generate(4, (i) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = i;
            _answers[_currentIndex] = i;

            for (int j = 0; j < 4; j++) {
              _answerColors[j] = j == i ? Colors.deepPurple : Colors.transparent;
            }
          });
        },
        child: Container(
          width: width * 0.7,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _answerColors[i],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          child: Center(
            child: Text(
              quiz.candidates[i],
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
                color: _answerColors[i] == Colors.transparent ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:lottie/lottie.dart';
// import '../model/model_quiz.dart';
// import 'screen_result.dart';
// import 'dart:math';
//
// class QuizScreen extends StatefulWidget {
//   final List<Quiz> quizs;
//
//   QuizScreen({required this.quizs});
//
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   List<int> _answers = [];
//   List<Color> _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//   int _currentIndex = 0;
//   int _selectedIndex = -1;
//   SwiperController _controller = SwiperController();
//   int _remainingTime = 20;
//   late Timer _timer;
//   bool _isAnimating = false;
//   String? _currentAnimation;
//   bool _isHintVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // 문제를 10개만 랜덤으로 선택하도록 수정
//     widget.quizs.shuffle();
//     _answers = List.filled(10, -1); // 정답 초기화
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingTime > 0) {
//         setState(() {
//           _remainingTime--;
//         });
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   // 다음 문제로 이동
//   void _nextQuestion() {
//     if (_currentIndex < 9) { // 총 10문제만 출제되므로
//       setState(() {
//         _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//         _selectedIndex = -1;
//         _currentIndex += 1;
//         _controller.next();
//         _remainingTime = 20;
//         _isHintVisible = false;
//       });
//     } else {
//       _timer.cancel();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             answers: _answers,
//             quizs: widget.quizs.sublist(0, 10), // 첫 10문제만 결과화면에 전달
//           ),
//         ),
//       );
//     }
//   }
//
//   // 애니메이션을 표시
//   void _showAnimation(String fileName) {
//     setState(() {
//       _isAnimating = true;
//       _currentAnimation = fileName;
//     });
//
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isAnimating = false;
//         _currentAnimation = null;
//       });
//
//       if (_currentIndex == 9) { // 마지막 문제였을 경우 결과화면으로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultScreen(
//               answers: _answers,
//               quizs: widget.quizs.sublist(0, 10),
//             ),
//           ),
//         );
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//
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
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             // 남은 시간 상태바
//             Container(
//               width: width * 0.85,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: (width * 0.85) * (_remainingTime / 20),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       '남은 시간: $_remainingTime 초',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // 문제 및 선택지
//             SizedBox(
//               height: screenSize.height * 0.6,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: width * 0.85,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.deepPurple),
//                       color: Colors.transparent,
//                     ),
//                     child: Swiper(
//                       controller: _controller,
//                       physics: NeverScrollableScrollPhysics(),
//                       loop: false,
//                       itemCount: 10, // 문제 개수 10개로 제한
//                       itemBuilder: (BuildContext context, int index) {
//                         return _buildQuizCard(widget.quizs[index], width);
//                       },
//                     ),
//                   ),
//                   // Lottie 애니메이션
//                   if (_isAnimating && _currentAnimation != null)
//                     Lottie.asset(
//                       'images/$_currentAnimation',
//                       width: 200,
//                       height: 200,
//                       fit: BoxFit.contain,
//                     ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//
//             // 힌트 버튼
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.lightbulb_outline,
//                     color: Colors.deepPurple,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isHintVisible = !_isHintVisible;
//                     });
//                   },
//                 ),
//                 if (_isHintVisible)
//                   Container(
//                     margin: EdgeInsets.only(left: 8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.yellow[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.deepPurple),
//                     ),
//                     child: Text(
//                       widget.quizs[_currentIndex].hint ?? '힌트가 없습니다.',
//                       style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuizCard(Quiz quiz, double width) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           'Q${_currentIndex + 1}.',
//           style: TextStyle(
//             fontSize: width * 0.06,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           quiz.title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: width * 0.048,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 20),
//         ..._buildCandidates(width, quiz),
//         SizedBox(height: 40),
//         // NEXT 버튼
//         ElevatedButton(
//           child: Text(
//             _currentIndex == 9 ? '결과보기' : 'NEXT',
//             style: TextStyle(
//               fontSize: width * 0.06,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.deepPurple,
//             minimumSize: Size(width * 0.7, 70),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           onPressed: _answers[_currentIndex] == -1
//               ? null
//               : () {
//             setState(() {
//               for (int i = 0; i < 4; i++) {
//                 if (i == quiz.answer) {
//                   _answerColors[i] = Colors.green;
//                 } else if (i == _selectedIndex) {
//                   _answerColors[i] = Colors.red;
//                 } else {
//                   _answerColors[i] = Colors.transparent;
//                 }
//               }
//             });
//
//             bool isCorrect = _answers[_currentIndex] == quiz.answer;
//             String fileName = isCorrect ? "correct.json" : "wrong.json";
//
//             _showAnimation(fileName);
//           },
//         ),
//       ],
//     );
//   }
//
//   List<Widget> _buildCandidates(double width, Quiz quiz) {
//     return List.generate(4, (i) {
//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             _selectedIndex = i;
//             _answers[_currentIndex] = i;
//
//             for (int j = 0; j < 4; j++) {
//               _answerColors[j] = j == i ? Colors.deepPurple : Colors.transparent;
//             }
//           });
//         },
//         child: Container(
//           width: width * 0.7,
//           margin: EdgeInsets.symmetric(vertical: 8),
//           padding: EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: _answerColors[i],
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.deepPurple, width: 2),
//           ),
//           child: Center(
//             child: Text(
//               quiz.candidates[i],
//               style: TextStyle(
//                 fontSize: width * 0.05,
//                 fontWeight: FontWeight.bold,
//                 color: _answerColors[i] == Colors.transparent ? Colors.black : Colors.white,
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }






































// 퀴즈 used 변수 적용 시도중인 코드
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:lottie/lottie.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/model_quiz.dart';
// import 'screen_result.dart';
//
// class QuizScreen extends StatefulWidget {
//   final String category; // 카테고리 이름 전달
//
//   QuizScreen({required this.category, required List<Quiz> quizs});
//
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   List<Quiz> _quizs = [];
//   List<int> _answers = [];
//   List<Color> _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//   int _currentIndex = 0;
//   int _selectedIndex = -1;
//   SwiperController _controller = SwiperController();
//   int _remainingTime = 20;
//   late Timer _timer;
//   bool _isAnimating = false;
//   String? _currentAnimation;
//   bool _isHintVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizzes();
//   }
//
//   // Firestore에서 퀴즈 가져오기
//   Future<void> _fetchQuizzes() async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(widget.category)
//           .get();
//
//       List<dynamic> quizList = doc['quizList'];
//
//       // 사용되지 않은 문제 필터링
//       List<dynamic> availableQuizzes =
//       quizList.where((quiz) => quiz['used'] == false).toList();
//
//       if (availableQuizzes.isEmpty) {
//         // 모든 문제가 사용된 경우 초기화
//         for (var quiz in quizList) {
//           quiz['used'] = false;
//         }
//         await FirebaseFirestore.instance
//             .collection('quizzes')
//             .doc(widget.category)
//             .update({'quizList': quizList});
//
//         // 초기화된 문제 가져오기
//         availableQuizzes = quizList;
//       }
//
//       // 무작위로 10개의 문제를 가져옵니다
//       availableQuizzes.shuffle();
//       List<dynamic> selectedQuizzes = availableQuizzes.take(10).toList();
//
//       setState(() {
//         _quizs = selectedQuizzes.map((q) => Quiz.fromMap(q)).toList();
//         _answers = List.filled(_quizs.length, -1); // 정답 초기화
//       });
//
//       _startTimer();
//     } catch (e) {
//       print("Error fetching quizzes: $e");
//     }
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingTime > 0) {
//         setState(() {
//           _remainingTime--;
//         });
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   // 다음 문제로 이동
//   void _nextQuestion() {
//     if (_currentIndex < _quizs.length - 1) {
//       setState(() {
//         _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//         _selectedIndex = -1;
//         _currentIndex += 1;
//         _controller.next();
//         _remainingTime = 20;
//         _isHintVisible = false;
//       });
//     } else {
//       _timer.cancel();
//       _markQuizzesAsUsed();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             answers: _answers,
//             quizs: _quizs,
//           ),
//         ),
//       );
//     }
//   }
//
//   // 퀴즈 사용 상태 업데이트
//   Future<void> _markQuizzesAsUsed() async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(widget.category)
//           .get();
//
//       List<dynamic> quizList = doc['quizList'];
//
//       for (var quiz in _quizs) {
//         int index = quizList.indexWhere((q) => q['title'] == quiz.title);
//         if (index != -1) {
//           quizList[index]['used'] = true;
//         }
//       }
//
//       await FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(widget.category)
//           .update({'quizList': quizList});
//     } catch (e) {
//       print("Error marking quizzes as used: $e");
//     }
//   }
//
//   // 애니메이션을 표시
//   void _showAnimation(String fileName) {
//     setState(() {
//       _isAnimating = true;
//       _currentAnimation = fileName;
//     });
//
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isAnimating = false;
//         _currentAnimation = null;
//       });
//
//       if (_currentIndex == _quizs.length - 1) {
//         _markQuizzesAsUsed();
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultScreen(
//               answers: _answers,
//               quizs: _quizs,
//             ),
//           ),
//         );
//       } else {
//         _nextQuestion();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//
//     if (_quizs.isEmpty) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
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
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             // 남은 시간 상태바
//             Container(
//               width: width * 0.85,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: (width * 0.85) * (_remainingTime / 20),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       '남은 시간: $_remainingTime 초',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             // 문제 및 선택지
//             SizedBox(
//               height: screenSize.height * 0.6,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: width * 0.85,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.deepPurple),
//                       color: Colors.transparent,
//                     ),
//                     child: Swiper(
//                       controller: _controller,
//                       physics: NeverScrollableScrollPhysics(),
//                       loop: false,
//                       itemCount: _quizs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return _buildQuizCard(_quizs[index], width);
//                       },
//                     ),
//                   ),
//                   if (_isAnimating && _currentAnimation != null)
//                     Lottie.asset(
//                       'images/$_currentAnimation',
//                       width: 200,
//                       height: 200,
//                       fit: BoxFit.contain,
//                     ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             // 힌트 버튼
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.lightbulb_outline,
//                     color: Colors.deepPurple,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isHintVisible = !_isHintVisible;
//                     });
//                   },
//                 ),
//                 if (_isHintVisible)
//                   Container(
//                     margin: EdgeInsets.only(left: 8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.yellow[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.deepPurple),
//                     ),
//                     child: Text(
//                       _quizs[_currentIndex].hint ?? '힌트가 없습니다.',
//                       style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuizCard(Quiz quiz, double width) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           'Q${_currentIndex + 1}.',
//           style: TextStyle(
//             fontSize: width * 0.06,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           quiz.title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: width * 0.048,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 20),
//         ..._buildCandidates(width, quiz),
//         SizedBox(height: 40),
//         // NEXT 버튼
//         ElevatedButton(
//           child: Text(
//             _currentIndex == _quizs.length - 1 ? '결과보기' : 'NEXT',
//             style: TextStyle(
//               fontSize: width * 0.06,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.deepPurple,
//             minimumSize: Size(width * 0.7, 70),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           onPressed: _answers[_currentIndex] == -1
//               ? null
//               : () {
//             setState(() {
//               for (int i = 0; i < 4; i++) {
//                 if (i == quiz.answer) {
//                   _answerColors[i] = Colors.green;
//                 } else if (i == _selectedIndex) {
//                   _answerColors[i] = Colors.red;
//                 } else {
//                   _answerColors[i] = Colors.transparent;
//                 }
//               }
//             });
//
//             bool isCorrect = _answers[_currentIndex] == quiz.answer;
//             String fileName = isCorrect ? "correct.json" : "wrong.json";
//
//             _showAnimation(fileName);
//           },
//         ),
//       ],
//     );
//   }
//
//   List<Widget> _buildCandidates(double width, Quiz quiz) {
//     return List.generate(4, (i) {
//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             _selectedIndex = i;
//             _answers[_currentIndex] = i;
//
//             for (int j = 0; j < 4; j++) {
//               _answerColors[j] = j == i ? Colors.deepPurple : Colors.transparent;
//             }
//           });
//         },
//         child: Container(
//           width: width * 0.7,
//           margin: EdgeInsets.symmetric(vertical: 8),
//           padding: EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: _answerColors[i],
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.deepPurple, width: 2),
//           ),
//           child: Center(
//             child: Text(
//               quiz.candidates[i],
//               style: TextStyle(
//                 fontSize: width * 0.05,
//                 fontWeight: FontWeight.bold,
//                 color: _answerColors[i] == Colors.transparent ? Colors.black : Colors.white,
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
