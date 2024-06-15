import 'package:flutter/material.dart';
import 'package:app/components/Modal/dialog_ui.dart';
import 'package:app/common/style/app_colors.dart';

class DiaryTag extends StatefulWidget {
  final List<dynamic> hashTag;

  const DiaryTag({
    super.key,
    required this.hashTag,
  });

  @override
  State<DiaryTag> createState() => _DiaryTagState();
}

class _DiaryTagState extends State<DiaryTag> {
  late List<dynamic> hashTag;
  bool isEmpty = true; // 초기에 리스트가 비어있음을 나타내기 위해 true로 설정

  @override
  void initState() {
    hashTag = widget.hashTag;
    if (hashTag.isNotEmpty) {
      // 리스트에 아이템이 존재하는 경우 isEmpty를 false로 설정
      isEmpty = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('# 해시태그'),
          const SizedBox(
            height: 10,
          ),
          isEmpty
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const DialogUI();
                      },
                    ).then((value) {
                      // showDialog가 닫힌 후에 상태를 갱신함
                      setState(() {
                        isEmpty = false; // 리스트가 비어있지 않음을 나타냄
                      });
                    });
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(
                        color: AppColors.tag,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Text('상태를 추가하세요.'),
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20, // 각 해시태그 사이의 간격 설정
                  runSpacing: 10,
                  children: [
                    ...hashTag.map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        decoration: BoxDecoration(
                          color: e['color'],
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Text(
                            e["tag"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: const BoxDecoration(
                        color: AppColors.tag, // 원하는 색상 설정
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(50),
                          right: Radius.circular(50),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const DialogUI();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
