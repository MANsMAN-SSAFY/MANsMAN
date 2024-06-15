import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/components/app_textbutton.dart';
import 'package:app/components/cosmetics/recommend_product_card.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
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

import 'cosmetics_detail_page.dart';

class MaskPackPage extends StatefulWidget {
  MaskPackPage({super.key}) {
    products = List.generate(20, (index) => '가격 $index');
  }

  late final List<String> products;

  @override
  State<MaskPackPage> createState() => _MaskPackPageState();

  void setState(Null Function() param0) {}
}

class _MaskPackPageState extends State<MaskPackPage> {
  // 무한 스크롤을 위한 변수
  bool isLoading = false;
  bool hasMore = true;
  int lastId = 0;
  // 화장품 선택 default 값
  String selectedCategory = '시트팩';
  List<String> selectedSubcategories = ['전체'];
  List<String> selectedSkinConcerns = ['전체'];

  // 서브카테고리 선택을 위한 변수 추가
  String selectedSubcategory = '전체';

  // Method to update subcategories based on selected category
  void updateSubcategories(String category) {
    if (category == '시트팩') {
      selectedSubcategories = ['전체', '시트팩'];
    } else if (['패드'].contains(category)) {
      selectedSubcategories = ['전체', '패드'];
    } else if (['페이셜팩'].contains(category)) {
      selectedSubcategories = ['전체', '워시오프팩', '슬링핑팩', '모델링팩/필오프팩'];
    } else if (['코팩'].contains(category)) {
      selectedSubcategories = ['전체', '코팩'];
    } else {
      selectedSubcategories = ['전체', '패치'];
    }
  }


  // api 변수 설정
  static List maskPackList = [];
  List displayList = List.from(maskPackList);
  final int pageSize = 50;

  final Map<String, int> categoryCodes = {
    '시트팩' : 300100,
    '패드' : 300200,
    '페이셜팩' : 300300,
    '코팩' : 300400,
    '패치' : 300500,
  };


  Future<List<dynamic>> getMaskPackList() async {
    final List<dynamic> resultList = [];

    // 선택된 카테고리와 서브카테고리에 따라 categoryCode 결정
    int categoryCode;
    if (selectedCategory == '페이셜팩' && selectedSubcategory == '전체') {
      categoryCode = 30030000;
    } else if (selectedCategory == '페이셜팩' && selectedSubcategory == '워시오프') {
      categoryCode = 30030001;
    } else if (selectedCategory == '페이셜팩' && selectedSubcategory == '슬링핑팩') {
      categoryCode = 30030002;
    } else if (selectedCategory == '페이셜팩' && selectedSubcategory == '모델링팩/필오프팩') {
      categoryCode = 30030003;
    } else {
      // 다른 선택에 따른 categoryCode 설정
      // 예를 들어, 다른 카테고리와 서브카테고리 조합에 따라 다른 코드를 할당할 수 있습니다.
      categoryCode = categoryCodes[selectedCategory] ?? 30010000; // 기본값 혹은 다른 조건에 따른 값
      print('스킨케어세트는 미쳤나?');
    }

    final dio = Dio();
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    // final categoryCode = categoryCodes[selectedCategory] ?? 300100;
    print('실행1차');
    Map<String, dynamic> productListData = {
      "categoryCode": categoryCode,
      "pageSize": pageSize,
    };

    print(productListData);
    try {
// API 호출
      final response = await dio.get('https://j10e106.p.ssafy.io/api/products',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: productListData,);
      print('11111111111111111111');
      print(response);
// JSON 응답을 CosmeticsModel 리스트로 변환
      final List<dynamic> data = response.data['data'];
      return data; // 성공적으로 데이터를 받아왔을 때 반환
    } on DioException catch (e) {
// DioException을 DioError로 수정
      final response = e.response;
      if (response != null) {
        print("Server responded with: ${response.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 실패1: ${response.data}')),
        );
        return resultList;
      } else {
        print("Error occurred: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 실패2: ${e.message}'),
          ),
        );
        return resultList;
      }
    } catch (e) {
      print("검색 실패3: $e");
      return resultList;
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
          // Products Display Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FutureBuilder<List>(
                future: getMaskPackList(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      // parsed item
                      final pItem = CosmeticsModel.fromJson(json: item);
                      return GestureDetector(
                        onTap: () {
                          print('11111111111');
                          print(pItem);
                          print(pItem.id);
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_)=> CosmeticsDetailPage(id: pItem.id))); //id: pItem.id
                        },
                        child: CosmeticsCard.fromModel(
                          model: pItem,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
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
    );
  }
}
