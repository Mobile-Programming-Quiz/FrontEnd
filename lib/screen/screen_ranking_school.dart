import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/screen/screen_ranking_page_view.dart';
import 'package:quiz_app/screen/screen_home.dart';

class SchoolRankingPage extends StatefulWidget {
  const SchoolRankingPage({super.key});

  @override
  _SchoolRankingPageState createState() => _SchoolRankingPageState();
}

class _SchoolRankingPageState extends State<SchoolRankingPage> {
  bool isLoading = true; // 로딩 상태를 나타내는 변수
  List<String> rankings = []; // 순위 데이터를 저장할 리스트
  int selectedIndex = 1; // 선택된 네비게이션 바 인덱스

  @override
  void initState() {
    super.initState();
    loadRankings(); // 비동기 데이터 로드 함수 호출
  }

  Future<void> loadRankings() async {
    // 데이터 로드 후 리스트 업데이트
    rankings = List.generate(20, (index) => ' ${index + 1}');
    setState(() {
      isLoading = false; // 로딩 완료 상태로 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학교랭킹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF7E3AB5),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때 인디케이터 표시
          : Column(
        children: [
          const Divider(color: Color(0xFF7E3AB5), thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Center( // 가운데 정렬을 위해 Center 위젯 추가
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8, // 가로 길이 줄이기
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7E3AB5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              rankings[index], // 불러온 순위 데이터 표시
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: index < 10 // 상위 10등까지만 왕관 표시
                                ? const Icon(FontAwesomeIcons.crown, color: Colors.yellow)
                                : const SizedBox.shrink(), // 10등 이후는 빈 공간
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: selectedIndex, // 선택된 아이템 설정
      //   onTap: (index) {
      //     setState(() {
      //       selectedIndex = index;
      //     });
      //     if (index == 0) {
      //       // 홈 아이템을 클릭하면 현재 페이지로 이동
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomeScreen()),
      //       );
      //     }
      //     else if (index == 1) {
      //       // 랭킹 아이템을 클릭하면 현재 페이지로 이동
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const RankingPageView()),
      //       );
      //     }
      //     else if (index == 2) {
      //       // 마이페이지 아이템을 클릭하면 현재 페이지로 이동
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const RankingPageView()),
      //       );
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: '홈',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bar_chart, color: Color(0xFF7E3AB5)), // 랭킹 선택 시 보라색
      //       label: '랭킹',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: '마이페이지',
      //     ),
      //   ],
      //   selectedItemColor: const Color(0xFF7E3AB5),
      //   unselectedItemColor: Colors.grey,
      // ),
    );
  }
}


