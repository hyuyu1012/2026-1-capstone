import 'package:flutter/material.dart';

import '../theme/app_colors.dart';


// 방패 체크 아이콘, 내부 상태를 가지지 않는다.
class ShieldCheckIcon extends StatelessWidget {
  // 생성
  const ShieldCheckIcon({super.key, this.size = 32, this.color = Colors.white});

  // 아이콘의 크기와 색깔 지
  final double size;
  final Color color;

  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ShieldCheckPainter(color: color),
    );
  }
}

class _ShieldCheckPainter extends CustomPainter {
  _ShieldCheckPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * (size.width / 24)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final s = size.width / 24;
    final shield = Path()
      ..moveTo(12 * s, 2 * s)
      ..lineTo(4 * s, 5 * s)
      ..lineTo(4 * s, 11 * s)
      ..cubicTo(4 * s, 16 * s, 7.5 * s, 20.5 * s, 12 * s, 22 * s)
      ..cubicTo(16.5 * s, 20.5 * s, 20 * s, 16 * s, 20 * s, 11 * s)
      ..lineTo(20 * s, 5 * s)
      ..close();
    canvas.drawPath(shield, paint);

    final check = Path()
      ..moveTo(8.5 * s, 12.2 * s)
      ..lineTo(11 * s, 14.6 * s)
      ..lineTo(15.5 * s, 9.8 * s);
    canvas.drawPath(check, paint);
  }

  @override
  bool shouldRepaint(covariant _ShieldCheckPainter old) => old.color != color;
}

class KakaoIcon extends StatelessWidget {
  const KakaoIcon({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _KakaoPainter(),
    );
  }
}

class _KakaoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kakaoFg
      ..style = PaintingStyle.fill;

    final s = size.width / 24;
    final path = Path()
      ..moveTo(12 * s, 4 * s)
      ..cubicTo(6.48 * s, 4 * s, 2 * s, 7.58 * s, 2 * s, 12 * s)
      ..cubicTo(2 * s, 14.84 * s, 3.88 * s, 17.34 * s, 6.74 * s, 18.74 * s)
      ..lineTo(5.66 * s, 22.32 * s)
      ..cubicTo(5.6 * s, 22.5 * s, 5.8 * s, 22.64 * s, 5.96 * s, 22.54 * s)
      ..lineTo(10.16 * s, 19.84 * s)
      ..cubicTo(10.76 * s, 19.92 * s, 11.38 * s, 19.96 * s, 12 * s, 19.96 * s)
      ..cubicTo(17.52 * s, 19.96 * s, 22 * s, 16.4 * s, 22 * s, 12 * s)
      ..cubicTo(22 * s, 7.58 * s, 17.52 * s, 4 * s, 12 * s, 4 * s)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(22.56 * s, 12.25 * s)
        ..cubicTo(22.56 * s, 11.47 * s, 22.49 * s, 10.72 * s, 22.36 * s, 10 * s)
        ..lineTo(12 * s, 10 * s)
        ..lineTo(12 * s, 14.26 * s)
        ..lineTo(17.92 * s, 14.26 * s)
        ..cubicTo(17.66 * s, 15.63 * s, 16.88 * s, 16.79 * s, 15.72 * s, 17.57 * s)
        ..lineTo(15.72 * s, 20.34 * s)
        ..lineTo(19.28 * s, 20.34 * s)
        ..cubicTo(21.36 * s, 18.42 * s, 22.56 * s, 15.6 * s, 22.56 * s, 12.25 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(12 * s, 23 * s)
        ..cubicTo(14.97 * s, 23 * s, 17.46 * s, 22.02 * s, 19.28 * s, 20.34 * s)
        ..lineTo(15.72 * s, 17.57 * s)
        ..cubicTo(14.74 * s, 18.23 * s, 13.48 * s, 18.63 * s, 12 * s, 18.63 * s)
        ..cubicTo(9.14 * s, 18.63 * s, 6.71 * s, 16.7 * s, 5.84 * s, 14.1 * s)
        ..lineTo(2.18 * s, 14.1 * s)
        ..lineTo(2.18 * s, 16.94 * s)
        ..cubicTo(3.99 * s, 20.53 * s, 7.7 * s, 23 * s, 12 * s, 23 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(5.84 * s, 14.09 * s)
        ..cubicTo(5.62 * s, 13.43 * s, 5.49 * s, 12.73 * s, 5.49 * s, 12 * s)
        ..cubicTo(5.49 * s, 11.27 * s, 5.62 * s, 10.57 * s, 5.84 * s, 9.91 * s)
        ..lineTo(5.84 * s, 7.07 * s)
        ..lineTo(2.18 * s, 7.07 * s)
        ..cubicTo(1.43 * s, 8.55 * s, 1 * s, 10.22 * s, 1 * s, 12 * s)
        ..cubicTo(1 * s, 13.78 * s, 1.43 * s, 15.45 * s, 2.18 * s, 16.93 * s)
        ..lineTo(5.84 * s, 14.09 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(12 * s, 5.38 * s)
        ..cubicTo(13.62 * s, 5.38 * s, 15.06 * s, 5.94 * s, 16.21 * s, 7.02 * s)
        ..lineTo(19.36 * s, 3.87 * s)
        ..cubicTo(17.45 * s, 2.09 * s, 14.97 * s, 1 * s, 12 * s, 1 * s)
        ..cubicTo(7.7 * s, 1 * s, 3.99 * s, 3.47 * s, 2.18 * s, 7.07 * s)
        ..lineTo(5.84 * s, 9.91 * s)
        ..cubicTo(6.71 * s, 7.31 * s, 9.14 * s, 5.38 * s, 12 * s, 5.38 * s)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class AppleIcon extends StatelessWidget {
  const AppleIcon({super.key, this.size = 18, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ApplePainter(color: color),
    );
  }
}

class _ApplePainter extends CustomPainter {
  _ApplePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final s = size.width / 24;

    final body = Path()
      ..moveTo(17.05 * s, 20.28 * s)
      ..cubicTo(16.07 * s, 21.23 * s, 14.99 * s, 21.08 * s, 13.96 * s, 20.63 * s)
      ..cubicTo(12.87 * s, 20.17 * s, 11.87 * s, 20.15 * s, 10.72 * s, 20.63 * s)
      ..cubicTo(9.26 * s, 21.26 * s, 8.49 * s, 21.08 * s, 7.63 * s, 20.28 * s)
      ..cubicTo(2.79 * s, 15.25 * s, 3.51 * s, 7.59 * s, 9 * s, 7.31 * s)
      ..cubicTo(10.35 * s, 7.38 * s, 11.29 * s, 8.05 * s, 12.08 * s, 8.11 * s)
      ..cubicTo(13.25 * s, 7.87 * s, 14.37 * s, 7.19 * s, 15.62 * s, 7.28 * s)
      ..cubicTo(17.11 * s, 7.4 * s, 18.23 * s, 7.99 * s, 18.97 * s, 9.05 * s)
      ..cubicTo(15.91 * s, 10.88 * s, 16.63 * s, 14.91 * s, 19.43 * s, 16.03 * s)
      ..cubicTo(18.87 * s, 17.5 * s, 18.16 * s, 18.96 * s, 17.05 * s, 20.28 * s)
      ..close();
    canvas.drawPath(body, paint);

    final leaf = Path()
      ..moveTo(11.97 * s, 7.25 * s)
      ..cubicTo(11.82 * s, 5.07 * s, 13.59 * s, 3.27 * s, 15.62 * s, 3.1 * s)
      ..cubicTo(15.91 * s, 5.62 * s, 13.34 * s, 7.5 * s, 11.97 * s, 7.25 * s)
      ..close();
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant _ApplePainter old) => old.color != color;
}

class MailIcon extends StatelessWidget {
  const MailIcon({super.key, this.size = 18, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MailPainter(color: color),
    );
  }
}

class _MailPainter extends CustomPainter {
  _MailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * (size.width / 24)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final s = size.width / 24;

    final rect = RRect.fromLTRBR(
      3 * s,
      5 * s,
      21 * s,
      19 * s,
      Radius.circular(2 * s),
    );
    canvas.drawRRect(rect, paint);

    final flap = Path()
      ..moveTo(3 * s, 6.5 * s)
      ..lineTo(12 * s, 13 * s)
      ..lineTo(21 * s, 6.5 * s);
    canvas.drawPath(flap, paint);
  }

  @override
  bool shouldRepaint(covariant _MailPainter old) => old.color != color;
}
