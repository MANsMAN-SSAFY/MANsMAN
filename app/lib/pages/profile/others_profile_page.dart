// 패키지
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/cosmetics/recommend_product_card.dart';
import 'package:app/components/other_report.dart';
import 'package:app/components/other_write_articles.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtherProfilePage extends StatefulWidget {
  final Function(int) onTabSelected;
  final int memberId;
  const OtherProfilePage(
      {super.key, required this.onTabSelected, required this.memberId});

  @override
  State<OtherProfilePage> createState() => _ProfilePAgeState();
}

class _ProfilePAgeState extends State<OtherProfilePage>
    with SingleTickerProviderStateMixin {
  // [변수] 현재 페이지
  int currentIndex = 0;
  bool isLoading = true;

  // [리스트] 화장품
  List<String> products = [];

  // OtherProfilePage 안에서 탭
  TabController? _tabController;
  final int tab = 0;

  Map<String, dynamic>? result;

  Future<Map<String, dynamic>> getOtherProfile() async {
    print('시작');
    print(widget.memberId);
    const storage = FlutterSecureStorage();
    final Dio dio = Dio();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    print('1111111111111');
    try {
      final response = await dio.get(
        'https://j10e106.p.ssafy.io/api/members/${widget.memberId}/profiles',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      print('22222222222222');
      print(result?['report']['faceShape']);
      setState(() {
        result = response.data as Map<String, dynamic>;
        isLoading = false;
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
    getOtherProfile();
    selectedFuture = getProductList(); // 기본값으로 설정
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<List<dynamic>>? selectedFuture;
  final storage = const FlutterSecureStorage();
  final Dio dio = Dio();

  Future<List<dynamic>> getProductList() async {
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl =
        'https://j10e106.p.ssafy.io/api/${widget.memberId}/my-products';
    final response = await dio.get(
      apiUrl,
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    // print(response.data);
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> translatedTypes = {
      "NORMAL": "복합성",
      "OILY": "지성",
      "DRY": "건성"
    };
    final nickname = result?['nickname'];
    final faceShape = result?['report']['faceShape'];
    final skinType = result?['report']['skinType'];
    return DefaultLayout(
      title: '프로필',
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       Navigator.of(context).pushNamed(AppRoutes.setting);
      //     },
      //     icon: AppIcons.setting,
      //   ),
      // ],
      // 타인페이지 에서는 설정 없어야 하는거 아닐까...? -동영
      child: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.blue,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const MyProfileImage(
                          size: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$nickname',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: faceShape != null
                                              ? Container(
                                                  height: 30,
                                                  width: 110,
                                                  margin: const EdgeInsets.only(
                                                      top: 8),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.tag,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Center(
                                                    child: Text(
                                                      "$faceShape",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          child: skinType != null
                                              ? Container(
                                                  height: 30,
                                                  width: 90,
                                                  margin: const EdgeInsets.only(
                                                      top: 8),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.tag,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Center(
                                                    child: Text(
                                                      "${translatedTypes[skinType]}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TabBar(controller: _tabController, tabs: const [
                    Tab(
                      text: '글',
                    ),
                    Tab(
                      text: '화장품',
                    ),
                    Tab(
                      text: '소개',
                    )
                  ]),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        OtherWriteArticles(
                            memberId: widget.memberId.toString()),
                        Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: FutureBuilder<List>(
                                  future: selectedFuture,
                                  builder:
                                      (context, AsyncSnapshot<List> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text(
                                        '등록한 상품이 없어요',
                                        style: AppTexts.body1,
                                      ));
                                    }
                                    return ListView.separated(
                                      itemBuilder: (_, index) {
                                        final item = snapshot.data![index];
                                        // parsed item
                                        final pItem =
                                            CosmeticsModel.fromJson(json: item);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CosmeticsDetailPage(
                                                            id: pItem
                                                                .id))); //id: pItem.id
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
                        OtherReport(
                          memberId: widget.memberId.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
