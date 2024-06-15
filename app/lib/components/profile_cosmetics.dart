import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/Modal/plus_cosmetics.dart';
import 'package:app/components/app_textbutton.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/model/cosmetics/review_model.dart';
import 'package:app/pages/cosmetics/review_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileCosmetics extends StatefulWidget {
  const ProfileCosmetics({super.key});

  @override
  State<ProfileCosmetics> createState() => _ProfileCosmeticsState();
}

class _ProfileCosmeticsState extends State<ProfileCosmetics>
    with SingleTickerProviderStateMixin {
  // 화장품 안에서 탭
  TabController? _tabController2;
  Future<void>? _loadProductsFuture;

  // 화장품 담을 리스트
  List<dynamic> myProductLists = []; // 사용 중인 상품 리스트
  List<dynamic> usedProductLists = []; // 사용 중인 상품 리스트

  @override
  void initState() {
    super.initState();
    _tabController2 = TabController(length: 2, vsync: this);
    // _tabController2?.addListener(() {
    //   if (_tabController2!.indexIsChanging) {
    //   }
    // });
    _loadProductsFuture = getMyProducts();
  }

  @override
  void dispose() {
    _tabController2?.dispose();
    super.dispose();
  }

  Future<void> getMyProducts() async {
    final dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

    try {
      final response =
          await dio.get('https://j10e106.p.ssafy.io/api/members/my-products',
              options: Options(
                headers: {'Authorization': 'Bearer $accessToken'},
              ));

      return processResponse(response.data);
    } on DioException catch (e) {
      // DioException을 DioError로 수정
      final response = e.response;
      if (response != null) {
        print("Server responded with: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보 조회 실패1: ${response.data}')),
        );
      } else {
        print("Error occurred: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('정보 조회 실패2: ${e.message}'),
          ),
        );
      }

      print("dddd");
    } catch (e) {
      print("정보 조회 실패3: $e");
    }
  }

  void processResponse(List<dynamic> data) {
    setState(() {
      myProductLists.clear(); // 기존 목록을 지우고 새로운 데이터로 업데이트
      usedProductLists.clear();
      for (var result in data) {
        if (!result['active']) {
          myProductLists.add(result);
        } else {
          usedProductLists.add(result);
        }
      }
    });
  }

  Widget _buildRegistrationSection() => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewPage()),
          ).then((result) {
            if (result != null) {
              setState(() {
                _loadProductsFuture = getMyProducts();
                // myProductLists 업데이트 후 필요한 경우 UI 업데이트 등 추가 작업 수행
              });
            }
          });
        },
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.input_border),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_rounded),
              SizedBox(height: 4.0),
              Text('구매한 상품을 등록해주세요', style: AppTexts.body3),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController2,
            indicatorColor: AppColors.blue, // Color of the indicator line
            labelColor: AppColors.blue, // Color of the text for selected tabs
            unselectedLabelColor: AppColors.black,
            tabs: const [
              Tab(
                text: '사용 중인 상품',
              ),
              Tab(
                text: '사용한 상품',
              )
            ]),
        const SizedBox(height: 12),
        Expanded(
          child: TabBarView(
            controller: _tabController2,
            children: [
              FutureBuilder(
                  future: _loadProductsFuture, // 비동기 함수 호출
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator()); // 로딩 중 표시
                    } else if (snapshot.hasError) {
                      return const Text('오류가 발생했습니다.'); // 오류 표시
                    } else {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: myProductLists.isEmpty
                                  ? 1
                                  : myProductLists.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _buildRegistrationSection();
                                } else if (index <= myProductLists.length) {
                                  // 나머지 인덱스에서는 사용자의 상품 목록을 표시
                                  final itemIndex =
                                      index - 1; // 실제 배열 인덱스를 얻기 위해 1을 뺌
                                  return InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      height: 130,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: AppColors.iconBlack
                                            .withOpacity(0.4),
                                        width: 1.0,
                                      ))),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                                child: Image.network(
                                                  myProductLists[itemIndex]
                                                      ['imgUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  '${myProductLists[itemIndex]['brand']}',
                                                  style:
                                                      AppTexts.body5.copyWith(
                                                    color: AppColors.iconBlack
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 1.0,
                                                ),
                                                Text(
                                                  myProductLists[itemIndex]
                                                          ['name']
                                                      .substring(10),
                                                  style: AppTexts.body4
                                                      .copyWith(
                                                          color:
                                                              AppColors.black),
                                                ),
                                                const SizedBox(
                                                  height: 6.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      width: 60,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .iconBlack
                                                                  .withOpacity(
                                                                      0.4),
                                                          foregroundColor:
                                                              AppColors.white,
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        onPressed: () async {
                                                          final dio = Dio();
                                                          const storage =
                                                              FlutterSecureStorage();
                                                          final accessToken =
                                                              await storage.read(
                                                                  key:
                                                                      'ACCESS_TOKEN_KEY');
                                                          final myProductId =
                                                              myProductLists[
                                                                      itemIndex]
                                                                  ['id'];

                                                          try {
                                                            final response =
                                                                await dio
                                                                    .delete(
                                                              'https://j10e106.p.ssafy.io/api/members/$myProductId/my-products',
                                                              options: Options(
                                                                headers: {
                                                                  'Authorization':
                                                                      'Bearer $accessToken'
                                                                },
                                                              ),
                                                            );
                                                            setState(() {
                                                              myProductLists
                                                                  .removeAt(
                                                                      itemIndex);
                                                            });
                                                            print(
                                                                "제품 삭제 성공: ${response.data}");
                                                          } on DioException catch (e) {
                                                            final response =
                                                                e.response;
                                                            if (response !=
                                                                null) {
                                                              print(
                                                                  "Server responded with: ${response.data}");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        '제품 삭제 실패: ${response.data}')),
                                                              );
                                                            } else {
                                                              print(
                                                                  "Error occurred: ${e.message}");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        '제품 삭제 실패: ${e.message}')),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            print(
                                                                "제품 삭제  실패: $e");
                                                          }
                                                        },
                                                        child: const Text('삭제'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 60,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .blue
                                                                  .withOpacity(
                                                                      0.5),
                                                          foregroundColor:
                                                              AppColors.white,
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        onPressed: () {
                                                          // 여기에서 myProductLists[itemIndex]의 정보를 다음 페이지로 전달합니다.
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ReviewPage(
                                                                productData:
                                                                    myProductLists[
                                                                        itemIndex],
                                                              ),
                                                            ),
                                                          ).then((_) =>
                                                              _loadProductsFuture =
                                                                  getMyProducts());
                                                        },
                                                        child: const Text('수정'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 60,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors.blue,
                                                          foregroundColor:
                                                              AppColors.white,
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        onPressed: () async {
                                                          final product =
                                                              myProductLists.firstWhere(
                                                                  (p) =>
                                                                      p['id'] ==
                                                                      myProductLists[
                                                                              itemIndex]
                                                                          [
                                                                          'id'],
                                                                  orElse: () =>
                                                                      null);
                                                          if (product != null) {
                                                            setState(() {
                                                              myProductLists
                                                                  .remove(
                                                                      product);
                                                              usedProductLists
                                                                  .add(product);
                                                            });
                                                          }

                                                          final dio = Dio();
                                                          const storage =
                                                              FlutterSecureStorage();
                                                          final accessToken =
                                                              await storage.read(
                                                                  key:
                                                                      'ACCESS_TOKEN_KEY');

                                                          try {
                                                            final myProductId =
                                                                product['id'];
                                                            final response =
                                                                await dio.patch(
                                                              'https://j10e106.p.ssafy.io/api/members/my-products/$myProductId/toggle-active',
                                                              options: Options(
                                                                headers: {
                                                                  'Authorization':
                                                                      'Bearer $accessToken'
                                                                },
                                                              ),
                                                            );
                                                            print(
                                                                "myProductLists : $myProductLists");
                                                            print(
                                                                "userProductLists : $usedProductLists");
                                                            print(
                                                                "제품 이동 성공: ${response.data}");
                                                          } on DioException catch (e) {
                                                            final response =
                                                                e.response;
                                                            if (response !=
                                                                null) {
                                                              print(
                                                                  "Server responded with: ${response.data}");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        '제품 이동 실패: ${response.data}')),
                                                              );
                                                            } else {
                                                              print(
                                                                  "Error occurred: ${e.message}");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        '제품 이동 실패: ${e.message}')),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            print(
                                                                "제품 이동 실패: $e");
                                                          }
                                                        },
                                                        child: const Text('다씀'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  }),
              FutureBuilder(
                future: _loadProductsFuture, // 비동기 함수 호출
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()); // 로딩 중 표시
                  } else if (snapshot.hasError) {
                    return const Text('오류가 발생했습니다.'); // 오류 표시
                  } else {
                    // 사용한 상품
                    return usedProductLists.isEmpty
                        ? const Center(
                            child: Text('다 사용한 제품이 없어요'),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: usedProductLists.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: AppColors.iconBlack.withOpacity(0.4),
                                    width: 1.0,
                                  ))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                            child: Image.network(
                                              usedProductLists[index]['imgUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              '${usedProductLists[index]['brand']}',
                                              style: AppTexts.body5.copyWith(
                                                color: AppColors.iconBlack
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1.0,
                                            ),
                                            Text(
                                              usedProductLists[index]['name']
                                                  .substring(10),
                                              style: AppTexts.body4.copyWith(
                                                  color: AppColors.black),
                                            ),
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .iconBlack
                                                          .withOpacity(0.4),
                                                      foregroundColor:
                                                          AppColors.white,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    onPressed: () async {
                                                      final dio = Dio();
                                                      const storage =
                                                          FlutterSecureStorage();
                                                      final accessToken =
                                                          await storage.read(
                                                              key:
                                                                  'ACCESS_TOKEN_KEY');
                                                      final myProductId =
                                                          usedProductLists[
                                                              index]['id'];
                                                      print(myProductId);

                                                      try {
                                                        final response =
                                                            await dio.delete(
                                                          'https://j10e106.p.ssafy.io/api/members/$myProductId/my-products',
                                                          options: Options(
                                                            headers: {
                                                              'Authorization':
                                                                  'Bearer $accessToken'
                                                            },
                                                          ),
                                                        );
                                                        setState(() {
                                                          usedProductLists
                                                              .removeAt(index);
                                                        });
                                                        print(
                                                            "제품 삭제 성공: ${response.data}");
                                                      } on DioException catch (e) {
                                                        final response =
                                                            e.response;
                                                        if (response != null) {
                                                          print(
                                                              "Server responded with: ${response.data}");
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    '제품 삭제 실패: ${response.data}')),
                                                          );
                                                        } else {
                                                          print(
                                                              "Error occurred: ${e.message}");
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    '제품 삭제 실패: ${e.message}')),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        print("제품 삭제  실패: $e");
                                                      }
                                                    },
                                                    child: const Text('삭제'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .blue
                                                          .withOpacity(0.5),
                                                      foregroundColor:
                                                          AppColors.white,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    onPressed: () {
                                                      // 여기에서 usedProductLists[itemIndex]의 정보를 다음 페이지로 전달합니다.
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReviewPage(
                                                            productData:
                                                                usedProductLists[
                                                                    index],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('수정'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ); // 데이터 로딩 후 UI 구성
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
