import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthButton extends StatefulWidget {

  const AuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.elevated = false,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool elevated;
  final VoidCallback onPressed;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {

    // 제스처 감지 위젯
    return GestureDetector(
      behavior: HitTestBehavior.opaque,  // 투명한 영역도 터치되는 영역으로 인정

      // (_) 파라미터가 들어오지만 쓰지 않는다.
      onTapDown: (_) => setState(() => _pressed = true), // 누르기 시작하면
      onTapUp: (_) => setState(() => _pressed = false), // 손을 떼면
      onTapCancel: () => setState(() => _pressed = false), // 취소돼도
      onTap: widget.onPressed, //정상 클릭이면 onPressd 함수를 실행해라

      // child : 자식 위젯, AnimatedScale : 크기 애니메이션을 주는 위젯
      child: AnimatedScale(
        // 누르면 작아지게
        scale: _pressed ? 0.98 : 1.0,
        // 0.12초
        duration: const Duration(milliseconds: 120),
        // 처음에는 빠르게 끝으로 갈수록 부드럽게
        curve: Curves.easeOut,
        child: Container(
          // 가로로 가능한 만큼 꽉 채우기
          width: double.infinity,
          // height는 52로 고정
          height: 52,

          // 박스 모양 꾸미기
          decoration: BoxDecoration(
            // 배경색 flutter State의 widget은 현재 이 State와 연결된 Widget을 나타냄
            color: widget.backgroundColor,
            // 모서리 처리
            borderRadius: BorderRadius.circular(12),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1)
                : null,
            // 그림자 처리
            boxShadow: widget.elevated
                ? const [
                    BoxShadow(
                      color: AppColors.primaryShadow,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),

          //Container 안에서 자식 위젯을 가운데 Row를 중앙에 배치
          alignment: Alignment.center,
          // 자식으로 Row?
          child: Row(
            // Row의 메인 축은 가로 방향, Row 안의 내용물을 가로 방향 기준으로 가운데 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            // Row의 가로 크기를 필요한 만큼만 차지, 버튼 전체 너비가 아닌 아이콘, 간격, 텍스트 너비만큼만 가지게 됨
            mainAxisSize: MainAxisSize.min,
            // 여러 자식을 가질 수 있으므로, children
            children: [
              // 아이콘, SizedBox는 크기를 고정함
              SizedBox(
                width: 20,
                height: 20,

                child: Center(child: widget.icon),
              ),

              // 아이콘, 텍스트 사이의 간격
              const SizedBox(width: 10),
              // 텍스트
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.075, // -0.005em * 15px
                  color: widget.foregroundColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
