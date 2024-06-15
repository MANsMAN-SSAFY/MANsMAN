// 패키지
import 'package:flutter/material.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:flutter/services.dart';

class AppNormalTextField extends StatelessWidget {
  final String hint;
  final Function(String)? onChange;
  final Color? enabledBorderColor; // 활성화됐을 때 테두리 색상
  final Color? focusedBorderColor; // 포커스됐을 때 테두리 색상
  final Color? labelColor;
  final bool obscureText; // 비밀번호 안 보이는 것
  final bool autocorrect;
  final bool autofocus;
  final bool enableSuggestions;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;
  final controller;
  final int? limit;
  const AppNormalTextField({
    super.key,
    required this.hint,
    this.onChange,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.obscureText = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.suffixIcon,
    this.errorText,
    this.controller,
    this.limit,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // 입력 포맷터를 동적으로 생성
    List<TextInputFormatter> inputFormatters = [
      FilteringTextInputFormatter.deny(RegExp(
          r"\s"
          // 이모지 차단을 위한 범위
          r"[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{2B50}\u{1F004}\u{1F0CF}\u{1F18E}\u{3030}\u{2B05}\u{2B06}\u{2B07}\u{2B1B}\u{2B1C}\u{2B50}\u{2B55}\u{2934}\u{2935}\u{2CE5}\u{2CE6}\u{2CE7}\u{2CE8}\u{2CE9}\u{2CEA}\u{2CEF}\u{2CF1}]",
          unicode: true // 유니코드 범위를 사용하기 위해 true로 설정
          )),
    ];

    if (limit != null) {
      inputFormatters.add(LengthLimitingTextInputFormatter(limit));
    }

    // 기본 border 설정
    const baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: AppColors.input_border,
        width: 1.0,
      ),
    );

    return TextField(
      inputFormatters: inputFormatters,
      controller: controller,
      autofocus: autofocus,
      obscureText: obscureText, // 실제 값 안 보임
      autocorrect: autocorrect, // 자동 완성 기능
      enableSuggestions: enableSuggestions, // 자동 제안 기능
      onChanged: onChange,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        suffixIcon: suffixIcon,
        hintText: hint,
        labelText: hint,
        hintStyle: TextStyle(color: AppColors.iconBlack.withOpacity(0.5)),
        labelStyle: TextStyle(color: labelColor ?? AppColors.blue),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(color: AppColors.blue),
        ),
        filled: true,
        fillColor: AppColors.tag.withOpacity(0.3),
      ),
    );
  }
}
