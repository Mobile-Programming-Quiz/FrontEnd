import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchoolRankingPage extends StatefulWidget {
  const SchoolRankingPage({super.key});

  @override
  _SchoolRankingPageState createState() => _SchoolRankingPageState();
}

class _SchoolRankingPageState extends State<SchoolRankingPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> rankings = [];
  String userSchool = '';

  @override
  void initState() {
    super.initState();
    loadRankings();
  }

  Future<void> loadRankings() async {
    try {
      // 현재 로그인한 유저의 학교 정보 가져오기
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("로그인된 사용자가 없습니다.");

      final userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception("사용자 데이터가 Firestore에 존재하지 않습니다.");
      }

      userSchool = userDoc.data()?['school'] ?? '';
      print('로그인된 사용자의 학교: $userSchool'); // 디버깅용 출력

      if (userSchool.isEmpty) throw Exception("학교 정보가 없습니다.");

      // 같은 학교 유저들 가져오기
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('school', isEqualTo: userSchool)
          .orderBy('score', descending: true)
          .limit(20)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("해당 학교의 랭킹 데이터가 없습니다."); // 디버깅용 출력
      }

      rankings = querySnapshot.docs.map((doc) => doc.data()).toList();
      print('가져온 랭킹 데이터: $rankings'); // 디버깅용 출력
    } catch (e) {
      print('데이터 로드 중 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          ? const Center(child: CircularProgressIndicator())
          : rankings.isEmpty
          ? const Center(child: Text('학교 랭킹 데이터가 없습니다.'))
          : Column(
        children: [
          const Divider(color: Color(0xFF7E3AB5), thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final user = rankings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
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
            ),
          ),
        ],
      ),
    );
  }
}
