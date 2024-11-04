import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:quiz_app/model/model_quiz.dart';
import 'package:quiz_app/screen/screen_result.dart';
import 'package:quiz_app/widget/widget_candidate.dart';
import 'dart:async'; // 타이머를 위해 추가

class QuizScreen extends StatefulWidget {
  final List<Quiz> quizs;

  QuizScreen({required this.quizs});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> _answers = [-1, -1, -1]; // 현재 답변 저장
  List<bool> _answerState = [false, false, false, false]; // 각 선택지의 선택 상태
  int _currentIndex = 0; // 현재 문제 인덱스
  SwiperController _controller = SwiperController(); // Swiper 컨트롤러
  int _remainingTime = 20; // 남은 시간
  late Timer _timer; // 타이머

  @override
  void initState() {
    super.initState();
    // 상태 표시줄 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _startTimer(); // 타이머 시작
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _nextQuestion(); // 시간이 다 되면 다음 문제로 넘어감
      }
    });
  }

  void _nextQuestion() {
    // 현재 문제의 정답을 확인하여 다음 문제로 이동
    if (_currentIndex < widget.quizs.length - 1) {
      setState(() {
        _answerState = [false, false, false, false]; // 선택 상태 초기화
        _currentIndex += 1; // 다음 문제로 이동
        _controller.next(); // Swiper의 다음 페이지로 이동
        _remainingTime = 20; // 남은 시간 초기화
      });
    } else {
      // 결과 화면으로 이동
      _timer.cancel(); // 타이머 취소
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

  @override
  void dispose() {
    _timer.cancel(); // 타이머 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png', // Path to 'logo.png' in assets
          width: 150,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // 타이머 바 표시
              Container(
                width: width * 0.85,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: (width * 0.85) * (_remainingTime / 20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurple),
                  color: Colors.transparent,
                ),
                width: width * 0.85,
                height: height * 0.5,
                child: Swiper(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  loop: false,
                  itemCount: widget.quizs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildQuizCard(widget.quizs[index], width, height);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: Text(
              'Q' + (_currentIndex + 1).toString() + '.',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: AutoSizeText(
              quiz.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: _buildCandidates(width, quiz),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.024),
            child: Center(
              child: ButtonTheme(
                minWidth: width * 0.5,
                height: height * 0.05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  child: Text(
                    _currentIndex == widget.quizs.length - 1 ? '결과보기' : 'NEXT',
                    style: TextStyle(
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    minimumSize: Size(width * 0.7, height * 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _answers[_currentIndex] == -1 ? null : () {
                    if (_currentIndex == widget.quizs.length - 1) {
                      _timer.cancel(); // 결과 화면으로 넘어가기 전에 타이머 취소
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
                      _nextQuestion(); // 다음 문제로 이동
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCandidates(double width, Quiz quiz) {
    List<Widget> _children = [];
    for (int i = 0; i < 4; i++) {
      _children.add(
        CandWidget(
          index: i,
          text: quiz.candidates[i],
          width: width,
          answerState: _answerState[i],
          tap: () {
            setState(() {
              for (int j = 0; j < 4; j++) {
                if (j == i) {
                  _answerState[j] = true;
                  _answers[_currentIndex] = j;
                } else {
                  _answerState[j] = false;
                }
              }
            });
          },
        ),
      );
      _children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return _children;
  }
}
