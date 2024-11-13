import 'package:flutter/material.dart';

// ChangeNotifier를 사용하여 상태 관리를 위한 RankingProvider 클래스 정의
class RankingProvider with ChangeNotifier {
  // 학교 랭킹과 전체 랭킹을 저장할 리스트
  List<String> schoolRankings = [];
  List<String> totalRankings = [];

  // 데이터 로딩 상태를 나타내는 불리언 변수
  bool isLoading = true;

  // 생성자에서 랭킹 데이터를 로드하는 함수 호출
  RankingProvider() {
    loadRankings();
  }

  // 비동기로 랭킹 데이터를 로드하는 함수
  Future<void> loadRankings() async {
    // 데이터 로딩을 시뮬레이션하기 위해 2초 지연
    // await Future.delayed(const Duration(seconds: 2));

    // 15개의 예제 학교 랭킹 데이터를 생성하여 schoolRankings 리스트에 저장
    schoolRankings = List.generate(15, (index) => 'School ${index + 1}');

    // 15개의 예제 전체 랭킹 데이터를 생성하여 totalRankings 리스트에 저장
    totalRankings = List.generate(15, (index) => 'User ${index + 1}');

    // 로딩이 완료되었음을 나타내기 위해 isLoading을 false로 설정
    isLoading = false;

    // 상태가 변경되었음을 알리기 위해 notifyListeners() 호출
    notifyListeners();
  }

}
