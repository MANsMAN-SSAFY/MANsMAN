import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/components/app_textbutton.dart';
import 'package:app/components/cosmetics/recommend_product_card.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
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

class SkinPage extends StatefulWidget {
  SkinPage({super.key}) {
    products = List.generate(20, (index) => '가격 $index');
  }

  late final List<String> products;

  @override
  State<SkinPage> createState() => _SkinPageState();

  void setState(Null Function() param0) {}
}

class _SkinPageState extends State<SkinPage> {
  // 즐겨찾기 상태를 관리하는 Map 추가
  Map<int, bool> favorites = {};

  // 즐겨찾기 상태를 업데이트하는 메서드
  void updateFavorite(int productId, bool isFavorite) {
    setState(() {
      favorites[productId] = isFavorite;
    });
  }

  // 무한 스크롤을 위한 변수
  bool isLoading = false;
  bool hasMore = true;
  int lastId = 0;
  // 화장품 선택 default 값
  String selectedCategory = '스킨/토너';
  List<String> selectedSubcategories = ['전체'];
  List<String> selectedSkinConcerns = ['전체'];

  // 서브카테고리 선택을 위한 변수 추가
  String selectedSubcategory = '전체';

  // Method to update subcategories based on selected category
  void updateSubcategories(String category) {
    if (category == '스킨/토너') {
      selectedSubcategories = ['전체', '스킨/토너'];
    } else if (['에센스/세럼/앰플'].contains(category)) {
      selectedSubcategories = ['전체', '에센스/세럼/앰플'];
    } else if (['크림'].contains(category)) {
      selectedSubcategories = ['전체', '크림', '아이크림'];
    } else if (['로션'].contains(category)) {
      selectedSubcategories = ['전체', '로션', '올인원'];
    } else if (['미스트/오일'].contains(category)) {
      selectedSubcategories = ['전체', '미스트/픽서', '페이스오일'];
    } else {
      selectedSubcategories = ['전체', '스킨케어세트'];
    }
  }

  String skinType = '전체'; // 현재 선택된 피부 타입
  String concern = '전체'; // 현재 선택된 효능
  String? q_skinType; // API 요청을 위한 피부 타입 변수
  String? q_concern; // API 요청을 위한 효능 변수

  void updateSkinType(String selected) {
    setState(() {
      if (selected == '전체') {
        skinType = '전체';
        q_skinType = null; // '전체'가 선택되면 API 요청 변수도 null로 설정
      } else {
        // 선택된 항목에 따라 skinType 업데이트
        skinType = skinType == selected ? '전체' : selected;

        // API 요청에 사용될 q_skinType 값을 설정
        if (skinType == '건성') {
          q_skinType = 'D'; // '건성'은 예시에서 API 매개변수로 특별한 값을 요구하지 않음
        } else if (skinType == '지성') {
          q_skinType = 'O'; // '지성'에 대응하는 API 매개변수 값
        } else if (skinType == '복합성') {
          q_skinType = 'C'; // '복합성'에 대응하는 API 매개변수 값
        } else {
          q_skinType = null; // 그 외 경우는 모든 피부 타입을 포함하므로 null
        }
      }
    });
  }

  void updateConcern(String selected) {
    setState(() {
      if (selected == '전체') {
        concern = '전체';
        q_concern = null; // '전체'가 선택되면 API 요청 변수도 null로 설정
      } else {
        // 선택된 항목에 따라 concern 업데이트
        concern = concern == selected ? '전체' : selected;

        // API 요청에 사용될 q_concern 값을 설정
        if (concern == '보습') {
          q_concern = 'M'; // '보습'에 대응하는 API 매개변수 값
        } else if (concern == '진정') {
          q_concern = 'S'; // '진정'에 대응하는 API 매개변수 값
        } else if (concern == '주름/미백') {
          q_concern = 'W'; // '주름/미백'에 대응하는 API 매개변수 값
        } else {
          q_concern = null; // 그 외 경우는 모든 효능을 포함하므로 null
        }
      }
    });
  }

  // api 변수 설정
  static List skinCareList = [];
  List displayList = List.from(skinCareList);
  final int pageSize = 300;

  final Map<String, int> categoryCodes = {
    '스킨/토너': 10010000,
    '에센스/세럼/앰플': 10020000,
    '크림': 10030000,
    '로션': 10040000,
    '미스트/오일': 10050000,
    '스킨케어세트': 10060001,
  };

  final Map<String, int> selectedCategoryCodes = {
    '스킨/토너': 10010001,
    '에센스/세럼/앰플': 10020001,
    '크림': 10030001,
    '아이크림': 10030002,
    '로션': 10040001,
    '올인원': 10040002,
    '미스트/픽서': 10050001,
    '페이스오일': 10050002,
    '스킨케어세트': 10060001,
  };

  Future<List<dynamic>> getskinCareList() async {
    final List<dynamic> resultList = [];

    final dio = Dio();
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

    // 선택된 카테고리와 서브카테고리에 따라 categoryCode 결정
    int categoryCode;
    if (selectedCategory == '스킨/토너' || selectedSubcategory == '스킨/토너') {
      categoryCode = 10010001; // 아이크림의 코드
    } else if (selectedCategory == '에센스/세럼/앰플' ||
        selectedSubcategory == '에센스/세럼/앰플') {
      categoryCode = 10020001;
    } else if (selectedCategory == '크림' && selectedSubcategory == '크림') {
      categoryCode = 10030001;
    } else if (selectedCategory == '크림' && selectedSubcategory == '아이크림') {
      categoryCode = 10030002;
    } else if (selectedCategory == '로션' && selectedSubcategory == '로션') {
      categoryCode = 10040001;
    } else if (selectedCategory == '로션' && selectedSubcategory == '올인원') {
      categoryCode = 10040002;
    } else if (selectedCategory == '미스트/오일' &&
        selectedSubcategory == '미스트/픽서') {
      categoryCode = 10050001;
    } else if (selectedCategory == '미스트/오일' && selectedSubcategory == '페이스오일') {
      categoryCode = 10050002;
    } else {
      // 다른 선택에 따른 categoryCode 설정
      // 예를 들어, 다른 카테고리와 서브카테고리 조합에 따라 다른 코드를 할당할 수 있습니다.
      categoryCode = categoryCodes[selectedCategory] ?? 100100; // 기본값 혹은 다른 조건에 따른 값
      print('스킨케어세트는 미쳤나?');
    }

    print('실행1차');
    Map<String, dynamic> productListData = {
      "categoryCode": categoryCode,
      "skinType": q_skinType,
      "concern": q_concern,
      "pageSize": pageSize,
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
    getskinCareList();
  }

  bool _isClicked = false;

  void _toggleButtonState() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  final categories = [
    '스킨/토너',
    '에센스/세럼/앰플',
    '크림',
    '로션',
    '미스트/오일',
    '스킨케어세트',
  ];
  final skinConcerns = ['전체', '건성', '복합성', '지성', '보습', '진정', '주름/미백'];

  @override
  Widget build(BuildContext context) {
    List<String> skinTypes = ['전체', '건성', '지성', '복합성'];
    List<String> concernsOptions = ['전체', '보습', '진정', '주름/미백'];
    return DefaultLayout(
      title: '스킨케어',
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
          // Skin Concerns/Types
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: skinTypes
                            .map((type) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(type),
                                    selected: skinType == type,
                                    onSelected: (selected) =>
                                        updateSkinType(type),
                                    backgroundColor: AppColors.white,
                                    selectedColor: AppColors.blue,
                                    labelStyle: TextStyle(
                                        color: skinType == type
                                            ? AppColors.white
                                            : AppColors.black),
                                    checkmarkColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide.none,
                                      // side: BorderSide(
                                      //   color: selectedSkinConcerns
                                      //           .contains(concern)
                                      //       ? AppColors.white
                                      //       : AppColors.,
                                      //   width: 1,
                                      // ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: concernsOptions
                            .map((option) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(option),
                                    selected: concern == option,
                                    onSelected: (selected) =>
                                        updateConcern(option),
                                    backgroundColor: AppColors.white,
                                    selectedColor: AppColors.blue,
                                    labelStyle: TextStyle(
                                        color: concern == option
                                            ? AppColors.white
                                            : AppColors.black),
                                    checkmarkColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide.none,
                                      // BorderSide(
                                      //   color: selectedSkinConcerns
                                      //           .contains(concern)
                                      //       ? AppColors.white
                                      //       : AppColors.blue,
                                      //   width: 1,
                                      // ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Products Display Area
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FutureBuilder<List>(
                future: getskinCareList(),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => CosmeticsDetailPage(
                                  id: pItem.id))); //id: pItem.id
                        },
                        child: CosmeticsCard.fromModel(
                          model: pItem,
                          key: ValueKey(pItem.id),
                          favorite: favorites[pItem.id] ?? false, // favorites Map에서 즐겨찾기 상태 가져오기
                          onFavoriteToggle: updateFavorite, // 즐겨찾기 상태 업데이트 콜백
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
