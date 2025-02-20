import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdaptiveWebView extends StatefulWidget {
  final String? htmlString;
  final String? url;

  AdaptiveWebView({this.htmlString, this.url});

  @override
  State<StatefulWidget> createState() => _AdaptiveWebState();
}

class _AdaptiveWebState extends State<AdaptiveWebView> {
  double height = 10;

  @override
  Widget build(BuildContext context) {
    if(widget.url == null && widget.htmlString == null) {
      return SizedBox.shrink();
    }
    return SizedBox(
      height: height,
      child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            useHybridComposition: true,
            ignoresViewportScaleLimits: true,
            automaticallyAdjustsScrollIndicatorInsets: true,
            useOnNavigationResponse: true,
            cacheEnabled: false,
            supportZoom: false,
            transparentBackground:true,
          ),
          onLoadStop: onloadStop,
          initialData: InAppWebViewInitialData(
              baseUrl: WebUri(XUtils.textOf(widget.url)),
              data: packHtml(widget.htmlString)),
          gestureRecognizers: [
            Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer())
          ].toSet()
        ),
    );
  }

  void onloadStop(InAppWebViewController controller, WebUri? url) {
    Future.delayed(Durations.medium1, () async {
      int? contentHeight = await controller.getContentHeight();
      double? zoomScale = await controller.getZoomScale();
      if (contentHeight != null && zoomScale != null) {
        setState(() {
          height = contentHeight * zoomScale;
        });
      }
    });
  }

  String packHtml(String? htmlString) {
    if(htmlString == null) {
      return "";
    }
    if(htmlString.startsWith("<head")) {
      return htmlString;
    }
    String head = "<head>"
        + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
        + "<style>img{max-width: 100%; width:100%; height:auto;}*{margin:0px;}</style>"
        + "</head>";
    return "<html>" + head + "<body>" + htmlString + "</body></html>";
  }
}
