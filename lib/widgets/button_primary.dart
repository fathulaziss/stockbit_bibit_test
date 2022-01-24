import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonPrimary extends StatelessWidget {
  final double? height;
  final Color? backgroundColor;
  final String? title;
  final TextStyle? titleStyle;
  final Function()? onPressed;
  final EdgeInsets? margin;

  const ButtonPrimary({
    this.height,
    this.backgroundColor,
    this.title,
    this.titleStyle,
    required this.onPressed,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 45.w,
      margin: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: () {
          onPressed!();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.w),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? const Color(0xFFEAECFF)),
          overlayColor: MaterialStateProperty.all(Colors.black12),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(title ?? '',
            style: titleStyle ??
                TextStyle(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w500,
                )),
      ),
    );
  }
}
