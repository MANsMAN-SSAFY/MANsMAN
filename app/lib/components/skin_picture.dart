import 'package:app/store/diary/skin_picture_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

import 'package:app/store/diary/my_skin_state.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/my_skin_state.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

List reportList = [];

class SkinPicture extends StatefulWidget {
  const SkinPicture({super.key});

  @override
  State<SkinPicture> createState() => _SkinPictureState();
}

class _SkinPictureState extends State<SkinPicture> {
  late InfiniteScrollController controller;
  int selectedIndex = 0;

  Future<void> getSkinPictures() async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        "${dotenv.env['baseUrl']}reports/recent?number=5",
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // response data를 돌면서 imgUrl만 리스트에 추가
        for (var item in data) {
          final Map<String, dynamic> data = item;
          print(data);
          reportList.add(data);
        }
      }
    } catch (e) {
      print("에러 여긴가 : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getSkinPictures();
    controller = InfiniteScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: FutureBuilder<void>(
        future: getSkinPictures(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 중일 때 표시할 UI
            return const CircularProgressIndicator(); // 예시로 CircularProgressIndicator 사용
          } else if (snapshot.hasError) {
            // 에러가 발생한 경우 표시할 UI
            return Text('에러 발생: ${snapshot.error}');
          } else {
            // 통신이 완료되고 데이터를 받아온 경우 표시할 UI
            return const Horizontal();
          }
        },
      ),
    );
  }
}

class Horizontal extends StatefulWidget {
  const Horizontal({super.key});

  @override
  State<Horizontal> createState() => _HorizontalState();
}

class _HorizontalState extends State<Horizontal> {
  // Wheater to loop through elements
  final bool _loop = false;

  // Scroll controller for carousel
  late InfiniteScrollController _controller;

  // Maintain current index of carousel
  int _selectedIndex = reportList.length - 1;

  // Width of each item
  double? _itemExtent;

  // Get screen width of viewport.
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteScrollController(initialItem: _selectedIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _itemExtent = screenWidth - 200;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (reportList.isEmpty)
            const SizedBox(height: 20)
          else
            const SizedBox(height: 20),
          if (reportList.isNotEmpty)
            SizedBox(
              height: 200,
              child: InfiniteCarousel.builder(
                itemCount: reportList.length,
                itemExtent: _itemExtent ?? 40,
                scrollBehavior: kIsWeb
                    ? ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          // Allows to swipe in web browsers
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse
                        },
                      )
                    : null,
                loop: _loop,
                controller: _controller,
                onIndexChanged: (index) {
                  if (_selectedIndex != index) {
                    setState(() {
                      _selectedIndex = index;
                      context.read<MySkinData>().setSkinData([
                        {
                          "type": 'acne',
                          "value": 20,
                          "color": const Color(0xffffabab)
                        },
                        {
                          "type": 'blackheads',
                          "value": 50,
                          "color": const Color(0xffB6D1FF)
                        },
                        {
                          "type": 'wrinkles',
                          "value": 100,
                          "color": const Color(0xffC4BECD)
                        },
                      ]);
                    });
                  }
                },
                itemBuilder: (context, itemIndex, realIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        _controller.animateToItem(realIndex);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: kElevationToShadow[2],
                          image: DecorationImage(
                            image:
                                NetworkImage(reportList[itemIndex]['imgUrl']),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          if (reportList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  label: const Text(''),
                  icon: const Icon(Icons.arrow_left),
                  onPressed: _selectedIndex == 0
                      ? null
                      : () {
                          _controller.previousItem();
                        },
                ),
                Text(
                  '촬영 날짜\n${reportList[_selectedIndex]['date']}',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton.icon(
                  label: const Text(''),
                  icon: const Icon(Icons.arrow_right),
                  onPressed: _selectedIndex == reportList.length - 1
                      ? null
                      : () {
                          _controller.nextItem();
                        },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
