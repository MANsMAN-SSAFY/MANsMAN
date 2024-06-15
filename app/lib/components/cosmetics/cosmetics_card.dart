import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/cosmetics/similar_card.dart';
import 'package:app/model/cosmetics/cosmetics_detail_model.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/model/cosmetics/similar_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CosmeticsDeatilCard extends StatelessWidget {
  final int id; // 상품의 순위
  final Widget image; // 상품 이미지
  final String name; // 상품 이름

  final double avgRating; // 상품 평점
  final int cntRating; // 상품 평가 갯수
  final bool isFavorite; // 스크랩
  final int price; // 상품 가격
  final String capacity; // 상품 용량
  final bool isDetail; // 상세설명 여부
  final String? detail; // 상세내용
  final String mainPoint; // 피부 타입
  final String? useDate; // 사용기한
  final String? howUse; // 사용 방법
  final String? material; // 재료
  final List<String>? imgList; // 이미지 상세설명
  const CosmeticsDeatilCard(
      {super.key,
      required this.id,
      required this.image,
      required this.name,
      required this.avgRating,
      required this.cntRating,
      required this.isFavorite,
      required this.price,
      required this.capacity,
      this.isDetail = false,
      this.detail,
      required this.mainPoint,
      this.useDate,
      this.howUse,
      this.material,
      this.imgList});

  factory CosmeticsDeatilCard.fromModel({
    required CosmeticsDetailModel model,
  }) {
    return CosmeticsDeatilCard(
      image: Image.network(
        model.imgUrl,
      ),
      name: model.name,
      // brand: model.brand,
      avgRating: model.avgRating,
      isFavorite: model.favorite,
      price: model.price,
      capacity: model.capacity,
      cntRating: model.cntRating,
      id: model.id,
      imgList: model.imgList,
      mainPoint: model.mainPoint,
    );
  }

  Future<List<SimilarModel>> getSimilarProduct() async {
    final storage = FlutterSecureStorage();
    final Dio dio = Dio();

    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    print('2222222');
    try {
      final response = await dio.get(
        'https://j10e106.p.ssafy.io/api/products/$id/similar',
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

  @override
  Widget build(BuildContext context) {
    // price를 천 단위 구분 기호를 사용하여 포맷팅
    final formattedPrice = NumberFormat('#,###', 'en_US').format(price);

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: image,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 4.0,
              ),
              Text(
                name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTexts.header3,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    avgRating.toString(),
                    style: AppTexts.body1,
                  ),
                  Text(
                    ' (${cntRating})',
                    style: AppTexts.body1,
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Row(
                  children: [
                    Text(
                      '$formattedPrice 원',
                      style: AppTexts.body1,
                    ),
                    Text(
                      capacity.length > 20 ? ' / ${capacity.substring(0, 20)}...' :' / $capacity',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.body2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 40,
                width: 30,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('[강추]   $mainPoint'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.blue.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: AppColors.iconBlack.withOpacity(0.4), width: 1),
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imgList != null)
              SizedBox(
                height: 8.0,
              ),
            Column(
              children:
                  imgList!.map((imgUrl) => Image.network(imgUrl)).toList(),
            ),
          ],
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '이런 제품은 어때요?',
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
                          Navigator.of(context).pushReplacement(
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
      ],
    );
  }
}
