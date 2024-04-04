import "package:app/common/style/app_colors.dart";
import "package:flutter/material.dart";

class MoonPainter extends CustomPainter {
  final double progress; // 0 ~ 1 사이의 값

  MoonPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xffFFC700) // 달의 색상
      ..style = PaintingStyle.fill;

    var center = Offset(size.width / 2, size.height / 2);
    var radius = size.width / 2;

    // 달 전체를 그립니다.
    canvas.drawCircle(center, radius, paint);

    if (progress <= 1) {
      var coverPaint = Paint()
        ..color = const Color.fromARGB(255, 241, 241, 241) // 배경 색상, 달을 가릴 색상
        ..style = PaintingStyle.fill;

      // progress에 따라 달을 가리는 원의 위치를 계산
      // progress가 증가함에 따라 가리는 원의 중심이 달의 중심으로 이동
      var coverCenter = Offset(
          center.dx + progress * radius * 2, center.dy - progress * radius);
      // 가리는 원을 그려서 달의 일부를 가립니다.
      canvas.drawCircle(coverCenter, radius, coverPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MoonPhaseWidget extends StatelessWidget {
  final double sleepHours;
  const MoonPhaseWidget({super.key, required this.sleepHours});

  @override
  Widget build(BuildContext context) {
    // sleepHours에 따라 달의 차오름 정도를 계산합니다. (0 ~ 12시간)
    double progress = sleepHours / 12.0;
    return CustomPaint(
      size: const Size(40, 40), // 적절한 크기 설정
      painter: MoonPainter(progress: progress),
    );
  }
}
