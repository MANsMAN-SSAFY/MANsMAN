import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:app/store/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/cosmetics/recommend_product_card.dart';

class CosmeticsPage extends StatefulWidget {
  const CosmeticsPage({super.key});

  @override
  _CosmeticsPageState createState() => _CosmeticsPageState();
}

class _CosmeticsPageState extends State<CosmeticsPage> {
  bool isloading = true;

  Map<String, dynamic>? profileData;
  Future<List<dynamic>>? selectedFuture;
  final storage = const FlutterSecureStorage();
  final Dio dio = Dio();
  Future<Map<String, dynamic>> getProfile() async {
    print('여기 통과');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl = 'https://j10e106.p.ssafy.io/api/members/profiles';
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print('여기는 통과하나');
      setState(() {
        profileData = response.data;
        isloading = false;
      });
      return response.data;
    } on DioException catch (e) {
      // 에러 핸들링
      print("Error occurred while fetching search results: ${e.message}");
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    selectedFuture = getProductList(); // 기본값으로 설정
    getReport();
    getProfile(); // 프로필 데이터 로딩
  }

  String? provider_skinType;

  // 리포트 불러오기
  Future<Map<String, dynamic>> getReport() async {
    print('시작');

    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

    try {
      final response = await dio.get(
        'https://j10e106.p.ssafy.io/api/reports/scroll?&pageSize=1',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      provider_skinType = response.data['data'][0]['skinType'];
      print("스킨타입");
      print(provider_skinType);
      return response.data;
    } catch (e) {
      print("Unexpected error: $e");
      return {};
    }
  }

  Future<List<dynamic>> getProductList(
      {String category = 'recommendation/all'}) async {
    const storage = FlutterSecureStorage();
    final Dio dio = Dio();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl = 'https://j10e106.p.ssafy.io/api/$category';

    final response = await dio.get(
      apiUrl,
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    return response.data;
  }

  // 옵션 목록
  final List<String> options = ['추천 상품', '피부별', '연령대', '인기 상품'];

  // 현재 선택된 옵션 추적
  String? selectedOption = 'recommendation/all';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> translatedTypes = {
      "지성": "지성",
      "건성": "건성",
      "정상": "복합성",
    };

    final userProvider = Provider.of<User>(context, listen: false);
    var providerNickname = profileData?['nickname'];
    final providerBirthday = userProvider.profile?['birthday'];
    DateTime birthday;

    if (providerBirthday != null) {
      birthday = DateTime.parse(providerBirthday);
    } else {
      birthday = DateTime.now();
    }
    // 현재 날짜
    DateTime today = DateTime.now();

    int age = today.year - birthday.year;
    // 만약 오늘 날짜가 생일 이전이라면, 나이에서 1을 뺍니다.
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    String ages = '';

    if (age < 20) {
      ages = '10대';
    } else if (age < 30) {
      ages = '20대';
    } else if (age < 40) {
      ages = '30대';
    } else if (age < 50) {
      ages = '40대';
    } else if (age < 60) {
      ages = '50대';
    } else {
      ages = '형님';
    }

    return DefaultLayout(
      title: '맨픽',
      titleColor: AppColors.white,
      appBarBackgroundColor: AppColors.blue,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.serach);
          },
          icon: AppIcons.serach2,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.favorites);
          },
          icon: AppIcons.favorites2,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: const MyProfileImage(),
        ),
      ],
      child: Scaffold(
        body: isloading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blue,
                ),
              )
            : Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.skin);
                                },
                                icon: Image.asset(
                                  'assets/images/skin.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              Text(
                                '스킨케어',
                                style: AppTexts.body2
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     IconButton(
                          //       onPressed: () {
                          //         Navigator.of(context).pushNamed(AppRoutes.hair);
                          //       },
                          //       icon: Image.asset(
                          //         'assets/images/hair.png',
                          //         height: 50,
                          //         width: 50,
                          //       ),
                          //     ),
                          //     Text(
                          //       '헤어케어',
                          //       style:
                          //           AppTexts.body2.copyWith(color: AppColors.white),
                          //     ),
                          //   ],
                          // ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.maskpack);
                                },
                                icon: Image.asset(
                                  'assets/images/mask.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              Text(
                                '마스크팩',
                                style: AppTexts.body2
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$providerNickname',
                            style:
                                AppTexts.body1.copyWith(color: AppColors.blue),
                          ),
                          Text(
                            '님을 위한 추천',
                            style:
                                AppTexts.body1.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 7,
                      top: 15,
                    ),
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  foregroundColor:
                                      selectedOption == 'recommendation/all'
                                          ? AppColors.white
                                          : AppColors.black,
                                  backgroundColor:
                                      selectedOption == 'recommendation/all'
                                          ? AppColors.blue
                                          : AppColors.white.withOpacity(0.99),
                                  // foregroundColor: AppColors.black,
                                  // backgroundColor: AppColors.white.withOpacity(0.99),

                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedOption = 'recommendation/all';
                                    selectedFuture = getProductList(
                                        category: 'recommendation/all');
                                  });
                                },
                                child: const Text(
                                  '추천 상품',
                                  style: AppTexts.body4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  foregroundColor: selectedOption ==
                                          'recommendation/skinType'
                                      ? AppColors.white
                                      : AppColors.black,
                                  backgroundColor: selectedOption ==
                                          'recommendation/skinType'
                                      ? AppColors.blue
                                      : AppColors.white.withOpacity(0.99),
                                  // foregroundColor: AppColors.black,
                                  // backgroundColor: AppColors.white.withOpacity(0.99),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedOption = 'recommendation/skinType';
                                    selectedFuture = getProductList(
                                        category: 'recommendation/skinType');
                                  });
                                },
                                child: provider_skinType == null
                                    ? const Text(
                                        '피부별',
                                        style: AppTexts.body4,
                                      )
                                    : Text(
                                        '${translatedTypes[provider_skinType]}',
                                        style: AppTexts.body4,
                                      ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  foregroundColor:
                                      selectedOption == 'recommendation/age'
                                          ? AppColors.white
                                          : AppColors.black,
                                  backgroundColor:
                                      selectedOption == 'recommendation/age'
                                          ? AppColors.blue
                                          : AppColors.white.withOpacity(0.99),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedOption = 'recommendation/age';
                                    selectedFuture = getProductList(
                                        category: 'recommendation/age');
                                  });
                                },
                                child: Text(
                                  '$ages를 위한 추천',
                                  style: AppTexts.body4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  foregroundColor: selectedOption ==
                                          'recommendation/hot-products'
                                      ? AppColors.white
                                      : AppColors.black,
                                  backgroundColor: selectedOption ==
                                          'recommendation/hot-products'
                                      ? AppColors.blue
                                      : AppColors.white.withOpacity(0.99),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedOption =
                                        'recommendation/hot-products';
                                    selectedFuture = getProductList(
                                        category: 'products/hot-products');
                                  });
                                },
                                child: const Text(
                                  '인기상품',
                                  style: AppTexts.body4,
                                ),
                              ),
                            ),
                            // OutlinedButton(
                            //   style: OutlinedButton.styleFrom(
                            //     padding: EdgeInsets.all(4),
                            //     foregroundColor: AppColors.black,
                            //     backgroundColor: AppColors.white.withOpacity(0.99),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(12),
                            //       ),
                            //     ),
                            //   ),
                            //   onPressed: () {},
                            //   child: Text(
                            //     '최근 본 상품',
                            //     style: AppTexts.body4,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: FutureBuilder<List>(
                        future: selectedFuture,
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: Text(
                              '리포트를 작성해 주세요',
                              style: AppTexts.body1,
                            ));
                          }
                          return ListView.separated(
                            itemBuilder: (_, index) {
                              final item = snapshot.data![index];
                              // parsed item
                              final pItem = CosmeticsModel.fromJson(json: item);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => CosmeticsDetailPage(
                                          id: pItem.id))); //id: pItem.id
                                },
                                child: CosmeticsCard.fromModel(
                                  model: pItem,
                                ),
                              );
                            },
                            separatorBuilder: (_, index) {
                              return const SizedBox(
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
      ),
    );
  }
}
