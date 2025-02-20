import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? fontHeight;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  const XText(this.text,
      {super.key,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.maxLines,
      this.textAlign,
      this.fontHeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: textAlign,
      style: TextStyle(
        height: fontHeight,
          fontSize: fontSize ?? 42.sp, fontWeight: fontWeight, color: color),
    );
  }
}
