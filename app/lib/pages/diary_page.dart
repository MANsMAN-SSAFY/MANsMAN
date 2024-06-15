// diary_page.dart 파일
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/components/health_info.dart';
import 'package:app/store/diary/diary_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/components/skin_picture.dart';
import 'package:app/components/skin_state.dart';
import 'package:app/components/one_line_memo.dart';
import 'package:app/components/diary_tag.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:app/components/Modal/memo_ui.dart';
import 'package:app/store/user.dart';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 스토어
import 'package:app/store/diary/hash_tag.dart';
import 'package:app/store/diary/memo.dart';
import 'package:app/store/diary/my_skin_state.dart';
import 'package:app/store/router.dart';
// 통신
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/store/diary/skin_picture_store.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late InfiniteScrollController _carouselController;
  List<dynamic> notiList = [];
  int pageSize = 10;
  int selectedIndex = 0;
  String reportDate = "";
  List skinData = [];
  String reportId = "";

  Future<List> diaryDio() async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        "${dotenv.env['baseUrl']}reports/scroll?pageSize=$pageSize",
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        print(response.data);

        Provider.of<MySkinPictures>(context, listen: false)
            .diaryGetReport(data);

        Provider.of<MySkinPictures>(context, listen: false)
            .setLastId(response.data["lastId"].toString());
        print(response.data["lastId"].toString());
        Provider.of<MySkinPictures>(context, listen: false)
            .setHasNext(response.data["hasNext"]);

        setState(() {
          if (Provider.of<MySkinPictures>(context, listen: false)
              .hasTodaysPhoto()) {
            selectedIndex = min(
                Provider.of<MySkinPictures>(context, listen: false)
                        .reportList
                        .length -
                    1,
                pageSize - 1);
          } else {
            selectedIndex = min(
                Provider.of<MySkinPictures>(context, listen: false)
                    .reportList
                    .length,
                pageSize - 1);
          }
        });
      }
    } catch (e) {
      print("다이어리 페이지 에러 : $e");
    }
    return reportList;
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
  void initState() {
    super.initState();
    fetchNotifications();

    // Provider를 사용하여 초기 selectedIndex를 설정합니다.
    // selectedIndex = Provider.of<MySkinPictures>(context, listen: false)
    //         .hasTodaysPhoto()
    //     ? Provider.of<MySkinPictures>(context, listen: false)
    //             .reportList
    //             .length -
    //         1
    //     : Provider.of<MySkinPictures>(context, listen: false).reportList.length;
    if (pageSize <=
        Provider.of<MySkinPictures>(context, listen: false).reportList.length) {
      selectedIndex =
          Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto()
              ? pageSize - 2 //아님
              : pageSize;
    } else {
      selectedIndex =
          Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto()
              ? max(
                  Provider.of<MySkinPictures>(context, listen: false)
                          .reportList
                          .length -
                      2,
                  0)
              : max(
                  Provider.of<MySkinPictures>(context, listen: false)
                          .reportList
                          .length -
                      1,
                  0);
    }
    _carouselController = InfiniteScrollController(initialItem: selectedIndex);
    diaryDio().then((_) {
      // 데이터 로딩이 완료된 후에 상태를 업데이트합니다.
      if (Provider.of<MySkinPictures>(context, listen: false)
          .reportList
          .isNotEmpty) {
        setState(() {
          // 리스트의 길이가 0이 아닐 때만 selectedIndex 설정
          // selectedIndex = min(
          //     selectedIndex,
          //     Provider.of<MySkinPictures>(context, listen: false)
          //         .reportList
          //         .length);
          // 이전에 여기에서 _carouselController를 초기화했었습니다.
          _carouselController.jumpToItem(selectedIndex);
        });
      }

      if (Provider.of<MySkinPictures>(context, listen: false)
          .hasTodaysPhoto()) {
        final userProvider = Provider.of<User>(context, listen: false);
        var providerId = userProvider.profile?['id'];

        Provider.of<DiaryProvider>(context, listen: false).setDiaryInfo({
          "selectedIndex": selectedIndex,
          "reportId": Provider.of<MySkinPictures>(context, listen: false)
              .reportList[selectedIndex]['reportId'],
          "memberId": providerId,
          "memo": Provider.of<MySkinPictures>(context, listen: false)
              .reportList[selectedIndex]['memo'],
          "tags": Provider.of<MySkinPictures>(context, listen: false)
              .reportList[selectedIndex]['tags'],
          "sleep": Provider.of<MySkinPictures>(context, listen: false)
                  .reportList[selectedIndex]['sleep'] ??
              0,
          "water": Provider.of<MySkinPictures>(context, listen: false)
                  .reportList[selectedIndex]['water'] ??
              0,
        });

        // Provider.of<DiaryProvider>(context, listen: false)
        //     .getReport(context, reportId, selectedIndex);
      }

      updateSkinData();
    });
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto() ==
        false) {
      // selectedIndex++;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // 컨트롤러를 사용이 끝났을 때 리소스를 해제합니다.
    _carouselController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    Provider.of<MySkinPictures>(context, listen: false).reportList;
    print(DateTime.now().toString());
    if (Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto() ==
            false &&
        selectedIndex ==
            Provider.of<MySkinPictures>(context, listen: false)
                .reportList
                .length) {
      reportDate = DateTime.now().toString();
    } else if (selectedIndex != -1) {
      reportDate = Provider.of<MySkinPictures>(context, listen: false)
          .reportList[selectedIndex]['date'];
    }

    if (Provider.of<MySkinPictures>(context, listen: false)
        .reportList
        .isNotEmpty) {
      selectedIndex = min(
          selectedIndex,
          Provider.of<MySkinPictures>(context, listen: false)
              .reportList
              .length);
    }

    super.setState(fn);
  }

  List<Map<String, dynamic>> createSkinData(
      int selectedIndex, MySkinPictures mySkinPictures) {
    // selectedIndex가 mySkinPictures.reportList.length와 같으면 빈 리스트를 반환합니다.
    if (selectedIndex == mySkinPictures.reportList.length) {
      return [];
    }

    final report = mySkinPictures.reportList[selectedIndex];
    final Map<String, String> translatedLabels = {
      'acne': '민감성',
      'wrinkle': '주름',
      // 'blackhead': '블랙헤드',
    };

    List<Map<String, dynamic>> skinData = [
      {
        "type": translatedLabels['acne']!,
        "value": report['acne'],
        "color": const Color(0xffffabab),
      },
      // {
      //   "type": translatedLabels['blackhead']!,
      //   "value": report['blackhead'],
      //   "color": const Color(0xffB6D1FF),
      // },
      {
        "type": translatedLabels['wrinkle']!,
        "value": report['wrinkle'],
        "color": const Color(0xffC4BECD),
      },
    ];

    return skinData;
  }

  void updateSkinData() {
    final mySkinPictures = Provider.of<MySkinPictures>(context, listen: false);

    final newData = createSkinData(selectedIndex, mySkinPictures);

    setState(() {
      // 클래스 레벨의 skinData 변수에 새로운 데이터를 할당합니다.
      skinData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mySkinPictures = Provider.of<MySkinPictures>(context, listen: false);
    // print(mySkinPictures.reportList);
    // print(selectedIndex.toString());
    // 오늘 사진이 없으면 itemCount에 +1을 해줍니다.
    final int itemCount = mySkinPictures.reportList.length +
        (mySkinPictures.hasTodaysPhoto() ? 0 : 1);
    // print(mySkinPictures.hasTodaysPhoto());
    // print(itemCount.toString());
    // print("인덱스 : ${selectedIndex.toString()}");
    if (selectedIndex < mySkinPictures.reportList.length) {
      // print("${mySkinPictures.reportList[selectedIndex]}");
    }
    // print("리포트 갯수 : ${mySkinPictures.reportList.length.toString()}");
    final userProvider = Provider.of<User>(context, listen: false);
    var providerId = userProvider.profile?['id'];

    if (context.watch<MainRouter>().routeIndex != 0) {
      print("페이지 변경");
      selectedIndex =
          Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto()
              ? min(
                  pageSize - 1,
                  Provider.of<MySkinPictures>(context, listen: false)
                          .reportList
                          .length -
                      1)
              : min(
                  pageSize,
                  Provider.of<MySkinPictures>(context, listen: false)
                      .reportList
                      .length);
      print("selectedIndex : ${selectedIndex.toString()}");
    }

    DateTime nowInKorea() {
      var now = DateTime.now().toUtc();
      return now.add(const Duration(hours: 9)); // UTC에서 KST(UTC+9)로 변환
    }

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
      child: mySkinPictures.reportList.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    if (mySkinPictures.reportList.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: InfiniteCarousel.builder(
                            itemCount: itemCount,
                            itemExtent: 200, // 항목의 너비를 설정합니다.
                            scrollBehavior: kIsWeb
                                ? ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      // Allows to swipe in web browsers
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse
                                    },
                                  )
                                : null,
                            loop: false, // 무한 스크롤을 활성화합니다.
                            controller: _carouselController,
                            onIndexChanged: (index) {
                              setState(() {
                                selectedIndex = index;
                                updateSkinData();
                                if (selectedIndex <
                                    mySkinPictures.reportList.length) {
                                  final userProvider =
                                      Provider.of<User>(context, listen: false);
                                  var providerId = userProvider.profile?['id'];

                                  Provider.of<DiaryProvider>(context,
                                          listen: false)
                                      .setDiaryInfo({
                                    "selectedIndex": selectedIndex,
                                    "reportId": mySkinPictures
                                        .reportList[selectedIndex]['reportId'],
                                    "memberId": providerId,
                                    "memo": mySkinPictures
                                        .reportList[selectedIndex]['memo'],
                                    "tags": mySkinPictures
                                        .reportList[selectedIndex]['tags'],
                                    "sleep":
                                        mySkinPictures.reportList[selectedIndex]
                                                ['sleep'] ??
                                            "00:00",
                                    "water":
                                        mySkinPictures.reportList[selectedIndex]
                                                ['water'] ??
                                            0,
                                  });

                                  Provider.of<DiaryProvider>(context,
                                          listen: false)
                                      .getReport(
                                          context,
                                          mySkinPictures
                                              .reportList[selectedIndex]
                                                  ['reportId']
                                              .toString(),
                                          selectedIndex);
                                }
                              });
                            },
                            itemBuilder: (context, index, realIndex) {
                              // 첫 번째 항목이고 오늘 찍은 사진이 없는 경우
                              // itemCount를 조정했기 때문에, index가 reportList의 범위를 벗어나면
                              // "사진 찍으러 가기" 버튼을 표시합니다.
                              if (index == mySkinPictures.reportList.length) {
                                return GestureDetector(
                                  onTap: () {
                                    final router = Provider.of<MainRouter>(
                                        context,
                                        listen: false);
                                    // 타겟 탭의 인덱스를 설정합니다.
                                    router.setIndex(
                                        1); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                                    // MainPage로 이동합니다.
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.main,
                                      ModalRoute.withName('/'),
                                    );
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.tag,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            color: AppColors.black,
                                            size: 100,
                                          ),
                                          Text("사진 찍기",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ],
                                      )),
                                );
                              } else {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(mySkinPictures
                                          .reportList[index]['imgUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                );
                              }
                            }),
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: selectedIndex == 0
                              ? Container(
                                  // padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: mySkinPictures.hasNext
                                          ? AppColors.blue
                                          : AppColors.white,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(20),
                                        right: Radius.circular(20),
                                      )),
                                  child: mySkinPictures.hasNext
                                      ? const Icon(
                                          Icons.add,
                                          color: AppColors.white,
                                        )
                                      : const Icon(
                                          Icons.arrow_back,
                                          color: AppColors.tag,
                                        ),
                                )
                              : const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.blue,
                                ),
                          onPressed: () {
                            if (selectedIndex > 0) {
                              // 첫 번째 아이템이 아닐 경우에만
                              setState(() {
                                selectedIndex--; // 인덱스 감소
                              });
                            } else {
                              setState(() {
                                mySkinPictures.getSkinPictures();
                                mySkinPictures.reportList;
                              });
                            }
                            _carouselController.previousItem(
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                        ),
                        Provider.of<MySkinPictures>(context, listen: false)
                                        .hasTodaysPhoto() ==
                                    false &&
                                selectedIndex ==
                                    Provider.of<MySkinPictures>(context,
                                            listen: false)
                                        .reportList
                                        .length
                            ? Text(
                                nowInKorea().toString().substring(0, 10),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                reportDate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                        mySkinPictures.hasTodaysPhoto()
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: selectedIndex ==
                                          mySkinPictures.reportList.length - 1
                                      ? AppColors.tag
                                      : AppColors.blue,
                                ),
                                onPressed: selectedIndex <
                                        mySkinPictures.reportList.length - 1
                                    ? () {
                                        // 인덱스 증가 로직
                                        setState(() {
                                          selectedIndex++;
                                        });
                                        _carouselController.nextItem(
                                          curve: Curves.easeInOut,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      }
                                    : null, // 마지막 항목이면 null을 할당하여 버튼 비활성화
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: selectedIndex ==
                                          mySkinPictures.reportList.length
                                      ? AppColors.tag
                                      : AppColors.blue,
                                ),
                                onPressed: selectedIndex <
                                        mySkinPictures.reportList.length
                                    ? () {
                                        // 인덱스 증가 로직
                                        setState(() {
                                          selectedIndex++;
                                        });
                                        _carouselController.nextItem(
                                          curve: Curves.easeInOut,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      }
                                    : null, // 마지막 항목이면 null을 할당하여 버튼 비활성화
                              )
                      ],
                    ),
                    Provider.of<MySkinPictures>(context, listen: false)
                                    .hasTodaysPhoto() ==
                                false &&
                            selectedIndex ==
                                Provider.of<MySkinPictures>(context,
                                        listen: false)
                                    .reportList
                                    .length
                        ? Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.15),
                            child: const Center(
                              child: Text(
                                '오늘의\n리포트가 없습니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            child: Column(
                              children: [
                                // Text(mySkinPictures.reportList[selectedIndex]
                                //         ['reportId']
                                //     .toString()),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(30),
                                            right: Radius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                            "# ${mySkinPictures.reportList[selectedIndex]["faceShape"]}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(30),
                                            right: Radius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                            mySkinPictures.reportList[
                                                            selectedIndex]
                                                        ['skinType'] ==
                                                    '정상'
                                                ? "# 복합성"
                                                : "# ${mySkinPictures.reportList[selectedIndex]['skinType']}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "피부나이 ${mySkinPictures.reportList[selectedIndex]['age']}세",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Container(
                                  height: 160,
                                  decoration: const BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                      // color: const Color.fromARGB(255, 241, 241, 241),
                                      ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: SfCartesianChart(
                                              plotAreaBorderWidth: 0,
                                              primaryXAxis: const CategoryAxis(
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                majorGridLines:
                                                    MajorGridLines(width: 0),
                                                axisLine: AxisLine(width: 0),
                                              ),
                                              primaryYAxis: const NumericAxis(
                                                majorGridLines:
                                                    MajorGridLines(width: 0),
                                                axisLine: AxisLine(width: 0),
                                                minorGridLines:
                                                    MinorGridLines(width: 0),
                                                isVisible: false,
                                                minimum: 0,
                                                maximum: 100,
                                              ),
                                              series: <CartesianSeries>[
                                                BarSeries(
                                                  dataSource: skinData,
                                                  width: 1,
                                                  spacing: 0.5,
                                                  isTrackVisible: true,
                                                  animationDuration: 500,
                                                  trackColor:
                                                      const Color(0xffD9D9D9),
                                                  xValueMapper: (data, _) =>
                                                      data['type'],
                                                  yValueMapper: (data, _) =>
                                                      data["value"],
                                                  pointColorMapper: (data, _) =>
                                                      data["color"],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(0)),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 241, 241, 241),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '한줄메모',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                backgroundColor:
                                                    AppColors.white,
                                                builder: (context) {
                                                  return MemoUI(
                                                    reportId: mySkinPictures
                                                        .reportList[
                                                            selectedIndex]
                                                            ['reportId']
                                                        .toString(),
                                                    memberId:
                                                        providerId.toString(),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.create_outlined,
                                              size: 30,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context
                                                .watch<DiaryProvider>()
                                                .diaryInfo['memo'] ??
                                            '메모를 추가하세요.',
                                        style: const TextStyle(
                                          fontFamily: "Mosk",
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // DiaryTag(
                                //     hashTag: context
                                //             .watch<DiaryProvider>()
                                //             .diaryInfo['tags'] ??
                                //         []),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                selectedIndex >= 0
                                    ? HealthInfo(
                                        water: Provider.of<DiaryProvider>(
                                                    context,
                                                    listen: true)
                                                .diaryInfo['water'] ??
                                            0.0,
                                        sleep: Provider.of<DiaryProvider>(
                                                    context,
                                                    listen: true)
                                                .diaryInfo['sleep'] ??
                                            0.0,
                                        reportId: Provider.of<DiaryProvider>(
                                                context,
                                                listen: true)
                                            .diaryInfo['reportId']
                                            .toString(),
                                        memberId: providerId.toString(),
                                      )
                                    : const SizedBox(
                                        height: 20,
                                      ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(),
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 50),
                      decoration: const BoxDecoration(
                        color: AppColors.tag,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          final router =
                              Provider.of<MainRouter>(context, listen: false);
                          // 타겟 탭의 인덱스를 설정합니다.
                          router.setIndex(
                              1); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                          // MainPage로 이동합니다.
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.main,
                            ModalRoute.withName('/'),
                          );
                        },
                        icon: const SizedBox(
                          width: 200,
                          child: Column(
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: 100,
                                color: Colors.black,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "피부 분석하기",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Icon(
                                  //   Icons.arrow_forward,
                                  //   size: 30,
                                  // )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black, // 기본 텍스트 색상
                            ),
                            children: <TextSpan>[
                              TextSpan(text: '한번의 '),
                              TextSpan(
                                text: '사진',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 24), // '사진' 텍스트 색상 변경
                              ),
                              TextSpan(text: ' 촬영으로\n나에게 맞는 '),
                              TextSpan(
                                text: '화장품',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                ), // '화장품' 텍스트 색상 변경
                              ),
                              TextSpan(text: ' 찾기'),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 80,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
