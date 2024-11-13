import 'package:flutter/material.dart';
import 'dart:math';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final List<String> _botResponses = [
    "안녕하세요! 무엇을 도와드릴까요?",
    "오늘도 좋은 하루 되세요!",
    "챗봇의 응답 메시지입니다.",
    "문의 사항이 있으면 언제든지 물어보세요."
  ];

  int _selectedIndex = 1;
  bool _isExpanded = false; // 채팅창 확장 여부 상태

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MissionPage()),
      );
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"message": _controller.text, "sender": "user"});
        _controller.clear();
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
        _scrollToBottom();
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          final randomResponse = _botResponses[Random().nextInt(_botResponses.length)];
          _messages.add({"message": randomResponse, "sender": "bot"});
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 파란색 바
          Container(
            color: const Color(0xFF1C4A90),
            height: 50,
          ),
          // 조건에 따른 캐릭터 이미지 및 채팅창 표시 여부
          if (isKeyboardVisible && !_isExpanded) // 키보드가 올라와 있고 채팅창이 축소된 상태일 때는 캐릭터만 표시
            Expanded(
              flex: 7,
              child: Center(
                child: Image.asset(
                  'assets/character.png', // 캐릭터 이미지 경로 확인
                  height: 150,
                ),
              ),
            )
          else if (!isKeyboardVisible && !_isExpanded) // 키보드가 내려가 있고 채팅창이 축소된 상태일 때 일부 채팅과 캐릭터 모두 표시
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Image.asset(
                        'assets/character.png',
                        height: 150,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final messageData = _messages[index];
                          final isUserMessage = messageData["sender"] == "user";

                          return Align(
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUserMessage ? const Color(0xFF1C4A90) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                messageData["message"] ?? "",
                                style: TextStyle(
                                  color: isUserMessage ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (!isKeyboardVisible && _isExpanded) // 키보드가 내려가 있고 채팅창이 확장된 상태일 때 캐릭터 숨기기
              Expanded(
                flex: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final messageData = _messages[index];
                      final isUserMessage = messageData["sender"] == "user";

                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUserMessage ? const Color(0xFF1C4A90) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            messageData["message"] ?? "",
                            style: TextStyle(
                              color: isUserMessage ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else if (isKeyboardVisible && _isExpanded) // 키보드가 올라오고 채팅창이 확장된 상태일 때 확장된 채팅창만 표시
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final messageData = _messages[index];
                        final isUserMessage = messageData["sender"] == "user";

                        return Align(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUserMessage ? const Color(0xFF1C4A90) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              messageData["message"] ?? "",
                              style: TextStyle(
                                color: isUserMessage ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Icon(
                  _isExpanded ? Icons.expand_more : Icons.expand_less,
                  color: const Color(0xFF1C4A90),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF1C4A90)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1C4A90),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: '마이페이지',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('android/app/src/main/res/drawable-hdpi/splash.png'), // 이미지 경로 확인
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: '일일미션',
          ),
        ],
      ),
    );
  }
}

// 예시 페이지들
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("마이페이지")),
      body: const Center(child: Text("여기는 마이페이지입니다.")),
    );
  }
}
class MissionPage extends StatelessWidget {
  const MissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일일미션")),
      body: const Center(child: Text("여기는 일일미션 페이지입니다.")),
    );
  }
}
