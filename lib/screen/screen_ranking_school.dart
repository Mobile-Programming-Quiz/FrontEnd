import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    rankings = List.generate(15, (index) => '${index + 1}등학생이름');
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
                  child: Container(
                    height: 50,
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, // 선택된 아이템 설정
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          if (index == 1) {
            // 랭킹 아이템을 클릭하면 현재 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SchoolRankingPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Color(0xFF7E3AB5)), // 랭킹 선택 시 보라색
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        selectedItemColor: const Color(0xFF7E3AB5),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class SchoolRankingPage extends StatefulWidget {
//   const SchoolRankingPage({super.key});
//
//   @override
//   _SchoolRankingPageState createState() => _SchoolRankingPageState();
// }
//
// class _SchoolRankingPageState extends State<SchoolRankingPage> {
//   List<String> rankings = List.generate(15, (index) => '${index + 1}등학생이름'); // 순위 데이터를 저장할 리스트
//   int selectedIndex = 1; // 선택된 네비게이션 바 인덱스
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('학교랭킹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF7E3AB5),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: rankings.length + 1,
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             // Divider 위젯을 첫 번째 아이템으로 추가
//             return const Divider(color: Color(0xFF7E3AB5), thickness: 2);
//           } else {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF7E3AB5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0),
//                       child: Text(
//                         rankings[index - 1], // 불러온 순위 데이터 표시
//                         style: const TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: index <= 10 // 상위 10등까지만 왕관 표시
//                           ? const Icon(FontAwesomeIcons.crown, color: Colors.yellow)
//                           : const SizedBox.shrink(), // 10등 이후는 빈 공간
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex, // 선택된 아이템 설정
//         onTap: (index) {
//           setState(() {
//             selectedIndex = index;
//           });
//           if (index == 1) {
//             // 랭킹 아이템을 클릭하면 현재 페이지로 이동
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SchoolRankingPage()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '홈',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart, color: Color(0xFF7E3AB5)), // 랭킹 선택 시 보라색
//             label: '랭킹',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '마이페이지',
//           ),
//         ],
//         selectedItemColor: const Color(0xFF7E3AB5),
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }
// }
