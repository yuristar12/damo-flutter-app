import 'package:card_swiper/card_swiper.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

class TabHomeMenu extends StatefulWidget {
  final List<HomeModelMenu>? menuData;

  const TabHomeMenu(this.menuData);

  @override
  State<TabHomeMenu> createState() => _TabHomeMenuState();
}

class _TabHomeMenuState extends State<TabHomeMenu> {
  int current = 0;
  List twoDimensionalArray = [];
  Map<String, Color> _textColors = {}; // 存储每个菜单项的文字颜色

  void splitList(List<HomeModelMenu> list, int len) {
    twoDimensionalArray = [];
    if (widget.menuData!.length <= len) {
      if (widget.menuData!.isNotEmpty) twoDimensionalArray = [widget.menuData!];
    } else {
      List<HomeModelMenu> temp1 = list.skip(0).take(len).toList();
      List<HomeModelMenu> temp2 = list.skip(5).take(widget.menuData!.length - 5).toList();
      twoDimensionalArray.add(temp1);
      twoDimensionalArray.add(temp2);
    }
    
    // while (true) {
    //   if (index * len < list.length) {
    //     List<HomeModelMenu> temp = list.skip((index - 1) * len).take(len).toList();
    //     twoDimensionalArray.add(temp);
    //     index++;
    //     continue;
    //   }
    //   List<HomeModelMenu> temp = list.skip((index - 1) * len).toList();
    //   twoDimensionalArray.add(temp);
    //   break;
    // }
    print('twoDimensionalArray${twoDimensionalArray}');
  }

  void refreshList () {
    splitList(widget.menuData!, 5);
  }

  @override
  void initState() {
    super.initState();
    splitList(widget.menuData!, 5);
    _analyzeMenuColors();
  }

  Future<void> _analyzeMenuColors() async {
    if (widget.menuData == null) return;
    
    for (var menu in widget.menuData!) {
      if (menu.ImageUrl != null) {
        await _analyzeImageColor(menu.ImageUrl!, menu.Title ?? '');
      }
    }
  }

  Future<void> _analyzeImageColor(String imageUrl, String title) async {
    try {
      final NetworkImage image = NetworkImage(imageUrl);
      final ImageStream stream = image.resolve(ImageConfiguration.empty);
      final Completer<void> completer = Completer<void>();
      
      stream.addListener(ImageStreamListener((ImageInfo info, bool _) async {
        final ByteData? byteData = await info.image.toByteData(format: ImageByteFormat.rawRgba);
        if (byteData != null) {
          final int width = info.image.width;
          final int height = info.image.height;
          final int bottomArea = (height * 0.3).round(); // 分析底部区域，因为文字在图片下方
          
          double totalBrightness = 0;
          int pixelCount = 0;
          
          for (int y = height - bottomArea; y < height; y += 10) {
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
            setState(() {
              _textColors[title] = averageBrightness < 0.5 ? Colors.white : Colors.black;
            });
          }
        }
        completer.complete();
      }));
      
      await completer.future;
    } catch (e) {
      print('Error analyzing menu image color: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    splitList(widget.menuData!, 5);
    return twoDimensionalArray.isNotEmpty ? Column(
      children: [
        Container(
          height: current == 0 ? 220.h: (twoDimensionalArray[1].length/5).ceil()*220.h,
          
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.COLOR_F6F6F6, width: 0),
             gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0,0.9, 1],
                colors: [
                AppColors.COLOR_F6F6F6,
                Color.fromRGBO(246, 246, 246, 1),
                Color.fromRGBO(246, 246, 246, 1),
              ]),
            // color: AppColors.COLOR_F6F6F6,
            // color: Colors.red,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.h), topRight: Radius.circular(40.h))
          ),
          padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 20.w),
          margin: EdgeInsets.only(top: 0.w, bottom: 0.w),
          alignment: Alignment.center,
          child: Swiper(
            index: current,
            autoplay: false,
            itemCount: twoDimensionalArray.length,
            onIndexChanged: (index) {
              current = index;
              setState(() {
                
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
               return  Row(
                  mainAxisAlignment: twoDimensionalArray[index].length > 4 ? MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                  children: List.generate(twoDimensionalArray[index].length, (idx) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, twoDimensionalArray[index]![idx].Link ?? '');
                      },
                      child: Container(
                        width: 200.w,
                        child: Column(
                          children: [
                            twoDimensionalArray[index]![idx].ImageUrl != null ? Image.network(
                                XUtils.textOf('${twoDimensionalArray[index][idx].ImageUrl}'),
                                fit: BoxFit.fitWidth,
                                width: 160.w,
                                errorBuilder: (_, error, stacktrace) {
                                  return Image.asset(
                                    AppImages.DEFAULT_PICTURE,
                                    fit: BoxFit.cover,
                                    width: 160.w,
                                  );
                                },
                              ):Image.asset(
                                AppImages.DEFAULT_PICTURE,
                                fit: BoxFit.cover,
                                width: 160.w,
                              ),
                            SizedBox(height: 10.w,),
                            Row(
                              children: [
                                Expanded(child: Text(
                                  textAlign: TextAlign.center,
                            XUtils.textOf('${twoDimensionalArray[index][idx].Title}'),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 36.sp, 
                                fontWeight: FontWeight.bold,
                                color:  Colors.black,
                              ),
                            ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
               return  Wrap(
                  // mainAxisAlignment: twoDimensionalArray[index].length > 4 ? MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                  children: List.generate(twoDimensionalArray[index].length, (idx) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, twoDimensionalArray[index]![idx].Link ?? '');
                      },
                      child: Container(
                        width: 210.w,
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Column(
                          children: [
                            twoDimensionalArray[index]![idx].ImageUrl != null ? Image.network(
                                XUtils.textOf('${twoDimensionalArray[index][idx].ImageUrl}'),
                                fit: BoxFit.fitWidth,
                                width: 160.w,
                                errorBuilder: (_, error, stacktrace) {
                                  return Image.asset(
                                    AppImages.DEFAULT_PICTURE,
                                    fit: BoxFit.cover,
                                    width: 160.w,
                                  );
                                },
                              ):Image.asset(
                                AppImages.DEFAULT_PICTURE,
                                fit: BoxFit.cover,
                                width: 160.w,
                              ),
                            SizedBox(height: 10.w,),
                            Row(
                              children: [
                                Expanded(child: Text(
                                  textAlign: TextAlign.center,
                            XUtils.textOf('${twoDimensionalArray[index][idx].Title}'),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 36.sp, 
                                fontWeight: FontWeight.bold,
                                color: _textColors[twoDimensionalArray[index][idx].Title] ?? Colors.black,
                              ),
                            ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
          )
        ),
        twoDimensionalArray.length > 1 ? Container(
          
          // padding: EdgeInsets.only(bottom: 20.h),
          // margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: AppColors.COLOR_F6F6F6,
            border: Border.all(color: AppColors.COLOR_F6F6F6, width: 0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(twoDimensionalArray.length, (index) {
              return Container(
                width: current == index ? 40.w:20.w,
                height: 20.w,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: current == index ? AppColors.primaryColor:AppColors.COLOR_999999
                ),
              );
            }),
          ),
        ):SizedBox(height: 0.h,)
      ],
    ):SizedBox.shrink();
  }
}