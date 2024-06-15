import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/cosmetics/similar_card.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/model/cosmetics/similar_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:app/store/diary/skin_picture_store.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> notiList = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<List<SimilarModel>> getSimilarProduct() async {
    final storage = FlutterSecureStorage();
    final Dio dio = Dio();

    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    print('2222222');
    try {
      final response = await dio.get(
        'https://j10e106.p.ssafy.io/api/recommendation/all',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('33333333333');
      List<dynamic> data = response.data;
      print(data);
      List<SimilarModel> products =
      data.map((item) => SimilarModel.fromJson(json: item)).toList();
      print('4444444444');
      print(products);
      return products;
    } on DioException catch (e) {
      // 에러 핸들링
      print("Error occurred while fetching search results: ${e.message}");
      return [];
    }
  }

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
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context, listen: false);
    var provider_nickname = userProvider.profile?['nickname'];
    final reportProvider = Provider.of<MySkinPictures>(context, listen: false);
    final length = reportProvider.lastId.length;
    print('11111111111111');
    print(length);
    print(notiList);
    return DefaultLayout(
      title: 'MANsMAN',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.serach);
          },
          icon: AppIcons.serach,
        ),
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
      child: length != 1 ? Center(
        child : Text('피부 일지를 생성하세요')
      ) : Column(children:[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${provider_nickname}님을 위한 추천 제품',
                style: AppTexts.body1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: FutureBuilder<List<SimilarModel>>(
            future: getSimilarProduct(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('상품을 불러오는데 실패했습니다.'));
              }
              List<SimilarModel> products = snapshot.data!;
              return Container(
                height: 500,
                child: ListView.builder(
                  physics: ScrollPhysics(), // 스크롤 가능하게 설정
                  scrollDirection: Axis.horizontal, // 수평 스크롤 설정
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    SimilarModel product = products[index];
                    return Container(
                      width: 100, // 각 항목의 너비를 명시적으로 설정
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_)=> CosmeticsDetailPage(id: product.id)));
                        },
                        child: SimilarCard.fromModel(
                          model: product, // 수정: 리스트의 각 항목에 대한 모델을 전달
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
