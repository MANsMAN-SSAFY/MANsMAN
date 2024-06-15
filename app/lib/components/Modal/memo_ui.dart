import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/component/app_normal_text_field.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/diary_store.dart';

class MemoUI extends StatefulWidget {
  final String reportId;
  final String memberId;

  const MemoUI({
    super.key,
    required this.reportId,
    required this.memberId,
  });

  @override
  State<MemoUI> createState() => _MemoUIState();
}

class _MemoUIState extends State<MemoUI> {
  final TextEditingController textEditingController = TextEditingController();
  bool _isInputValid = true; // 입력값 검증 상태 변수 추가

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 24, left: 24, right: 24, bottom: bottomPadding + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "오늘의 메모를 추가해주세요",
            style: AppTexts.body1,
          ),
          const SizedBox(height: 16),
          AppNormalTextField(
            controller: textEditingController,
            hint: "오늘의 메모",
            labelColor: AppColors.black,
            enabledBorderColor:
                _isInputValid ? AppColors.black : AppColors.red, // 조건부 테두리 색상
          ),
          const SizedBox(height: 16),
          AppElevatedButton(
            name: "확인",
            onPressed: () {
              String newMemo = textEditingController.text;
              if (newMemo.trim().isEmpty) {
                // 입력값이 비어있는지 확인
                setState(() {
                  _isInputValid = false; // 경고 테두리 활성화
                });
              } else {
                context.read<DiaryProvider>().updateMemo(newMemo);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
