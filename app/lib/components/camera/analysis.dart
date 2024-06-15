import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:app/store/router.dart';

class ReportAlert extends StatelessWidget {
  final Map<String, dynamic> displayResult;

  const ReportAlert({super.key, required this.displayResult});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> translatedLabels = {
      'acne': '민감성',
      'wrinkle': '주름',
      // 'blackhead': '블랙헤드',
    };

    List<Map<String, dynamic>> skinData = [
      {
        "type": translatedLabels['acne'],
        "value": displayResult['acne'],
        "color": const Color(0xffffabab)
      },
      // {
      //   "type": translatedLabels['blackhead'],
      //   "value": displayResult['blackhead'],
      //   "color": const Color(0xffB6D1FF)
      // },
      {
        "type": translatedLabels['wrinkle'],
        "value": displayResult['wrinkle'],
        "color": const Color(0xffC4BECD)
      },
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        surfaceTintColor: AppColors.white,
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            "분석 결과",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          children: [
            Text(
              "${displayResult["date"]}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                displayResult["imgUrl"],
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    child: Text("# ${displayResult["faceShape"]}",
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
                    child: Text("# ${displayResult['skinType']}",
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "피부나이 ${displayResult['age']}세",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 150,
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          primaryXAxis: const CategoryAxis(
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            majorGridLines: MajorGridLines(width: 0),
                            axisLine: AxisLine(width: 0),
                          ),
                          primaryYAxis: const NumericAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            axisLine: AxisLine(width: 0),
                            minorGridLines: MinorGridLines(width: 0),
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
                              trackColor: const Color(0xffD9D9D9),
                              xValueMapper: (data, _) => data['type'],
                              yValueMapper: (data, _) => data["value"],
                              pointColorMapper: (data, _) => data["color"],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0)),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        actions: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      final router =
                          Provider.of<MainRouter>(context, listen: false);
                      // 타겟 탭의 인덱스를 설정합니다.
                      router.setIndex(0); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                      // MainPage로 이동합니다.
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.main,
                        ModalRoute.withName('/'),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    child: const Column(
                      children: [
                        AppIcons.home,
                        Text('홈'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // MainRouter의 인스턴스를 가져옵니다.
                      final router =
                          Provider.of<MainRouter>(context, listen: false);
                      // 타겟 탭의 인덱스를 설정합니다.
                      router.setIndex(2); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                      // MainPage로 이동합니다.
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.main,
                        ModalRoute.withName('/'),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    child: const Column(
                      children: [
                        AppIcons.cosmetics,
                        Text('추천 화장품'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  final router =
                      Provider.of<MainRouter>(context, listen: false);
                  // 타겟 탭의 인덱스를 설정합니다.
                  router.setIndex(1); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                  // MainPage로 이동합니다.
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                    ModalRoute.withName('/'),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text("닫기"),
              )
            ],
          )
        ],
      ),
    );
  }
}
