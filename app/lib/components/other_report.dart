import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OtherReport extends StatefulWidget {
  final String memberId;
  const OtherReport({
    super.key,
    required this.memberId,
  });

  @override
  State<OtherReport> createState() => _OtherReportState();
}

Future<Map<String, dynamic>> getOtherInfo(String memberId) async {
  final dio = Dio();
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");
  print(memberId);
  try {
    final response = await dio.get(
      '${dotenv.env['baseUrl']}members/$memberId/profiles',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );

    final report = response.data["report"];
    print("리포트 : $report");
    return report;
  } catch (e) {
    print(e);
    rethrow;
  }
}

class _OtherReportState extends State<OtherReport> {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> translatedLabels = {
      'acne': '민감성',
      'wrinkle': '주름',
    };

    final Map<String, String> translatedTypes = {
      "NORMAL": "# 복합성",
      "OILY": "# 지성",
      "DRY": "# 건성"
    };

    return FutureBuilder<Map<String, dynamic>>(
      future: getOtherInfo(widget.memberId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '데이터를 불러오는 중 오류가 발생했습니다: ${snapshot.error}',
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('아직 리포트가 없습니다.'),
          );
        }

        // 여기에서 캐스팅이 필요 없음을 가정하고 직접 접근
        final report = snapshot.data; // '!' 사용하여 null이 아님을 보장
        List<Map<String, dynamic>> skinData = [
          {
            "type": translatedLabels['acne'],
            "value": report!['acne'],
            "color": const Color(0xffffabab)
          },
          {
            "type": translatedLabels['wrinkle'],
            "value": report['wrinkle'],
            "color": const Color(0xffC4BECD)
          },
        ];

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(40),
                        right: Radius.circular(40),
                      ),
                    ),
                    child: Text("# ${report['faceShape']}",
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(40),
                        right: Radius.circular(40),
                      ),
                    ),
                    child: Text("${translatedTypes[report['skinType']]}",
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "피부 나이 : ${report['age'].toString()}세",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      // dataLabelSettings: const DataLabelSettings(
                      //     isVisible: true, // 데이터 라벨을 보이게 설정
                      //     textStyle: TextStyle(
                      //       fontSize: 16, // 여기에서 원하는 글자 크기로 조절
                      //       color: Colors.black, // 글자 색상 설정
                      //     )),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
