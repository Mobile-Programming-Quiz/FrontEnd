import 'dart:async';
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
  int _hintCount = 3; // 힌트 제한 횟수

  @override
  void initState() {
    super.initState();
    _answers = List.filled(widget.quizs.length, -1); // 정답 초기화
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
                    color: _hintCount > 0 ? Colors.deepPurple : Colors.grey,
                    size: 32,
                  ),
                  onPressed: _hintCount > 0
                      ? () {
                    setState(() {
                      _isHintVisible = !_isHintVisible;
                      if (_isHintVisible) {
                        _hintCount--; // 힌트를 볼 때마다 카운트 감소
                      }
                    });
                  }
                      : null, // 힌트를 다 쓰면 버튼 비활성화
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
            if (_hintCount <= 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '힌트를 모두 사용했습니다!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
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


