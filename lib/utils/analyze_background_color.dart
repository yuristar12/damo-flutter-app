import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnalyzeBackgroundColor {
  /// 分析背景图片并返回适配的文字颜色和状态栏样式
  /// [imageUrl] 背景图片URL
  /// [onColorChanged] 颜色变化回调
  /// [analyzeArea] 分析区域高度比例，默认0.3表示分析顶部30%的区域
  /// [defaultIsDark] 默认是否为深色背景
  static Future<void> analyze({
    required String imageUrl,
    required Function(Color textColor, bool isDark) onColorChanged,
    double analyzeArea = 0.3,
    bool defaultIsDark = true,
  }) async {
    try {
      final NetworkImage image = NetworkImage(imageUrl);
      final ImageStream stream = image.resolve(ImageConfiguration.empty);
      final Completer<void> completer = Completer<void>();
      
      stream.addListener(ImageStreamListener((ImageInfo info, bool _) async {
        final ByteData? byteData = await info.image.toByteData(format: ImageByteFormat.rawRgba);
        if (byteData != null) {
          final int width = info.image.width;
          final int height = info.image.height;
          final int topArea = (height * analyzeArea).round();
          
          double totalBrightness = 0;
          int pixelCount = 0;
          
          for (int y = 0; y < topArea; y += 10) {
            for (int x = 0; x < width; x += 10) {
              final int offset = ((y * width + x) * 4).round();
              if (offset + 3 < byteData.lengthInBytes) {
                final int r = byteData.getUint8(offset);
                final int g = byteData.getUint8(offset + 1);
                final int b = byteData.getUint8(offset + 2);
                final Color color = Color.fromRGBO(r, g, b, 1);
                final double brightness = color.computeLuminance();
                totalBrightness += brightness;
                pixelCount++;
              }
            }
          }
          
          if (pixelCount > 0) {
            final double averageBrightness = totalBrightness / pixelCount;
            final bool isDark = averageBrightness < 0.5;
            final Color textColor = isDark ? Colors.white : Colors.black;
            
            onColorChanged(textColor, isDark);
            
            // 更新状态栏样式
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            ));
          }
        }
        completer.complete();
      }));
      
      await completer.future;
    } catch (e) {
      print('Error analyzing background color: $e');
      // 发生错误时使用默认值
      final Color textColor = defaultIsDark ? Colors.white : Colors.black;
      onColorChanged(textColor, defaultIsDark);
    }
  }

  /// 更新状态栏样式
  static void updateStatusBarStyle(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }
}

