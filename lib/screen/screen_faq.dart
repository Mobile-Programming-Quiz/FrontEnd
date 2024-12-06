import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildFaqItem('📌  똑똑은 어떤 어플인가요?',
              '"똑똑" 앱은 사용자들에게 일일 상식 퀴즈를 제공하여 지식 습득을 돕고, 랭킹 시스템을 통해 경쟁과 성취감을 느낄 수 있도록 하는 어플리케이션입니다. 사용자는 매일 새로운 퀴즈를 풀고 점수에 따라 실시간으로 갱신되는 랭킹을 확인할 수 있으며, 자신의 퀴즈 결과를 SNS로 공유할 수 있는 기능을 통해 친구들과 경쟁할 수 있습니다. 또한, 다음날의 퀴즈 주제를 투표할 수 있는 기능을 제공하여 사용자 참여를 높이고, 매일 새로운 퀴즈를 통해 꾸준히 지식을 확장할 수 있도록 설계된 앱입니다.'),
          _buildFaqItem('📌  랭킹 시스템은 어떻게 작동하나요?',
              '사용자의 일일 퀴즈 점수에 따라 실시간으로 랭킹이 갱신됩니다. 랭킹은 당일 퀴즈 결과를 기준으로 매일 자정에 초기화됩니다.'),
          _buildFaqItem('📌  퀴즈 문제는 어떻게 선정되나요?',
              '퀴즈 문제는 다양한 상식 분야와 난이도를 고려하여 개발자가 추가하며, 4인의 검수를 거쳐 문제의 품질을 관리합니다. 또한, 사용자 투표 결과에 따라 다음 날의 퀴즈 주제가 결정됩니다.'),
          _buildFaqItem('📌  내일의 퀴즈 주제를 투표하는 방법은 무엇인가요?',
              '사용자는 매일 문제를 풀고 나면 나오는 결과화면에서 "내일의 퀴즈 테마는 무엇으로 할까요?"라는 질문에 대해 주어진 주제 중 하나를 선택해 투표할 수 있습니다. 투표 결과는 과반수에 따라 결정되며, 다음날의 퀴즈 카테고리가 됩니다.'),
          _buildFaqItem('📌  힌트의 개수는 정해져있나요?',
              '힌트는 하루에 3개씩 제한되어 있습니다! '),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
