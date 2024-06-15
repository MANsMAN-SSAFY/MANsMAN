import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/cosmetics/cosmetics_card.dart';
import 'package:app/components/cosmetics/similar_card.dart';
import 'package:app/model/cosmetics/cosmetics_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CosmeticsDetailPage extends StatefulWidget {
  final int id;
  CosmeticsDetailPage({super.key, required this.id});

  @override
  State<CosmeticsDetailPage> createState() => _CosmeticsDetailPageState();
}

class _CosmeticsDetailPageState extends State<CosmeticsDetailPage> {
  String? productUrl;
  Future<Map<String, dynamic>> getProductDetail() async {
    final storage = FlutterSecureStorage();
    final Dio dio = Dio();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    print('시작');
    try {
      final response = await dio.get(
        'https://j10e106.p.ssafy.io/api/products/${widget.id}',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      // 상품의 URL을 상태로 저장
      productUrl = response.data['linkUrl'];
      return response.data;
    } on DioException catch (e) {
      // 에러 핸들링
      print("Error occurred while fetching search results: ${e.message}");
      return {};
    }
  }


  Future<void> _launchUrl() async {

    if (productUrl == null) return print('시작');

    final Uri _url = Uri.parse(productUrl!);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: FutureBuilder<Map<String, dynamic>>(
        builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final item = CosmeticsDetailModel.fromJson(json: snapshot.data!);
          return CustomScrollView(
            slivers: [
              renderTop(
                model: item,
              ),
            ],
          );
        },
        future: getProductDetail(),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _launchUrl(),
          // 결제 페이지로 이동하는 로직

          child: Text(
            '구매하러 가기',
            style: AppTexts.header3,
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required CosmeticsDetailModel model,
  }) {
    return SliverToBoxAdapter(
        child: CosmeticsDeatilCard.fromModel(
          model: model,
        ));
  }


}