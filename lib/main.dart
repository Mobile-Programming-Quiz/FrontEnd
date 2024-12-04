// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Firebase Core 추가
// import 'firebase_options.dart'; // Firebase 옵션 파일 추가
// import 'package:quiz_app/screen/screen_home.dart';
// import 'package:quiz_app/screen/screen_ranking_school.dart';
// import 'package:quiz_app/screen/screen_ranking_total.dart';
// import 'package:quiz_app/screen/splash.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Firebase 초기화 전 필수
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // Firebase 구성 파일 사용
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My Quiz App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(), // 초기 화면으로 SplashScreen 설정
//     );
//   }
// }
//
// class RankingPageView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         children: const [
//           SchoolRankingPage(), // 학교 랭킹 페이지
//           TotalRankingPage(),  // 전체 랭킹 페이지
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core 추가
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용
import 'firebase_options.dart'; // Firebase 옵션 파일 추가
import 'package:quiz_app/screen/screen_home.dart';
import 'package:quiz_app/screen/screen_ranking_school.dart';
import 'package:quiz_app/screen/screen_ranking_total.dart';
import 'package:quiz_app/screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase 초기화 전 필수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 구성 파일 사용
  );

  // Firestore 초기화 작업 호출
  await resetScoresIfNeeded();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // 초기 화면으로 SplashScreen 설정
    );
  }
}

class RankingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          SchoolRankingPage(), // 학교 랭킹 페이지
          TotalRankingPage(),  // 전체 랭킹 페이지
        ],
      ),
    );
  }
}

/// Firestore 유저 `score` 초기화 및 vote 처리 함수
Future<void> resetScoresIfNeeded() async {
  try {
    final today = DateTime.now().toString().split(' ')[0]; // 오늘 날짜 (yyyy-MM-dd)
    final metadataDocRef = FirebaseFirestore.instance.collection('metadata').doc('dailyReset');

    // metadata/dailyReset 문서 가져오기
    final metadataDoc = await metadataDocRef.get();

    // 초기화 필요 여부 확인
    if (metadataDoc.exists && metadataDoc.data() != null) {
      final lastResetDate = metadataDoc.data()!['lastResetDate'] ?? '';
      if (lastResetDate == today) {
        print("마지막 업데이트 : "+lastResetDate+"\n");
        print("오늘 날짜 : "+today+"\n");
        print('오늘은 이미 초기화되었습니다.');
        return; // 이미 초기화되었으므로 종료
      }
    }

    // 초기화 작업 실행
    print('모든 유저의 score를 초기화합니다.');
    final userCollection = FirebaseFirestore.instance.collection('user');
    final batch = FirebaseFirestore.instance.batch();

    // 모든 유저 문서 가져오기
    final querySnapshot = await userCollection.get();
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'score': 0}); // 각 유저의 score를 0으로 초기화
    }

    // vote 컬렉션에서 가장 높은 voteNumber 찾기
    final voteCollection = FirebaseFirestore.instance.collection('vote');
    final voteDocs = await voteCollection.get();
    String highestVoteDocument = '';
    int highestVoteNumber = -1;

    for (final doc in voteDocs.docs) {
      final voteNumber = (doc.data()['voteNumber'] ?? 0) as int;
      if (voteNumber > highestVoteNumber) {
        highestVoteNumber = voteNumber;
        highestVoteDocument = doc.id;
      }
    }

    // todaySubject 문서 업데이트
    final todaySubjectDoc = voteCollection.doc('todaySubject');
    await todaySubjectDoc.set({'todaySubject': highestVoteDocument});
    print('오늘의 주제는 "$highestVoteDocument"입니다.');

    // 모든 voteNumber 필드 초기화
    for (final doc in voteDocs.docs) {
      batch.update(doc.reference, {'voteNumber': 0});
    }

    // Firestore에 일괄 업데이트 적용
    await batch.commit();

    // metadata/dailyReset 문서 업데이트
    await metadataDocRef.set({'lastResetDate': today});
    print('초기화 완료!');
  } catch (e) {
    print('초기화 중 오류 발생: $e');
  }
}
