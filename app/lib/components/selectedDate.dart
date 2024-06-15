import 'package:app/common/style/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/common/style/app_colors.dart';

Future<void> selectDateCupertino(BuildContext context, DateTime initialDate,
    Function(DateTime) onDateChanged) async {
  // 사용자가 선택한 날짜를 저장한 임시 변수
  DateTime selectedDate = initialDate;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        color: AppColors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '취소',
                    style: AppTexts.body3.copyWith(color: AppColors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onDateChanged(selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: AppTexts.body3.copyWith(color: AppColors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              '생년월일을 입력해주세요',
              style:
              AppTexts.header1.copyWith(color: AppColors.iconBlack),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: CupertinoDatePicker(
                dateOrder: DatePickerDateOrder.ymd,
                backgroundColor: AppColors.white,
                initialDateTime: initialDate,
                onDateTimeChanged: (newDate) {
                 selectedDate = newDate; // 선택한 날짜를 입력받음
                },
                maximumDate: DateTime.now(),
                minimumYear: 1960,
                maximumYear: DateTime.now().year,
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          ],
        ),
      );
    },
  );
}
