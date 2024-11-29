import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TotalRankingPage extends StatelessWidget {
  const TotalRankingPage({super.key});

  Future<List<Map<String, dynamic>>> fetchRankings() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .orderBy('score', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.white, thickness: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchRankings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('랭킹 데이터가 없습니다.'));
                }

                final rankings = snapshot.data!;
                return ListView.builder(
                  itemCount: rankings.length,
                  itemBuilder: (context, index) {
                    final user = rankings[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
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
                                  '${index + 1}', // 순위
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                              Text(
                                '${user['name']} - ${user['score']}점', // 유저 이름과 점수
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: index < 10
                                    ? const Icon(FontAwesomeIcons.crown, color: Colors.yellow)
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
