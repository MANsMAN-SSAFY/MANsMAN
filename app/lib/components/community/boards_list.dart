import 'package:app/common/style/app_colors.dart';
import 'package:app/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/model/articles/articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArticleItem extends StatelessWidget {
  final String title;
  final String content;
  final String nickname;
  final DateTime createdAt;
  final int viewCnt;
  final int likeCnt;
  final int commentCnt;
  final Widget? image;
  const ArticleItem({
    super.key,
    required this.commentCnt,
    required this.likeCnt,
    required this.viewCnt,
    required this.createdAt,
    required this.nickname,
    required this.content,
    this.image,
    required this.title,
  });

  factory ArticleItem.fromModel({
    required Articles models,
  }) {
    // print(models.boaredImageList);
    return ArticleItem(
      title: models.title,
      content: models.content,
      nickname: models.writer.nickname,
      createdAt: models.createdAt,
      viewCnt: models.viewCnt,
      likeCnt: models.likeCnt,
      commentCnt: models.commentCnt,
      image: models.boaredImageList.isNotEmpty
      ? Image.network(
        models.boaredImageList[0].boardImgUrl,
        height: 120,
        width: 120,
      )
      : Image.asset(
        'assets/images/msmLogo.png',
        height: 100,
        width: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Text(
                      "작성자 : $nickname",
                      style: const TextStyle(
                        fontSize: 12,
                        color: (Colors.black54),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      // 너비를 제한하는 컨테이너 추가
                      width: MediaQuery.of(context).size.width *
                          0.5, // 화면 너비의 80%로 제한
                      child: Text(
                        content,
                        maxLines: 3, // 최대 3줄까지 표시
                        overflow: TextOverflow.ellipsis, // 3줄 초과시 생략
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: image, //썸네일
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: AppColors.blue,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            viewCnt.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thumb_up_alt_outlined,
                            color: AppColors.blue,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            likeCnt.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.mode_comment_outlined,
                            color: AppColors.blue,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            commentCnt.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  TimeUtil.timeAgo(
                    milliseconds: DateTime.parse(
                      createdAt.toString()
                    )
                    .millisecondsSinceEpoch
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
