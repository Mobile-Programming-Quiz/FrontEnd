// import 'dart:convert';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:quiz_app/screen/screen_result.dart';
// import 'package:lottie/lottie.dart'; // Lottie 패키지 추가
// import 'dart:async';
//
// import '../model/model_quiz.dart';
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
//   List<int> _answers = [-1, -1, -1];
//   List<Color> _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//   int _currentIndex = 0;
//   int _selectedIndex = -1;
//   SwiperController _controller = SwiperController();
//   int _remainingTime = 20;
//   late Timer _timer;
//   bool _isAnimating = false; // 애니메이션 표시 여부
//   String? _currentAnimation; // 표시할 Lottie 애니메이션 파일 이름
//   bool _isHintVisible = false; // 힌트 표시 여부
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 초기 레이아웃 계산 보장
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {}); // 강제로 초기 빌드 이후 다시 렌더링
//     });
//
//     _startTimer(); // 타이머 시작
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
//   void _nextQuestion() {
//     if (_currentIndex < widget.quizs.length - 1) {
//       setState(() {
//         _answerColors = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
//         _selectedIndex = -1;
//         _currentIndex += 1;
//         _controller.next();
//         _remainingTime = 20;
//         _isHintVisible = false; // 다음 문제로 이동 시 힌트 초기화
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
//   void _showAnimation(String fileName) {
//     setState(() {
//       _isAnimating = true;
//       _currentAnimation = fileName;
//     });
//
//     // 애니메이션 2초 후 종료
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
//     double height = screenSize.height;
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
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Center( // 중앙 정렬 보장
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // 남은 시간 상태바
//                   Container(
//                     width: width * 0.85,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: (width * 0.85) * (_remainingTime / 20),
//                           decoration: BoxDecoration(
//                             color: Colors.deepPurple,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             '남은 시간: $_remainingTime 초',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//
//                   // 문제 및 선택지 박스
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.deepPurple),
//                       color: Colors.transparent,
//                     ),
//                     width: width * 0.85,
//                     height: height * 0.5,
//                     child: Swiper(
//                       controller: _controller,
//                       physics: NeverScrollableScrollPhysics(),
//                       loop: false,
//                       itemCount: widget.quizs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return _buildQuizCard(widget.quizs[index], width, height);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Lottie 애니메이션
//             if (_isAnimating && _currentAnimation != null)
//               Center(
//                 child: Lottie.asset(
//                   'images/$_currentAnimation',
//                   width: 200,
//                   height: 200,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuizCard(Quiz quiz, double width, double height) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white),
//         color: Colors.white,
//       ),
//       child: Stack(
//         children: [
//           // 문제 및 정답 선택지
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
//                 child: Text(
//                   'Q' + (_currentIndex + 1).toString() + '.',
//                   style: TextStyle(
//                     fontSize: width * 0.06,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: width * 0.8,
//                 padding: EdgeInsets.only(top: width * 0.012),
//                 child: AutoSizeText(
//                   quiz.title,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   style: TextStyle(
//                     fontSize: width * 0.048,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(),
//               ),
//               Column(
//                 children: _buildCandidates(width, quiz),
//               ),
//               Container(
//                 padding: EdgeInsets.all(width * 0.024),
//                 child: Center(
//                   child: ElevatedButton(
//                     child: Text(
//                       _currentIndex == widget.quizs.length - 1 ? '결과보기' : 'NEXT',
//                       style: TextStyle(
//                         fontSize: width * 0.08,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.deepPurple,
//                       minimumSize: Size(width * 0.7, height * 0.08),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     onPressed: _answers[_currentIndex] == -1
//                         ? null
//                         : () {
//                       setState(() {
//                         for (int i = 0; i < 4; i++) {
//                           if (i == widget.quizs[_currentIndex].answer) {
//                             _answerColors[i] = Colors.green; // 정답 초록색
//                           } else if (i == _selectedIndex) {
//                             _answerColors[i] = Colors.red; // 선택된 오답 빨간색
//                           } else {
//                             _answerColors[i] = Colors.transparent; // 나머지는 초기화
//                           }
//                         }
//                       });
//
//                       bool isCorrect = _answers[_currentIndex] ==
//                           widget.quizs[_currentIndex].answer;
//                       String fileName =
//                       isCorrect ? "correct.json" : "wrong.json";
//
//                       _showAnimation(fileName);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // 힌트 버튼과 말풍선
//           Positioned(
//             bottom: 16, // 아래쪽 위치
//             left: 16, // 왼쪽 위치
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.lightbulb_outline,
//                     color: Colors.deepPurple,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isHintVisible = !_isHintVisible; // 힌트 토글
//                     });
//                   },
//                 ),
//                 if (_isHintVisible)
//                   Container(
//                     margin: EdgeInsets.only(left: 8), // 아이콘 오른쪽 간격
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.yellow[100],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.deepPurple),
//                     ),
//                     child: Text(
//                       quiz.hint?? '힌트가 없습니다.', // 힌트 텍스트
//                       style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildCandidates(double width, Quiz quiz) {
//     List<Widget> _children = [];
//     for (int i = 0; i < 4; i++) {
//       _children.add(
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _selectedIndex = i;
//               _answers[_currentIndex] = i;
//
//               for (int j = 0; j < 4; j++) {
//                 _answerColors[j] = j == i ? Colors.deepPurple : Colors.transparent;
//               }
//             });
//           },
//           child: Container(
//             width: width * 0.7,
//             padding: EdgeInsets.symmetric(vertical: width * 0.02),
//             margin: EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: _answerColors[i],
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.deepPurple, width: 2),
//             ),
//             child: Center(
//               child: Text(
//                 quiz.candidates[i],
//                 style: TextStyle(
//                   fontSize: width * 0.05,
//                   fontWeight: FontWeight.bold,
//                   color: _answerColors[i] == Colors.transparent ? Colors.black : Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return _children;
//   }
// }
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:lottie/lottie.dart';
import '../model/model_quiz.dart';
import 'screen_result.dart';

class QuizScreen extends StatefulWidget {
  final List<Quiz> quizs;

  QuizScreen({required this.quizs});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> _answers = [-1, -1, -1];
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

  void _nextQuestion() {
    if (_currentIndex < widget.quizs.length - 1) {
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
            quizs: widget.quizs,
          ),
        ),
      );
    }
  }

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

      if (_currentIndex == widget.quizs.length - 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              answers: _answers,
              quizs: widget.quizs,
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
                      itemCount: widget.quizs.length,
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
        AutoSizeText(
          quiz.title,
          textAlign: TextAlign.center,
          maxLines: 2,
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
            _currentIndex == widget.quizs.length - 1 ? '결과보기' : 'NEXT',
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
                if (i == widget.quizs[_currentIndex].answer) {
                  _answerColors[i] = Colors.green;
                } else if (i == _selectedIndex) {
                  _answerColors[i] = Colors.red;
                } else {
                  _answerColors[i] = Colors.transparent;
                }
              }
            });

            bool isCorrect = _answers[_currentIndex] ==
                widget.quizs[_currentIndex].answer;
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

