import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/components/cosmetics/recommend_product_card.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/components/myProfile_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CosmeticsFavoritesPage extends StatefulWidget {
  const CosmeticsFavoritesPage({super.key});

  @override
  State<CosmeticsFavoritesPage> createState() => _CosmeticsFavoritesPageState();
}

class _CosmeticsFavoritesPageState extends State<CosmeticsFavoritesPage> {
  Future<List<dynamic>>? selectedFuture;
  final storage = const FlutterSecureStorage();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    selectedFuture = getProductList(); // 기본값으로 설정
  }

  Future<List<dynamic>> getProductList() async {
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl = 'https://j10e106.p.ssafy.io/api/products/favorites';

    final response = await dio.get(
      apiUrl,
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '즐겨찾기',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.serach);
          },
          icon: AppIcons.serach,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: const MyProfileImage(),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FutureBuilder<List>(
                future: selectedFuture,
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      // parsed item
                      final pItem = CosmeticsModel.fromJson(json: item);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_)=> CosmeticsDetailPage(id: pItem.id))); //id: pItem.id
                        },
                        child: CosmeticsCard.fromModel(
                          model: pItem,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 8.0,
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
