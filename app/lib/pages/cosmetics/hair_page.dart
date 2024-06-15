import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/components/app_textbutton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// components
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';

// style
import 'package:app/common/style/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HairPage extends StatefulWidget {
  HairPage({super.key}) {
    products = List.generate(20, (index) => '가격 $index');
  }

  late final List<String> products;

  @override
  State<HairPage> createState() => _HairPageState();

  void setState(Null Function() param0) {}
}

class _HairPageState extends State<HairPage> {
  // 화장품 선택 default 값
  String selectedCategory = '샴푸/린스';
  List<String> selectedSubcategories = ['전체'];
  List<String> selectedSkinConcerns = ['전체'];

  // 서브카테고리 선택을 위한 변수 추가
  String selectedSubcategory = '전체';

  // Method to update subcategories based on selected category
  void updateSubcategories(String category) {
    if (category == '샴푸/린스') {
      selectedSubcategories = ['전체', '샴푸', '린스/컨디셔너', '샴푸바/드라이샴푸'];
    } else if (['트리트먼트/팩'].contains(category)) {
      selectedSubcategories = ['전체', '헤어팩/마스크', '헤어 트리트먼트', '두피팩/스케일러', '노워시 트리트먼트'];
    } else if (['헤어에센스'].contains(category)) {
      selectedSubcategories = ['전체', '헤이워터', '헤어오일/헤어세럼', '헤어토닉/두피토닉'];
    } else if (['염색약/펌'].contains(category)) {
      selectedSubcategories = ['전체', '컬러염색/새치염색','헤어메이크업','탈색/파마',];
    } else if (['헤어기기/브러시'].contains(category)) {
      selectedSubcategories = ['전체', '고데기', '드라이기', '헤어브러시'];
    } else {
      selectedSubcategories = ['전체', '컬크림/컬링에센스', '왁스/젤/무스/토닉', '스프레이/픽서'];
    }
  }

  // api 변수 설정
  static List skinCareList = [];
  List displayList = List.from(skinCareList);
  late int lastId = 0;
  final int pageSize = 20;



  void getMaskPackList() async {
    final dio = Dio();
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

    print('실행1차');
    Map<String, dynamic> productListData = {
      "categoryCode": 100000,
      "lastId": lastId,
      "pageSize": pageSize,
      "searchWord": null,
    };

    print(productListData);
    try {
// API 호출
      final response = await dio.get('https://j10e106.p.ssafy.io/api/products',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ), data: productListData,);
      print('11111111111111111111');
      print(response);
// JSON 응답을 CosmeticsModel 리스트로 변환
      final List resultList = response.data['data'];
      print(resultList);
// 상태 업데이트
      setState(() {
        displayList = resultList;
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
  void initState() {
    super.initState();
    updateSubcategories(selectedCategory);
    getMaskPackList();
  }

  bool _isClicked = false;

  void _toggleButtonState() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  final categories = [
    '시트팩',
    '패드',
    '페이셜팩',
    '코팩',
    '패치',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마스크팩',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.serach);
          },
          icon: AppIcons.serach,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.favorites);
          },
          icon: AppIcons.favorites,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: MyProfileImage(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Selection
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.iconBlack.withOpacity(0.7),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories
                      .map((category) => TextButton(
                    onPressed: () {
                      _toggleButtonState();
                      setState(() {
                        selectedCategory = category;
                        updateSubcategories(
                            category); // Update subcategories based on selection
                        // Reset skin concerns on category change
                        selectedSkinConcerns = ['전체'];
                      });
                    },
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return AppColors.white;
                        },
                      ),
                      foregroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (selectedCategory == category) {
                            return AppColors.black;
                          } else {
                            return AppColors.iconBlack.withOpacity(0.6);
                          }
                        },
                      ),
                    ),
                    child: Text(category),
                  ))
                      .toList(),
                ),
              ),
            ),
          ),
          // Subcategory Selection
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.iconBlack.withOpacity(0.7),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedSubcategories
                        .map((subcategory) => TextButton(
                      onPressed: () {
                        setState(() {
                          // 현재 선택된 서브카테고리 업데이트
                          selectedSubcategory = subcategory;
                        });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return AppColors.white;
                          },
                        ),
                        foregroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // 현재 선택된 서브카테고리에 따라 색상 결정
                            if (selectedSubcategory == subcategory) {
                              return AppColors.black;
                            } else {
                              return AppColors.iconBlack
                                  .withOpacity(0.6);
                            }
                          },
                        ),
                      ),
                      child: Text(subcategory),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(child: Text('Products go here based on filters')),
            ),
          ),
        ],
      ),
    );
  }
}
