import 'package:app/common/style/app_colors.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyArticles extends StatefulWidget {
  const MyArticles({super.key});

  @override
  State<MyArticles> createState() => _MyArticlesState();
}

Future<List<dynamic>> getMyArticles() async {
  final dio = Dio();
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

  try {
    final response = await dio.get("${dotenv.env['baseUrl']}members/boards",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ));

    print(response.data);
    return response.data;
  } catch (e) {
    print(e);
    rethrow;
  }
}

class _MyArticlesState extends State<MyArticles> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMyArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '데이터를 불러오는 중 오류가 발생했습니다: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '작성한 글이 없습니다.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.detail, arguments: item['id']);
                    },
                    child: Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        item["title"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "작성자 : ${item['writer']["nickname"]}",
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
                                        item["content"],
                                        maxLines: 3, // 최대 3줄까지 표시
                                        overflow:
                                            TextOverflow.ellipsis, // 3줄 초과시 생략
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: item['boardImageList'].isNotEmpty
                                        ? Image.network(
                                            item['boardImageList'][0]
                                                ['boardImgUrl'],
                                            height: 100,
                                            width: 100,
                                          )
                                        : Image.asset(
                                            'assets/images/msmLogo.png',
                                            height: 100,
                                            width: 100,
                                          ), //썸네일
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
                                            item["viewCnt"].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.blue),
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
                                            item["likeCnt"].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.blue),
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
                                            item["commentCnt"].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(item["createdAt"]
                                    .toString()
                                    .substring(0, 10))
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                  );
                }),
          );
        });
  }
}
