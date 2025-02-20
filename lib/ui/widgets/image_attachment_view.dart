import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/model/sealed_result.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:flutter/material.dart';

class ImageAttachmentView extends StatefulWidget{
  final String? fileId;
  final Size? size;
  final BoxFit? boxFit;
  const ImageAttachmentView(this.fileId, {super.key, this.size, this.boxFit});

  @override
  State<StatefulWidget> createState() => _ImageAttachmentState();
}


class _ImageAttachmentState extends State<ImageAttachmentView> {
  Result result = Result.loading;
  @override
  void initState() {
    super.initState();
    if(widget.fileId == null || widget.fileId!.isEmpty) {
      result = Result.empty;
      return;
    }
    HttpUtil.fetchApiStore().getFile(widget.fileId!).then((onValue) {
      if(onValue.success == true && onValue.data?.isNotEmpty == true) {
        setState(() {
          result = Result.ready(onValue.data!);
        });
      } else {
        result = Result.error(onValue.msg ?? "loading error");
      }
    }, onError: (error) {
      result = Result.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = widget.size ?? const Size(100,60);
    if(result.isReady()) {
      return Image.network(result.data, height: size.height, width: size.width,fit: widget.boxFit,);
    } else if(result.isLoading()){
      return SizedBox(
        width: size.width,
        height: size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Image.asset(AppImages.DEFAULT_PICTURE, height: size.height, width: size.width,);
    }
  }
}