import 'dart:convert';
import 'package:app/components/community/comment_item.dart';
import 'package:app/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/community/boards_list.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/model/articles/articles.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:app/store/router.dart';
// style
import 'package:app/common/style/app_colors.dart';

class BoardDetailPage extends StatefulWidget {
  const BoardDetailPage({super.key});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  final ScrollController _scrollController = ScrollController();

  Future<Map<String, dynamic>> articleDetail(String postId) async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        '${dotenv.env['baseUrl']}boards/$postId',
        options: Options(
          headers: {'authorization': 'Bearer $accessToken'},
        ),
      );

      final article = response.data;
      print(article);
      return article;
    } catch (e) {
      print('Error occurred: $e');
      rethrow; // 에러 발생 시 다시 throw하여 상위 FutureBuilder에서 에러 처리 가능하도록 함
    }
  }

  Future<List<dynamic>> commentList(String postId) async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        '${dotenv.env['baseUrl']}boards/$postId/comments',
        options: Options(
          headers: {'authorization': 'Bearer $accessToken'},
        ),
      );

      final comments = response.data;
      // print('댓글');
      // print(comments);

      return comments;
    } catch (e) {
      print('Error occurred: $e');
      rethrow; // 에러 발생 시 다시 throw하여 상위 FutureBuilder에서 에러 처리 가능하도록 함
    }
  }

  Widget _buildSkinTypeTag(String? skinType) {
    // 스킨 타입에 따른 태그 텍스트와 색상 결정
    String tagText;
    Color backgroundColor;

    switch (skinType?.toUpperCase()) {
      case 'OILY':
        tagText = "지성";
        backgroundColor = Colors.green; // 지성 피부에 해당하는 색상
        break;
      case 'DRY':
        tagText = "건성";
        backgroundColor = Colors.blue; // 건성 피부에 해당하는 색상
        break;
      case 'NORMAL':
        tagText = "복합성";
        backgroundColor = Colors.purple; // 복합성 피부에 해당하는 색상
        break;
      default:
        tagText = "피부 탐험 중";
        backgroundColor = Colors.grey; // 기본 색상
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tagText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
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
    final postId = ModalRoute.of(context)!.settings.arguments.toString();

    final TextEditingController commentController = TextEditingController();
    final userProvider = Provider.of<User>(context, listen: false);
    var providerId = userProvider.profile?['id'];

    @override
    void dispose() {
      commentController.dispose();
      super.dispose();
    }

    // 댓글 입력 함수
    void submitComment() async {
      final String comment = commentController.text;
      final dio = Dio();
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var data = json.encode({"content": comment});
      var response = await dio.request(
        '${dotenv.env['baseUrl']}boards/$postId/comments',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 201) {
        print(json.encode(response.data));
        setState(() => {});
      } else {
        print(response.statusMessage);
      }
    }

    void articleScrap() async {
      final dio = Dio();
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

      try {
        final response = await dio.post(
          '${dotenv.env['baseUrl']}boards/$postId/scraps',
          options: Options(
            headers: {'authorization': 'Bearer $accessToken'},
          ),
        );

        print("스크랩");
      } catch (e) {}
    }

    void articleDelete() async {
      final dio = Dio();
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

      try {
        final response = await dio.delete(
          '${dotenv.env['baseUrl']}boards/$postId',
          options: Options(
            headers: {'authorization': 'Bearer $accessToken'},
          ),
        );

        print("$postId번 게시글 삭제 완료");
        final router = Provider.of<MainRouter>(context, listen: false);
        // 타겟 탭의 인덱스를 설정합니다.
        router.setIndex(3); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
        // MainPage로 이동합니다.
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.main,
          ModalRoute.withName('/'),
        ); // 성공적으로 게시글을 생성하거나 삭제했을 때 true 반환
      } catch (e) {
        print('Error occurred: $e');
        rethrow; // 에러 발생 시 다시 throw하여 상위 FutureBuilder에서 에러 처리 가능하도록 함
      }
    }

    return DefaultLayout(
      title: '게시판',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: const MyProfileImage(),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: articleDetail(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('데이터를 불러오는 중 오류가 발생했습니다: ${snapshot.error}');
            } else {
              final article = snapshot.data!;
              final isAuthor = article['writer']['id'] == providerId;
              bool isLiked = article['like'] ?? true; // 예시 데이터
              bool isBookmarked = article['scrap'] ?? true; // 예시 데이터
              return SingleChildScrollView(
                controller: _scrollController,
                physics:
                    const AlwaysScrollableScrollPhysics(), // 전체 스크롤 영역을 위해 추가
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이미지 캐러셀 추가
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        article['writer']['imgUrl'] != null
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.otherprofile,
                                      arguments: article['writer']['id']);
                                },
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      article['writer']['imgUrl'],
                                      // 'assets/images/wony.jpg',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              )
                            : TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.otherprofile,
                                      arguments: article['writer']['id']);
                                },
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                      child: TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          AppRoutes.otherprofile,
                                          arguments: article['writer']['id']);
                                    },
                                    child: Text(
                                      article['writer']['nickname'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                                  const SizedBox(width: 8),
                                  _buildSkinTypeTag(
                                      article['writer']['report']?['skinType']),
                                ],
                              ),
                              Text(TimeUtil.timeAgo(
                                  milliseconds:
                                      DateTime.parse(article['createdAt'])
                                          .millisecondsSinceEpoch)),
                            ],
                          ),
                        ),
                        if (isAuthor) ...{
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              articleDelete();
                            },
                          ),
                        }
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      // decoration: const BoxDecoration(
                      //   border: Border(
                      //     bottom: BorderSide(color: Colors.grey),
                      //   ),
                      // ),
                      child: Text(
                        article['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      width: MediaQuery.of(context).size.width,
                      // decoration: const BoxDecoration(
                      //   border: Border(
                      //     bottom: BorderSide(color: Colors.grey),
                      //   ),
                      // ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['content'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            // 이하 이미지
                            article['boardImageList'].length != 0
                                ? SizedBox(
                                    height: 150,
                                    child: InfiniteCarousel.builder(
                                      itemCount:
                                          article['boardImageList'].length ?? 0,
                                      itemExtent:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      scrollBehavior: kIsWeb
                                          ? ScrollConfiguration.of(context)
                                              .copyWith(
                                              dragDevices: {
                                                // Allows to swipe in web browsers
                                                PointerDeviceKind.touch,
                                                PointerDeviceKind.mouse
                                              },
                                            )
                                          : null,
                                      loop: false,
                                      center: false,
                                      itemBuilder:
                                          (context, itemIndex, realIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: kElevationToShadow[2],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    article['boardImageList']
                                                                [itemIndex]
                                                            ["boardImgUrl"]
                                                        .toString()),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                          ]),
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
                                    article['viewCnt'].toString(),
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
                                    article['likeCnt'].toString(),
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
                                    article['commentCnt'].toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: AppColors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BookmarkButtonWidget(
                                postId: postId, isBookmarked: isBookmarked),
                            LikeButtonWidget(
                              postId: postId,
                              isLiked: isLiked,
                              onLikeToggle: (bool newLikeStatus) {
                                // setState(() {
                                //   isLiked = newLikeStatus;
                                //   if (isLiked) {
                                //     // 좋아요를 눌렀으면 likeCnt 증가
                                //     article['likeCnt'] += 1;
                                //   } else {
                                //     // 좋아요를 취소했으면 likeCnt 감소
                                //     article['likeCnt'] -= 1;
                                //   }
                                // });
                                setState(
                                  () {},
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "댓글",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: '댓글을 입력하세요',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.only(right: 8.0, left: 8),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: submitComment,
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: commentList(postId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '데이터를 불러오는 중 오류가 발생했습니다: ${snapshot.error}',
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: Text(
                                '댓글을 작성해주세요.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        // print(snapshot.data);
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Container(
                              child: CommentItem(
                                  comment: item,
                                  postId: article['id'].toString()),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// 좋아요 버튼 위젯
class LikeButtonWidget extends StatefulWidget {
  final String postId;
  bool isLiked;
  final Function onLikeToggle; // 추가: 좋아요 토글 콜백

  LikeButtonWidget({
    super.key,
    required this.postId,
    required this.isLiked,
    required this.onLikeToggle, // 수정
  });

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
        color: widget.isLiked ? Colors.red : Colors.grey,
        size: 24,
      ),
      onPressed: () async {
        // 좋아요 토글 로직 실행
        await toggleLike(widget.postId, widget.isLiked);
        widget.onLikeToggle(!widget.isLiked);
      },
    );
  }

  // 좋아요 토글 기능
  Future<void> toggleLike(String postId, bool isLiked) async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final url = '${dotenv.env['baseUrl']}boards/$postId/likes';
    try {
      final response = isLiked
          ? await dio.delete(url,
              options:
                  Options(headers: {'authorization': 'Bearer $accessToken'}))
          : await dio.post(url,
              options:
                  Options(headers: {'authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final likeSnackBarText = isLiked ? '따봉을 취소했습니다' : '이 글에 따봉을 눌렀습니다.';
        // 스낵바 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(likeSnackBarText),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      print('Error occurred while toggling like: $e');
      rethrow;
    }
  }
}

// 북마크 버튼 위젯
class BookmarkButtonWidget extends StatefulWidget {
  final String postId;
  bool isBookmarked;
  BookmarkButtonWidget(
      {super.key, required this.postId, required this.isBookmarked});

  @override
  _BookmarkButtonWidgetState createState() => _BookmarkButtonWidgetState();
}

class _BookmarkButtonWidgetState extends State<BookmarkButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: widget.isBookmarked ? Colors.amber : Colors.grey,
        size: 24,
      ),
      onPressed: () async {
        // 북마크 토글 로직 실행
        await toggleBookmark(widget.postId, widget.isBookmarked);
        setState(() {
          widget.isBookmarked = !widget.isBookmarked;
        });
      },
    );
  }

  // 북마크 토글 기능
  Future<void> toggleBookmark(String postId, bool isBookmarked) async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final url = '${dotenv.env['baseUrl']}boards/$postId/scraps';
    try {
      final response = isBookmarked
          ? await dio.delete(url,
              options:
                  Options(headers: {'authorization': 'Bearer $accessToken'}))
          : await dio.post(url,
              options:
                  Options(headers: {'authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 스낵바 메시지 설정
        final snackBarText = isBookmarked ? '스크랩을 취소했습니다' : '이 글을 스크랩했습니다';
        // 스낵바 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackBarText),
            duration: const Duration(seconds: 2),
          ),
        );

        setState(() {});
      }
    } catch (e) {
      print('Error occurred while toggling bookmark: $e');
      // 오류 발생 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
      rethrow;
    }
  }
}
