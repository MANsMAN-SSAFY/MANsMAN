// 패키지
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/components/my_article.dart';
import 'package:app/components/my_scrap.dart';
import 'package:app/components/profile_cosmetics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../store/user.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) onTabSelected;
  final int initialTabIndex;
  const ProfilePage(
      {super.key, required this.onTabSelected, this.initialTabIndex = 1});

  @override
  State<ProfilePage> createState() => _ProfilePAgeState();
}

class _ProfilePAgeState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // isloading
  bool isloading = true;

  // [변수] 현재 페이지
  int currentIndex = 0;

  // [리스트] 화장품
  List<String> products = [];

  // ProfilePage 안에서 탭
  TabController? _tabController;
  final int tab = 0;

  final storage = FlutterSecureStorage();
  final Dio dio = Dio();

  Map<String, dynamic>? result;
  Map<String, dynamic>? profileData;
  String? nickname;
  String? faceShape;
  String? skinType;
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
        result = response.data as Map<String, dynamic>;
        isloading = false;
      });
      print(result);
      print(result?['nickname']);
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
    getProfile();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController?.addListener(() {
      if (!_tabController!.indexIsChanging) {
        widget.onTabSelected(_tabController!.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> translatedTypes = {
      "NORMAL": "복합성",
      "OILY": "지성",
      "DRY": "건성"
    };
    // User 프로바이더에서 프로필 정보 가져오기
    final userProvider = Provider.of<User>(context);
    final nickname = userProvider.profile?['nickname'];
    final faceShape = result?['report']?['faceShape'];
    final skinType = result?['report']?['skinType'];
    return DefaultLayout(
      title: '프로필',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.setting);
          },
          icon: AppIcons.setting,
        ),
      ],
      child: isloading == true
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
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${result?['nickname']}',
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
                                          child: (result != null && result?['report'] != null && result?['report']['faceShape'] != null)
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
                                                      "${result?['report']['faceShape']}",
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

                                          child: (result != null && result?['report'] != null && result?['report']['skinType'] != null)
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
                                                      "${translatedTypes[result?['report']['skinType']]}",
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
                  TabBar(
                      controller: _tabController,
                      indicatorColor:
                          AppColors.blue, // Color of the indicator line
                      labelColor:
                          AppColors.blue, // Color of the text for selected tabs
                      unselectedLabelColor: AppColors.black,
                      tabs: const [
                        Tab(
                          text: '글',
                        ),
                        Tab(
                          text: '화장품',
                        ),
                        Tab(
                          text: '스크랩',
                        )
                      ]),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        MyArticles(),
                        ProfileCosmetics(),
                        MyScrap(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
