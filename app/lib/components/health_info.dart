import 'dart:ffi';
import 'package:app/common/style/app_colors.dart';
import "package:provider/provider.dart";
import 'package:flutter/material.dart';
import 'package:app/store/diary/diary_store.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/diary/moon_printer.dart';

class HealthInfo extends StatefulWidget {
  final double water;
  final double sleep; // 타입을 String으로 변경
  final String reportId;
  final String memberId;
  const HealthInfo({
    super.key,
    required this.water,
    required this.sleep,
    required this.reportId,
    required this.memberId,
  });

  @override
  State<HealthInfo> createState() => _HealthInfoState();
}

class _HealthInfoState extends State<HealthInfo> {
  late double _water;
  late double _sleepHours;

  @override
  void initState() {
    super.initState();
    _water = widget.water;
    _sleepHours = widget.sleep;
    _fetchReportData();
  }

  @override
  void didUpdateWidget(covariant HealthInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.water != oldWidget.water || widget.sleep != oldWidget.sleep) {
      // water나 sleep 값이 변경되었으면 상태를 업데이트합니다.
      _water = widget.water;
      _sleepHours = widget.sleep;
      setState(() {});
    }
  }

  Future<void> _fetchReportData() async {
    final data =
        await Provider.of<DiaryProvider>(context, listen: false).getReport(
      context,
      widget.reportId,
      int.tryParse(widget.memberId) ?? 0,
    );

    setState(() {
      // 이 부분에서 data의 값을 기반으로 상태를 업데이트합니다.
      _water = data['water'];
      _sleepHours = data['sleep'];
    });
  }

  // "HH:MM:SS" 형태의 문자열을 받아서 총 시간(소수점 포함)으로 변환
  double _parseSleepToHours(String sleep) {
    List<String> parts = sleep.split(':');
    if (parts.length != 3) return 0; // 형식에 맞지 않는 경우 0으로 처리
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours + minutes / 60.0; // 분을 시간 단위로 변환하여 합산
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 241, 241, 241),
      ),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      color: AppColors.blue,
                    ),
                    Text(
                      '수분 섭취',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: _water <= 0
                              ? null
                              : () {
                                  // print(_water);
                                  setState(() {
                                    _water -= 200;
                                    if (_water < 0) {
                                      _water = 0;
                                    }
                                    Provider.of<DiaryProvider>(context,
                                            listen: false)
                                        .putWater(_water, widget.reportId,
                                            widget.memberId);
                                  });
                                },
                          icon: Icon(
                            Icons.remove,
                            size: 40,
                            color: _water <= 0
                                ? const Color(0xff5C677D)
                                : const Color(0xff7CADFF),
                          ),
                        ),
                        Text(
                          "200ml",
                          style: TextStyle(
                            fontSize: 16,
                            color: _water <= 0
                                ? const Color(0xff5C677D)
                                : const Color(0xff7CADFF),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 2),
                              width: 58,
                              height: 53,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 4,
                                ),
                              ),
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: 50,
                              height: (_water / 40),
                              decoration: const BoxDecoration(
                                color: Color(0xff7CAEFF),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${(_water * 0.001).toStringAsFixed(1)}L",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: _water >= 2000
                              ? null
                              : () {
                                  setState(() {
                                    _water += 200;
                                    if (_water > 2000) {
                                      _water = 2000;
                                    }
                                  });
                                  Provider.of<DiaryProvider>(context,
                                          listen: false)
                                      .putWater(_water, widget.reportId,
                                          widget.memberId);
                                },
                          icon: Icon(
                            Icons.add,
                            size: 40,
                            color: _water >= 2000
                                ? const Color(0xff5C677D)
                                : const Color(0xff7CADFF),
                          ),
                        ),
                        Text(
                          "200ml",
                          style: TextStyle(
                            fontSize: 16,
                            color: _water >= 2000
                                ? const Color(0xff5C677D)
                                : const Color(0xff7CADFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Slider(
                  value: _water,
                  min: 0,
                  max: 2000,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      Provider.of<DiaryProvider>(context, listen: false)
                          .putWater(_water, widget.reportId, widget.memberId);
                      // 값이 최대값을 초과하는지 확인하고 최대값으로 고정
                      _water = newValue > 2000 ? 2000 : newValue;
                    });
                  },
                  activeColor: const Color(0xff7CADFF),
                  inactiveColor: const Color(0xff5C677D),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bedtime_sharp,
                color: Color(0xffFFC700),
              ),
              Text(
                "수면 시간",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFFC700),
                ),
              ),
            ],
          ), // 원본 문자열을 직접 표시
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: _sleepHours <= 0
                        ? null
                        : () {
                            setState(() {
                              _sleepHours -= 1;
                              if (_sleepHours < 0) {
                                _sleepHours = 0;
                              }
                            });
                            Provider.of<DiaryProvider>(context, listen: false)
                                .putSleep(_sleepHours, widget.reportId,
                                    widget.memberId);
                          },
                    icon: Icon(
                      Icons.remove,
                      size: 40,
                      color: _sleepHours <= 0
                          ? const Color(0xff5C677D)
                          : const Color(0xffFFC700),
                    ),
                  ),
                  Text(
                    "1시간",
                    style: TextStyle(
                      color: _sleepHours <= 0
                          ? const Color(0xff5C677D)
                          : const Color(0xffFFC700),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 100), // 애니메이션 지속 시간 설정
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      // 아래로 사라지는 효과와 함께 새로운 위젯이 나타나게 하는 트랜지션 정의
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.2), // 시작 위치
                          end: Offset.zero, // 최종 위치
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: _sleepHours != 0
                        ? MoonPhaseWidget(
                            key: const ValueKey<int>(1), // 고유 키 할당
                            sleepHours: _sleepHours,
                          )
                        : const Icon(
                            Icons.sunny,
                            key: ValueKey<int>(0), // 고유 키 할당
                            size: 40,
                            color: Color(0xffFFC700),
                          ),
                  ),
                  Text(
                    "${_sleepHours.toStringAsFixed(1)}시간",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: _sleepHours >= 12
                        ? null
                        : () {
                            setState(() {
                              _sleepHours += 1;
                              if (_sleepHours >= 12) {
                                _sleepHours = 12;
                              }
                            });
                            Provider.of<DiaryProvider>(context, listen: false)
                                .putSleep(_sleepHours, widget.reportId,
                                    widget.memberId);
                          },
                    icon: Icon(
                      Icons.add,
                      size: 40,
                      color: _sleepHours >= 12
                          ? const Color(0xff5C677D)
                          : const Color(0xffFFC700),
                    ),
                  ),
                  Text(
                    "1시간",
                    style: TextStyle(
                      color: _sleepHours >= 12
                          ? const Color(0xff5C677D)
                          : const Color(0xffFFC700),
                    ),
                  )
                ],
              ),
            ],
          ),

          Slider(
            value: _sleepHours,
            min: 0,
            max: 12,
            divisions: 24,
            onChanged: (value) {
              // print(value);
              setState(() {
                _sleepHours = value;
              });
              Provider.of<DiaryProvider>(context, listen: false)
                  .putSleep(_sleepHours, widget.reportId, widget.memberId);
            },
            activeColor: const Color(0xffFFC700),
            inactiveColor: const Color(0xff5C677D),
          ),
        ],
      ),
    );
  }
}
