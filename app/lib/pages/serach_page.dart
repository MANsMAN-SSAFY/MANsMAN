// 패키지
import 'package:app/common/component/app_normal_text_field.dart';
import 'package:app/common/component/app_text_field.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  static List main_cosmetics_list = [];

  List display_list = List.from(main_cosmetics_list);

  void updateList(String value) async {
    final dio = Dio();
    final storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    print('실행1차');
    Map<String, dynamic> productListData = {
      "categoryCode": null,
      "lastId": null,
      "pageSize": 20,
      "searchWord": value,
    };
    print(productListData);
    try {
// API 호출
      final response = await dio.get('https://j10e106.p.ssafy.io/api/products',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: productListData);
      print('11111111111111111111');
      print(response);
// JSON 응답을 CosmeticsModel 리스트로 변환
      final List resultList = response.data['data'];
      print(resultList);
// 상태 업데이트
      setState(() {
        display_list = resultList;
      });
      print(resultList);
    } on DioException catch (e) {
// DioException을 DioError로 수정
      final response = e.response;
      if (response != null) {
        print("Server responded with: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 실패1: ${response.data}')),
        );
      } else {
        print("Error occurred: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 실패2: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      print("검색 실패3: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
// 화면의 다른 부분을 탭할 때 키보드 숨기기
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: DefaultLayout(
        title: '검색',
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AppNormalTextField(
                onChange: (value) {
                  updateList(value);
                  print('이건 됨?');
                },
                autocorrect: true, // 자동 완성 기능
                enableSuggestions: true,
                autofocus: true,
                prefixIcon: AppIcons.serach,
                hint: '화장품 검색',
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: display_list.length == 0
                    ? Center(
                        child: Text(
                          "검색된 결과가 없습니다.",
                          style: AppTexts.body1,
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(CosmeticsDetailPage(
                                    id: display_list[index]['id'])
                                as Route<Object?>);
                          },
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_)=> CosmeticsDetailPage(id: display_list[index]['id'])));
                            },
                            child: Container(
                              height: 130,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14.0),
                                        child: Image.network(
                                          display_list[index]['img_url'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          '${display_list[index]['brand']}',
                                          style: AppTexts.body5.copyWith(
                                              color: AppColors.iconBlack
                                                  .withOpacity(0.6)),
                                        ),
                                        Text(display_list[index]['name'],
                                            style: AppTexts.body4.copyWith(
                                                color: AppColors.black)),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              display_list[index]['avg_rating']
                                                  .toString(),
                                              style: AppTexts.body5,
                                            ),
                                            Text(
                                              ' (${display_list[index]['cnt_rating']})',
                                              style: AppTexts.body5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: display_list[index]['favorite']
                                        ? AppIcons.full_favorites
                                        : AppIcons.favorites,
                                    onPressed: () async {
                                      final dio = Dio();
                                      final storage = FlutterSecureStorage();
                                      final accessToken = await storage.read(
                                          key: 'ACCESS_TOKEN_KEY');

                                      final productId = display_list[index]['id'];
                                      var isFavorite =
                                          display_list[index]['favorite'];
                                      if (isFavorite) {
                                        try {
                                          final response = await dio.delete(
                                            'https://j10e106.p.ssafy.io/api/products/$productId/favorites',
                                            options: Options(
                                              headers: {
                                                'Authorization':
                                                    'Bearer $accessToken'
                                              },
                                            ),
                                          );
                                          setState(() {
                            // 즐겨찾기 상태 토글
                                            display_list[index]['favorite'] =
                                                !isFavorite;
                                          });
                                          print("즐겨찾기 취소 성공: ${response.data}");
                                        } on DioException catch (e) {
                            // DioException을 DioError로 수정
                                          print('이유1');
                                          final response = e.response;
                                          if (response != null) {
                                            print(
                                                "Server responded with: ${response.data}");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '즐겨찾기 취소 실패: ${response.data}')),
                                            );
                                          } else {
                                            print('이유2');
                                            print("Error occurred: ${e.message}");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '즐겨찾기 취소 실패: ${e.message}')),
                                            );
                                          }
                                        } catch (e) {
                                          print('이유3');
                            // 이 부분의 위치를 조정
                                          print("즐겨찾기 취소 실패: $e");
                                        }
                                      } else {
                                        try {
                                          print('등록');
                                          print(productId);
                                          final response = await dio.post(
                                            'https://j10e106.p.ssafy.io/api/products/$productId/favorites',
                                            options: Options(
                                              headers: {
                                                'Authorization':
                                                    'Bearer $accessToken'
                                              },
                                            ),
                                          );
                                          print(22222222222222222);
                                          print(productId);
                                          setState(() {
                            // 즐겨찾기 상태 토글
                                            display_list[index]['favorite'] =
                                                !isFavorite;
                                          });
                                          print(response);
                                          print("즐겨찾기 등록 성공: ${response.data}");
                                        } on DioException catch (e) {
                            // DioException을 DioError로 수정
                                          final response = e.response;
                                          if (response != null) {
                                            print(
                                                "Server responded with: ${response.data}");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '즐겨찾기 등록 실패: ${response.data}')),
                                            );
                                          } else {
                                            print("Error occurred: ${e.message}");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '즐겨찾기 등록 실패: ${e.message}')),
                                            );
                                          }
                                        } catch (e) {
                            // 이 부분의 위치를 조정
                                          print("즐겨찾기 등록 실패: $e");
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: display_list.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
