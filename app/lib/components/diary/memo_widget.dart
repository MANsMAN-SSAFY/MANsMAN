import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/memo.dart'; // 메모 상태를 관리하는 클래스를 가져옵니다.
import 'package:app/components/Modal/memo_ui.dart'; // 메모 편집 UI를 가져옵니다.

class MemoWidget extends StatelessWidget {
  final String memo;
  final String reportId; // reportId를 추가합니다.
  final String memberId; // memberId를 추가합니다.

  const MemoWidget({
    super.key,
    required this.memo,
    required this.reportId, // reportId를 필수 인자로 추가합니다.
    required this.memberId, // memberId를 필수 인자로 추가합니다.
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      color: const Color.fromARGB(255, 241, 241, 241),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '한줄메모',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              IconButton(
                onPressed: () {
                  // MemoUI 대화상자를 호출하여 메모를 편집할 수 있게 합니다.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MemoUI(
                        reportId: reportId,
                        memberId: memberId,
                      );
                    },
                  ).then((_) {
                    // 대화상자가 닫힐 때 실행할 작업 (예: 상태 업데이트)
                  });
                },
                icon: const Icon(Icons.edit_document),
              ),
            ],
          ),
          Text(memo),
        ],
      ),
    );
  }
}
