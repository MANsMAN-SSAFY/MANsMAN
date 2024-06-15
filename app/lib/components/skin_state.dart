import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:app/store/diary/my_skin_state.dart';

class SkinState extends StatefulWidget {
  final List<Map<String, dynamic>> skinData;
  final Map<String, dynamic> faceData;

  const SkinState({
    super.key,
    required this.skinData,
    required this.faceData,
  });

  @override
  State<SkinState> createState() => _SkinStateState();
}

class _SkinStateState extends State<SkinState> {
  late List<MySkinState> chartData;

  @override
  void initState() {
    chartData = getMySkinState();
    super.initState();
  }

  @override
  void didUpdateWidget(SkinState oldWidget) {
    if (widget.skinData != oldWidget.skinData) {
      setState(() {
        chartData = getMySkinState();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.faceData['faceShape']),
              Text(
                widget.faceData['skinType'],
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "피부나이",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    widget.faceData['age'].toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120, // 막대 그래프의 높이를 지정합니다.
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const CategoryAxis(
                        majorGridLines: MajorGridLines(width: 0),
                        axisLine: AxisLine(width: 0),
                      ), // X축은 범주형입니다.
                      primaryYAxis: const NumericAxis(
                        majorGridLines: MajorGridLines(width: 0),
                        axisLine: AxisLine(width: 0),
                        minorGridLines: MinorGridLines(width: 0),
                        isVisible: false,
                        minimum: 0,
                        maximum: 100,
                      ),
                      series: <CartesianSeries>[
                        BarSeries<MySkinState, String>(
                          dataSource: chartData,
                          width: 1,
                          spacing: 0.5,
                          isTrackVisible: true,
                          animationDuration: 500,
                          trackColor: const Color(0xffD9D9D9),
                          xValueMapper: (MySkinState data, _) =>
                              getKoreanSkinType(data.type),
                          yValueMapper: (MySkinState data, _) => data.value,
                          pointColorMapper: (MySkinState data, _) => data.color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<MySkinState> getMySkinState() {
    return widget.skinData.map<MySkinState>((map) {
      return MySkinState(
        type: map['type'] as String,
        value: map['value'] as int,
        color: map['color'] as Color,
      );
    }).toList();
  }

  String getKoreanSkinType(String englishType) {
    Map<String, String> typeMap = {
      'acne': '민감성',
      'wrinkles': '주름',
      'blackheads': '블랙헤드',
    };
    return typeMap[englishType] ?? englishType;
  }
}

class MySkinState {
  MySkinState({
    required this.type,
    required this.value,
    required this.color,
  });
  final String type;
  final int value;
  final Color color;
}
