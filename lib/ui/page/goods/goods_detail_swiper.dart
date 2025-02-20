import 'package:card_swiper/card_swiper.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_detail_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class GoodsDetailSwiper extends StatefulWidget {
  final List<ImageBean>? imageList;
  final RxString curImageX;

  const GoodsDetailSwiper(
    this.imageList,
      this.curImageX
  );

  @override
  State<GoodsDetailSwiper> createState() => _DetailSwipeState();
}

class _DetailSwipeState extends State<GoodsDetailSwiper> {
  final Map<int, VideoPlayerController> videoControllerMap =
      <int, VideoPlayerController>{};
  final List<MediaBean> mediaList = [];
  final SwiperController swiperController = SwiperController();
  @override
  void initState() {
    super.initState();
    asyncFillMedia();
    Future.delayed(Duration.zero).then((onValue){
      moveSwiperBySelected();
    });
    widget.curImageX.listen((onData){
      moveSwiperBySelected();
    });
  }

  void moveSwiperBySelected() {
    int target = mediaList.indexWhere((test) => test.fileName == widget.curImageX.value);
    if (target > -1 && target != swiperController.index) {
      _disposeVideo();
      swiperController.move(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      containerHeight: AppDimens.DIMENS_600.h,
      controller: swiperController,
      itemBuilder: (BuildContext context, int index) {
        MediaBean bean = mediaList[index];
        RxBool showPlayIconX = RxBool(false);
        RxBool volumeOnX = RxBool(true);
        RxDouble aspectRatioX = RxDouble(1);
        if (bean.mediaType == "video") {
          VideoPlayerController controller = videoControllerMap[index] ??
              VideoPlayerController.networkUrl(
                  Uri.parse(XUtils.textOf(bean.fileName)));
          videoControllerMap[index] = controller;
          controller.initialize().then((onValue) {
            aspectRatioX.value = controller.value.aspectRatio;
            showPlayIconX.value = true;
          });
          controller.addListener(() {
            if (controller.value.isCompleted &&
                !controller.value.isPlaying &&
                !controller.value.isBuffering) {
              showPlayIconX.value = true;
            }
          });
          return Stack(
            children: [
              Center(
                  child: Obx(() => AspectRatio(
                      aspectRatio: aspectRatioX.value,
                      child: VideoPlayer(controller)))),
              Obx(() => Visibility(
                  visible: showPlayIconX.value,
                  child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showPlayIconX.value = false;
                          controller.play();
                        },
                        child: Image.asset(
                          AppImages.ICON_PLAY,
                          width: 50,
                          height: 50,
                        ),
                      )))
              ),
              Positioned(
                right: AppDimens.DIMENS_30.w,
                bottom: AppDimens.DIMENS_80.h,
                child: Obx(() => GestureDetector(
                  onTap: () {
                    volumeOnX.value = !(volumeOnX.value);
                    if(volumeOnX.isTrue) {
                      controller.setVolume(1);
                    } else {
                      controller.setVolume(0);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.8)
                    ),
                    padding: EdgeInsets.all(2),
                    child: Icon(volumeOnX.isTrue ? Icons.volume_off : Icons.volume_up, color: Colors.white,),
                  ),
                )
              ),)
            ],
          );
        }
        return CachedImageView(
          double.infinity,
          AppDimens.DIMENS_600.h,
          bean.fileName,
          fit: BoxFit.fill,
        );
      },
      itemCount: mediaList.length,
      pagination: SwiperCustomPagination(builder: (swiperContext, config) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(2)),
            margin: EdgeInsets.only(
                bottom: AppDimens.DIMENS_20.h,
                right: AppDimens.DIMENS_30.w),
            padding:
            EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
            child: Text(
              "${config.activeIndex + 1}/${config.itemCount}",
              style: XTextStyle.color_ffffff_size_36,
            ),
          ),
        );
      }),
    );
  }

  void asyncFillMedia() {
    if (widget.imageList != null) {
      for (ImageBean imageBean in widget.imageList!) {
        append(mediaList, imageBean.imageBig,
            imageBean.fileType == "2" ? "video" : "image");
      }
    }
  }

  void append(List<MediaBean> details, String? img, String mediaType) {
    if (img != null && img.isNotEmpty) {
      details.add(MediaBean(mediaType: mediaType, fileName: img));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposeVideo();
  }

  void _disposeVideo() {
    videoControllerMap.forEach((_, playerController) {
      playerController.dispose();
    });
    videoControllerMap.clear();
  }
}
