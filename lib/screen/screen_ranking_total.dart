import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TotalRankingPage extends StatelessWidget {
  const TotalRankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E3AB5),
      appBar: AppBar(
        title: const Text('전체랭킹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E3AB5),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.white, thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // 순위를 20등까지 확장
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Center( // 가운데 정렬
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85, // 가로 길이 줄이기
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9E5FC2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              '${index + 1} ', // 순위 표시
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
    );
  }
}
