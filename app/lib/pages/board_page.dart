import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/community/boards_list.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/model/articles/articles.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/cosmetics/recommend_product_card.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // late Future<List> _articleListFuture;
  final Future<List> _articleListFuture = Future.value([]);
  List<dynamic> notiList = [];

  void fetchNotifications() async {
    String? token = await FirebaseMessaging.instance.getToken();
    var snapshot = await FirebaseFirestore.instance
        .collection("noti")
        .where("token", isEqualTo: token)
        .get();

    setState(() {
      notiList = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    // _refreshArticleList();
  }

  Future<List> articleList() async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    final response = await dio.get(
      '${dotenv.env['baseUrl']}boards?pageSize=50',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    return response.data['data'];
  }

  @override
  void setState(VoidCallback fn) {
    // _articleListFuture;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시판',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.notifications);
          },
          icon: Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications),
              if (notiList.isNotEmpty) // 알림 리스트가 비어있지 않다면 뱃지를 표시
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '${notiList.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: const MyProfileImage(),
        ),
      ],
      child: Scaffold(
        body: FutureBuilder<List>(
          future: articleList(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('데이터를 불러오는 중 오류가 발생했습니다: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('데이터가 없습니다.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                final pItem = Articles.fromJson(item);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.detail,
                      arguments: pItem.id, // postId를 arguments로 전달
                    );
                  },
                  child: ArticleItem.fromModel(models: pItem),
                );
              },
            );
          },
        ),
        floatingActionButton: SizedBox(
          width: 100,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.create);
            },
            backgroundColor: AppColors.blue,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mode_edit,
                  color: Colors.white,
                ),
                SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격 추가
                Text(
                  '글쓰기',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
