import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewPage extends StatelessWidget {
  final RxString bannerNameX = RxString(AppStrings.APP_NAME);
  WebViewPage();

  @override
  Widget build(BuildContext context) {
    String? bannerDetailUrl = Get.parameters[AppParameters.URL];
    return Scaffold(
      appBar: AppBar(
        title: Obx(()=>Text(bannerNameX.value)),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          useHybridComposition: true,
          ignoresViewportScaleLimits: true,
          automaticallyAdjustsScrollIndicatorInsets: true,
          useOnNavigationResponse: true,
          cacheEnabled: false,
          supportZoom: false,
        ),
        onTitleChanged: (_, title) {
          if(title != null) {
            bannerNameX.value = title;
          }
        },
        onLoadStart: (_, uri) {
          if(uri?.rawValue.startsWith(AppUrls.PAY_RETURN) == true) {
            Get.back();
          }
        },
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
              handlerName: "NativeHandler",
              callback: (args) async {
                if(args.isNotEmpty) {
                  var argument = args[0];
                  var type = XUtils.textOf(argument["type"]);
                  var param = XUtils.textOf(argument["value"]);
                  switch(type) {
                    case AppParameters.ROUTE:
                      if(param.isNotEmpty) {
                        Get.toNamed(param);
                      }
                      break;
                  }
                }
              });
        },
        initialUrlRequest:
            URLRequest(url: WebUri(bannerDetailUrl ?? AppStrings.INDEX)),
      ),
    );
  }
}
