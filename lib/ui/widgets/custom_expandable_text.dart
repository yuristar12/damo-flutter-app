import 'package:bruno/src/theme/brn_theme_configurator.dart';
import 'package:flutter/material.dart';

typedef TextExpandedCallback = Function(bool);

/// 具备展开收起功能的文字面板
///
/// 布局规则：
///     在文本的右下角有更多或者收起按钮
///     当文本超过指定的[maxLines]时，剩余文本隐藏
///     点击更多，则显示全部文本
///
/// ```dart
///   CustomExpandableText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   CustomExpandableText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///      onExpanded: (value) {
///      },
///   )
///
///
/// ```
///
/// 相关文本组件如下:
///  * [BrnBubbleText], 气泡背景的展开收起文本组件
///  * [BrnInsertInfo], 气泡背景的文本组件
///
class CustomExpandableText extends StatefulWidget {
  ///显示的文本
  final String text;

  ///显示的最多行数
  final int? maxLines;

  /// 文本的样式
  final TextStyle? textStyle;

  /// 展开或者收起的时候的回调
  final TextExpandedCallback? onExpanded;

  /// 更多按钮渐变色的初始色 默认白色
  final Color? color;

  final String collapseText;
  final String expandText;

  const CustomExpandableText(
      {Key? key,
      required this.text,
      required this.collapseText,
      required this.expandText,
      this.maxLines = 1000000,
      this.textStyle,
      this.onExpanded,
      this.color})
      : super(key: key);

  _CustomExpandableTextState createState() => _CustomExpandableTextState();
}

class _CustomExpandableTextState extends State<CustomExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _defaultTextStyle();
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
            text: span,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr,
            ellipsis: 'EllipseText');
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (this._expanded) {
            return _expandedText(context, widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return _regularText(widget.text, style);
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    Color btnColor = widget.color ?? Colors.white;
    TextStyle textStyle = _defaultTextStyle();
    Container cnt = Container(
      padding: EdgeInsets.only(left: 22),
      alignment: Alignment.centerRight,
      child: Icon(Icons.expand_more, color: textStyle.color ?? BrnThemeConfigurator.instance
          .getConfig()
          .commonConfig
          .brandPrimary,),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [btnColor.withAlpha(100), btnColor, btnColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
    );
    return GestureDetector(
      child: cnt,
      onTap: () {
        setState(() {
          _expanded = true;
          if (null != widget.onExpanded) {
            widget.onExpanded!(_expanded);
          }
        });
      },
    );
  }

  Widget _expandedText(context, String text) {
    return RichText(
        text: TextSpan(text: text, style: _defaultTextStyle(), children: [
          _foldButtonSpan(context),
        ]),
        textScaler: MediaQuery.of(context).textScaler);
  }

  TextStyle _defaultTextStyle() {
    TextStyle style = widget.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: BrnThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .colorTextBase,
        );
    return style;
  }

  InlineSpan _foldButtonSpan(context) {
    TextStyle textStyle = _defaultTextStyle();
    Color color = textStyle.color??BrnThemeConfigurator.instance
        .getConfig()
        .commonConfig
        .brandPrimary;
    return WidgetSpan(
      child: Padding(padding: EdgeInsets.only(left: 4),child:
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = false;
              if (null != widget.onExpanded) {
                widget.onExpanded!(_expanded);
              }
            });
          },
          child: Icon(Icons.expand_less, color: color,),
        ),),
      style: textStyle
    );
  }

  Widget _regularText(text, style) {
    return Text(text, style: style);
  }
}
