import 'package:app/common/style/app_colors.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/utils/time_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentItem extends StatefulWidget {
  final Map<String, dynamic> comment; // 수정: 'final' 키워드 추가
  final String postId;

  const CommentItem({super.key, required this.comment, required this.postId});
  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool? isLiked; // 서버에서 받아온 초기 상태로 설정할 수 있습니다.
  late int likeCnt;

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정. 예를 들어, widget.comment['isLiked']로 서버로부터 받은 상태를 할당할 수 있습니다.
    isLiked = widget.comment['like'];
    likeCnt = widget.comment['likeCnt'];
  }

  void toggleLikeComment() async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      Response response;
      if (isLiked == true) {
        // 좋아요 취소 요청
        response = await dio.delete(
          '${dotenv.env['baseUrl']}comments/${widget.comment['id']}/likes',
          options: Options(
            headers: {'authorization': 'Bearer $accessToken'},
          ),
        );
      } else {
        // 좋아요 요청
        response = await dio.post(
          '${dotenv.env['baseUrl']}comments/${widget.comment['id']}/likes',
          options: Options(
            headers: {'authorization': 'Bearer $accessToken'},
          ),
        );
      }

      // 요청 성공 시 상태 업데이트
      if (response.statusCode == 200) {
        setState(() {
          // 서버의 응답에 따라 상태 변경
          isLiked = !isLiked!;
          likeCnt += isLiked! ? 1 : -1;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String _buildSkinTypeTag(String? skinType) {
    String tagText;
    Color backgroundColor;

    switch (skinType?.toUpperCase()) {
      case 'OILY':
        tagText = "지성";
        backgroundColor = Colors.green;
        break;
      case 'DRY':
        tagText = "건성";
        backgroundColor = Colors.blue;
        break;
      case 'NORMAL':
        tagText = "복합성";
        backgroundColor = Colors.purple;
        break;
      default:
        tagText = "피부 탐험 중";
        backgroundColor = Colors.grey;
    }

    return tagText;
  }

  // skinType에 따른 색상을 반환하는 함수
  Color _getSkinTypeColor(String skinType) {
    switch (skinType.toUpperCase()) {
      case 'OILY':
        return Colors.green; // 지성 피부에 해당하는 색상
      case 'DRY':
        return Colors.blue; // 건성 피부에 해당하는 색상
      case 'NORMAL':
        return Colors.purple; // 중성 피부에 해당하는 색상
      default:
        return Colors.grey; // 기본 색상
    }
  }

  @override
  Widget build(BuildContext context) {
    // 스킨 타입에 따른 태그 색상을 결정
    Color tagColor = widget.comment['writer']?['report'] != null
        ? _getSkinTypeColor(widget.comment['writer']['report']?['skinType'])
        : Colors.grey; // "검사 전"에 대한 색상으로 오렌지 색상 사용

    String tagText = _buildSkinTypeTag(
        widget.comment['writer']['report']?['skinType'] ?? "");

    print(widget.comment);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.comment['writer']['imgUrl'] != null
                      ? TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.otherprofile,
                                arguments: widget.comment['writer']['id']);
                          },
                          child: SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                widget.comment['writer']['imgUrl'],
                                // 'assets/images/wony.jpg',
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.myprofile);
                          },
                          child: SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.asset(
                                'assets/images/profile.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.otherprofile,
                                  arguments: widget.comment['writer']['id']);
                            },
                            child: Text(
                              widget.comment['writer']['nickname'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8), // 닉네임과 스킨 타입 태그 사이의 간격
                          // 스킨 타입 태그
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              tagText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // if comment[isLike] ?
              Row(
                children: [
                  // 수정 버튼
                  // if (widget.comment['writer']['id'] == null)
                  GestureDetector(
                    onTap: () {
                      // 수정 로직을 여기에 추가하세요
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8), // 수정, 삭제 버튼과 좋아요 버튼 사이의 간격 조정
                  // 삭제 버튼
                  // if (widget.comment['writer']['id'] == null)
                  GestureDetector(
                    onTap: () {
                      // 삭제 로직을 여기에 추가하세요
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8), // 수정, 삭제 버튼과 좋아요 버튼 사이의 간격 조정
                  Column(
                    children: [
                      // 좋아요 버튼
                      GestureDetector(
                        onTap: toggleLikeComment,
                        child: Icon(
                          isLiked == true
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: isLiked == true ? Colors.red : Colors.grey,
                          size: 24, // 아이콘 크기 설정
                        ),
                      ),
                      const SizedBox(width: 4), // 아이콘 사이 간격 조정
                      Text(
                        '$likeCnt',
                        style: const TextStyle(
                          fontSize: 16, // 텍스트 크기 설정
                          color: Colors.black, // 텍스트 색상 설정
                          fontWeight: FontWeight.bold, // 글꼴 무게 설정
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              widget.comment['content'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(TimeUtil.timeAgo(
                        milliseconds:
                            DateTime.parse(widget.comment['createdAt'])
                                .millisecondsSinceEpoch)),
                    const SizedBox(width: 8), // 날짜와 좋아요 사이의 간격
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }
}
