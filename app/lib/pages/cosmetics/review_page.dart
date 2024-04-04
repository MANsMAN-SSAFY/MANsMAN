import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/component/app_normal_text_field.dart';
import 'package:app/common/component/stepperTouch.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/pages/profile/others_profile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReviewPage extends StatefulWidget {
  final dynamic productData;
  ReviewPage({super.key, this.productData});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<String> displayList = [];

  final TextEditingController reviewController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  double review_rating = 0.0;
  double rating = 0.0;
  late int cnt;
  int? review_productId;
  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      searchController.text = widget.productData['name'];
      cnt = widget.productData['cnt'];
      review_rating = widget.productData['rating'];
      reviewController.text = widget.productData['review'];
      // 검색 창을 수정할 수 없게 만듦
      searchController.removeListener(_onSearchChanged);
    } else {
      searchController.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    // 사용자 입력이 변경될 때마다 updateList 호출
    updateCosmeticsList(searchController.text);
  }

  // 이 함수는 API 호출을 비동기적으로 처리하고 검색 결과를 문자열 리스트로 반환합니다.
  Future<List<CosmeticsModel>> updateCosmeticsList(String searchQuery) async {
    final dio = Dio();
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

    final String apiEndpoint = 'https://j10e106.p.ssafy.io/api/products'; // 실제 API 엔드포인트로 변경
    final Map<String, dynamic> productListData = {
      "categoryCode": null,
      "lastId": null,
      "pageSize": 20,
      "searchWord": searchQuery,
    };

    try {
      final response = await dio.get(
        apiEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        queryParameters: productListData,
      );
      print(response);
      final List<CosmeticsModel> cosmeticsList = (response.data['data'] as List)
          .map((item) => CosmeticsModel.fromJson(json: item))
          .toList();
      return cosmeticsList;
    } on DioException catch (e) {
      print("Error occurred while fetching search results: ${e.message}");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final _value = 0;
    return DefaultLayout(
      title: '상품 등록 • 리뷰 쓰기',
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: bottomPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '구매한 또는 사용한 제품을 등록해주세요',
                  style: AppTexts.body1,
                ),
                SizedBox(
                  height: 16,
                ),
                Autocomplete<CosmeticsModel>(
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextFormField(
                      controller: widget.productData != null ? searchController : textEditingController,
                      readOnly: widget.productData != null,
                      focusNode: focusNode,
                      autocorrect: true, // 자동 완성 기능
                      enableSuggestions: true,
                      autofocus: false,
                      style: TextStyle(color: AppColors.blue), // Custom text style
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.blue),
                        filled: true,
                        fillColor: AppColors.tag.withOpacity(0.3),
                        hintText: widget.productData != null ? widget.productData['name'] : '화장품 검색',
                        hintStyle: TextStyle(color: AppColors.iconBlack.withOpacity(0.5)), // Custom hint style
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: AppColors.input_border,
                            width: 1.0,
                          ),
                        ),
                        prefixIcon: AppIcons.serach,
                      ),
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') {
                    return const Iterable<CosmeticsModel>.empty();
                  }
                  // Get the search results from the API
                  return await updateCosmeticsList(textEditingValue.text);
                },
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<CosmeticsModel> onSelected, Iterable<CosmeticsModel> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: options.map((CosmeticsModel option) => ListTile(
                              leading: SizedBox(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: Image.network(
                                    option.img_url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                option.brand, style: AppTexts.body5.copyWith(
                                  color: AppColors.iconBlack.withOpacity(0.6)
                                ),
                              ),
                              subtitle: Text(
                                option.name, style: AppTexts.body4.copyWith(
                                color: AppColors.black)
                              ),
                              onTap: () {
                                onSelected(option);
                                print(option);
                                print(option.img_url);
                              },
                            )).toList(),
                            shrinkWrap: true,
                          ),
                        ),
                      ),
                    );
                  },
                  displayStringForOption: (CosmeticsModel option) => option.name,
                  onSelected: (CosmeticsModel selection) {
                    review_productId = selection.id;
                    print('Selected cosmetic item id: ${selection.id}');
                  },
                ),
                SizedBox(height: 36.0),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.iconBlack.withOpacity(0.3),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '구매한 개수',
                      style: AppTexts.body1,
                    ),
                    Container(
                      height: 60,
                      width: 100,
                      padding: const EdgeInsets.all(8.0),
                      child: StepperTouch(
                        initialValue: widget.productData != null ? widget.productData['cnt'] : 0,
                        direction: Axis.horizontal,
                        withSpring: false,
                        onChanged: (int value) {
                          setState(() {
                            cnt = value;
                            print('여기');
                            print(cnt);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.iconBlack.withOpacity(0.3),
                ),
                SizedBox(height: 16),
                Text(
                  '사용 후, 평점을 선택해주세요',
                  style: AppTexts.body1,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    initialRating: widget.productData != null ? widget.productData['rating'] : 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (r) {
                      setState(() {
                        rating = r.toDouble();
                        review_rating = rating;
                      }); // 값 넣어줘야함.
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.iconBlack.withOpacity(0.3),
                ),
                SizedBox(height: 16),
                Text(
                  '사용 후, 리뷰를 작성해주세요',
                  style: AppTexts.body1,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: reviewController,
                  maxLines: 5, // 이 부분이 리뷰 입력을 위한 멀티라인 설정
                  decoration: InputDecoration(
                    hintText: widget.productData != null ? widget.productData['review'] : '사용 후, 리뷰를 작성해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(
                        color: AppColors.input_border,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.tag.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AppElevatedButton(
                    onPressed: () async {
                      final dio = Dio();
                      final storage = FlutterSecureStorage();
                      final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

                      Map<String, dynamic> myProductData = {
                        "productId": review_productId,
                        "cnt": cnt,
                        "rating": review_rating,
                        "review": reviewController.text
                      };
                      
                      try {
                        Response response;
                        if (widget.productData != null) {
                          // 수정 모드: 기존 항목 수정
                          myProductData['id'] = widget.productData['id']; // 기존 항목의 ID
                          response = await dio.patch(
                            'https://j10e106.p.ssafy.io/api/members/my-products',
                            options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
                            data: myProductData
                          );
                        } else {
                          // 등록 모드: 새 항목 추가
                          myProductData['productId'] = review_productId;
                          response = await dio.post(
                            'https://j10e106.p.ssafy.io/api/members/my-products',
                            options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
                            data: myProductData
                          );
                        }

                        print("요청 성공: ${response.data}");
                        Navigator.pop(context, myProductData); // 성공 시 데이터를 반환하며 화면 종료
                      } on DioException catch (e) {
                        print("요청 실패: ${e.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('오류 발생: ${e.message}'))
                        );
                      }
                    },
                    name: widget.productData != null ? '수정' : '등록',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
