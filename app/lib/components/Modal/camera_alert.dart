import 'package:app/common/style/app_texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:app/common/style/app_colors.dart';

class CameraAlert extends StatefulWidget {
  final Function(ImageSource) getImage;
  const CameraAlert({
    super.key,
    required this.getImage,
  });

  @override
  State<CameraAlert> createState() => _CameraAlertState();
}

class _CameraAlertState extends State<CameraAlert> {
  bool isButtonEnabled = true;
  int remainingTime = 0; // 초기 대기 시간

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.1,
      ),
      child: Dialog(
        backgroundColor: AppColors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width *
                0.8, // 최소 너비를 기기 너비의 절반으로 지정
            maxWidth: MediaQuery.of(context).size.width *
                0.9, // 최대 너비를 기기 너비의 90%로 지정
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.red,
                  size: 60,
                ),
                RichText(
                  text: const TextSpan(
                    text: "시작 전 ",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w600 // 시작 전 텍스트의 색상
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "체크",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.red, // '체크' 단어의 색상을 빨간색으로 지정
                        ),
                      ),
                      TextSpan(
                        text: " 해주세요",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black, // 해주세요 텍스트의 색상
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Text(
                    "조명이 어둡지 않은지 확인하세요",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text(
                    "앞머리는 넘기고 \n안경, 마스크, 모자는 벗어주세요",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Text(
                    "화장을 안 한 상태에서 \n진단해야 정확해요",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                          // 버튼이 활성화되면 작동할 기능을 여기에 작성합니다.
                          widget.getImage(ImageSource.camera);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Text(
                    isButtonEnabled ? '사진 찍기' : '대기 시간: $remainingTime초',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
