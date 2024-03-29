import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment; // 수정: 'final' 키워드 추가

  const CommentItem({super.key, required this.comment}); // 수정: 생성자 파라미터 수정

  @override
  Widget build(BuildContext context) {
    print(comment);
    return SizedBox(
      height: 100,
      child: Column(
        children: [Text(comment['content'])],
      ),
    );
  }
}
