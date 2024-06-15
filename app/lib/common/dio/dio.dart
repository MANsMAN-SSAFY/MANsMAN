// // import 'package:app/common/default_layout/default_layout.dart';
// // import 'package:app/common/dio/dio.dart';
// // import 'package:app/common/style/app_colors.dart';
// // import 'package:app/common/style/app_icons.dart';
// // import 'package:app/common/style/app_texts.dart';
// // import 'package:app/components/myProfile_image.dart';
// // import 'package:app/config/app_routes.dart';
// // import 'package:app/model/cosmetics/cosmetics_model.dart';
// // import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// // import 'package:dio/dio.dart';
// //
// // final dioProvider = Provider(create: create)
//
// const ip = '192.168.30.111';
// // const iP = 'https://j10e106.p.ssafy.io/api/'
//
// import 'package:app/common/default_layout/default_layout.dart';
// import 'package:app/common/style/app_colors.dart';
// import 'package:app/common/style/app_texts.dart';
// import 'package:app/components/cosmetics/cosmetics_card.dart';
// import 'package:app/components/cosmetics/similar_card.dart';
// import 'package:app/model/cosmetics/cosmetics_detail_model.dart';
// import 'package:app/model/cosmetics/similar_model.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class CosmeticsDetailPage extends StatelessWidget {
//   final int id;
//   CosmeticsDetailPage({super.key, required this.id});
//   String? productUrl;
//
//   // 상품 상세 조회
//   Future<Map<String, dynamic>> getProductDetail() async {
//     final storage = FlutterSecureStorage();
//     final Dio dio = Dio();
//
//     final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
//     print('시작');
//     try {
//       final response = await dio.get(
//         'https://j10e106.p.ssafy.io/api/products/$id',
//         options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
//       );
//       productUrl = response.data['linkUrl'];
//       print(productUrl);
//       return response.data;
//     } on DioException catch (e) {
//       // 에러 핸들링
//       print("Error occurred while fetching search results: ${e.message}");
//       return {};
//     }
//   }
//
//   Future<List<SimilarModel>> getSimilarProduct() async {
//     final storage = FlutterSecureStorage();
//     final Dio dio = Dio();
//
//     final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
//     print('시작');
//     try {
//       final response = await dio.get(
//         'https://j10e106.p.ssafy.io/api/products/$id/similar',
//         options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
//       );
//       List<dynamic> data = response.data;
//       List<SimilarModel> products = data.map((item) => SimilarModel.fromJson(json: item)).toList();
//       return products;
//     } on DioException catch (e) {
//       // 에러 핸들링
//       print("Error occurred while fetching search results: ${e.message}");
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultLayout(
//       title: '',
//       child: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<Map<String, dynamic>>(
//               future: getProductDetail(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final item = CosmeticsDetailModel.fromJson(json: snapshot.data!);
//                 return CustomScrollView(
//                   slivers: [
//                     renderTop(model: item),
//                   ],
//                 );
//               },
//             ),
//           ),
//           // Expanded(
//           //   child: FutureBuilder<List<SimilarModel>>(
//           //     future: getSimilarProduct(),
//           //     builder: (context, snapshot) {
//           //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           //         return Center(child: CircularProgressIndicator());
//           //       }
//           //       List<SimilarModel> products = snapshot.data!;
//           //       return ListView.builder(
//           //         scrollDirection: Axis.horizontal,
//           //         itemCount: products.length,
//           //         itemBuilder: (context, index) {
//           //           SimilarModel product = products[index];
//           //           return SimilarCard.fromModel(
//           //             model: product, // 수정: 리스트의 각 항목에 대한 모델을 전달
//           //           );
//           //         },
//           //       );
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 70,
//         padding: EdgeInsets.all(8.0),
//         child: ElevatedButton(
//           onPressed: () => _launchUrl()
//           // 결제 페이지로 이동하는 로직
//           ,
//           child: Text(
//             '구매하러 가기',
//             style: AppTexts.header3,
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: AppColors.white,
//             backgroundColor: AppColors.blue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   SliverToBoxAdapter renderTop({
//     required CosmeticsDetailModel model,
//   }) {
//     return SliverToBoxAdapter(
//         child: CosmeticsDeatilCard.fromModel(
//           model: model,
//         ));
//   }
//
//   SliverToBoxAdapter renderProduct({
//     required SimilarModel model,
//   }) {
//     return SliverToBoxAdapter(
//       child: Container(
//         height: 200, // 이 값을 조절하여 카드의 높이를 변경
//         child: ListView.builder(
//           itemCount: 10, // 생성할 아이템의 개수
//           scrollDirection: Axis.horizontal, // 리스트를 가로로 스크롤하도록 설정
//           itemBuilder: (context, index) {
//             return SimilarCard.fromModel(
//               model: model,
//             ); // 여기서 SimilarCard()는 가로로 정렬될 위젯
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<void> _launchUrl() async {
//     if (productUrl == null) return;
//
//     final Uri _url = Uri.parse(productUrl!);
//     if (!await launchUrl(_url)) {
//       throw 'Could not launch $_url';
//     }
//   }
// }
