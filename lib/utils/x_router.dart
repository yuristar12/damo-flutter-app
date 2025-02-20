/*
 * @description: ...
 */

import 'package:dealful_mall/ui/page/goods/category_goods_page.dart';
import 'package:dealful_mall/ui/page/goods/fill_in_order_page.dart';
import 'package:dealful_mall/ui/page/goods/goods_detail_page.dart';
import 'package:dealful_mall/ui/page/goods/review_page.dart';
import 'package:dealful_mall/ui/page/goods/search_goods_page.dart';
import 'package:dealful_mall/ui/page/goods/search_supplier_page.dart';
import 'package:dealful_mall/ui/page/goods/submit_success_page.dart';
import 'package:dealful_mall/ui/page/home/brand_detail_page.dart';
import 'package:dealful_mall/ui/page/home/home_page.dart';
import 'package:dealful_mall/ui/page/home/project_selection_detail_page.dart';
import 'package:dealful_mall/ui/page/home/tab_cart_page.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_best_goods_category.dart';
import 'package:dealful_mall/ui/page/inner/be_supplier_page.dart';
import 'package:dealful_mall/ui/page/inner/blog_detail_page.dart';
import 'package:dealful_mall/ui/page/inner/blog_posts_page.dart';
import 'package:dealful_mall/ui/page/inner/category_list_page.dart';
import 'package:dealful_mall/ui/page/inner/select_cartype_page.dart';
import 'package:dealful_mall/ui/page/inner/select_vehicle_page.dart';
import 'package:dealful_mall/ui/page/inner/supplier_detail_page.dart';
import 'package:dealful_mall/ui/page/inner/your_vehicle_page.dart';
import 'package:dealful_mall/ui/page/login/login_page.dart';
import 'package:dealful_mall/ui/page/login/qrcode_page.dart';
import 'package:dealful_mall/ui/page/login/register_page.dart';
import 'package:dealful_mall/ui/page/mine/about_us_page.dart';
import 'package:dealful_mall/ui/page/mine/address_detail_page.dart';
import 'package:dealful_mall/ui/page/mine/address_page.dart';
import 'package:dealful_mall/ui/page/mine/collect_page.dart';
import 'package:dealful_mall/ui/page/mine/coupon_page.dart';
import 'package:dealful_mall/ui/page/mine/feedback_page.dart';
import 'package:dealful_mall/ui/page/mine/follow_store.dart';
import 'package:dealful_mall/ui/page/mine/foot_print_page.dart';
import 'package:dealful_mall/ui/page/launch/launch.dart';
import 'package:dealful_mall/ui/page/mine/order_detail_page.dart';
import 'package:dealful_mall/ui/page/mine/order_page.dart';
import 'package:dealful_mall/ui/page/mine/quote_requests_page.dart';
import 'package:dealful_mall/ui/page/mine/setting_page.dart';
import 'package:dealful_mall/ui/page/mine/wishlist_page.dart';
import 'package:dealful_mall/ui/widgets/webview_widget.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:get/get.dart';

class XRouterPath {
  static String bestCategory = "/bestCategory";
  static String guide = "/guide";
  static String home = "/home";
  static String launch = "/launch";
  static String categoryGoods = "/categoryGoods";
  static String goodsDetail = "/goodsDetail";
  static String login = "/login";
  static String register = "/register";
  static String fillInOrder = "/fillInOrder";
  static String address = "/address";
  static String editAddress = "/editAddress";
  static String coupon = "/coupon";
  static String searchGoods = "/searchGoods";
  static String webView = "/webView";
  static String brandDetail = "/brandDetail";
  static String projectSelectionDetail = "/projectSelectionDetail";
  static String collect = "/collect";
  static String aboutUs = "/aboutUs";
  static String feedBack = "/feedBack";
  static String footPrint = "/footPrint";
  static String submitSuccess = "/submitSuccess";
  static String homeCategoryGoods = "/homeCategoryGoods";
  static String orderPage = "/orderPage";
  static String orderDetailPage = "/orderDetailPage";
  static String qrcode = "/qrcode";
  static String cartPage = "/cartPage";
  static String review = "/review";
  static String settings = "/settings";
  static String wishlist = "/wishlist";
  static String blogDetail = "/blogDetail";
  static String blogPosts = "/blogPosts";
  static String quoteRequests = "/quoteRequests";
  static String selectVehicle = "/selectVehicle";
  static String selectCarType = "/selectCarType";
  static String yourVehicle = "/yourVehicle";
  static String searchSupplier = "/searchSupplier";
  static String categoryList = "/categoryList";
  static String supplierDetail = "/supplierDetail";
  static String followStore = "/followStore"; // 关注店铺   
  static String beSupplier = "/beSupplier"; // 成为供应商
}

class XRouter {
  static const String resultOk = "RESULT_OK";
  static String? _routeResult;

  /// 获取当前结果并清空结果
  static String? fetchResult() {
    String? temp = _routeResult;
    _routeResult = null;
    return temp;
  }

  static void setResult({String result = resultOk}) {
    _routeResult = result;
  }

  static void routingCallback(Routing? routing) async {
    if(routing != null) {
      XUtils.showLog("要跳转的路由地址是：${routing.current}");
    }
  }


  static List<GetPage> routes = [
     GetPage(
      name: XRouterPath.bestCategory,
      page: () => TabBestGoodsCategoryPage(),
    ),
    GetPage(
      name: XRouterPath.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: XRouterPath.launch,
      page: () => LaunchPage(),
    ),
    GetPage(
      name: XRouterPath.categoryGoods,
      page: () => CategoryGoodsPage(),
    ),
    GetPage(
      name: XRouterPath.goodsDetail,
      page: () => GoodsDetailPage(),
    ),
    GetPage(
      name: XRouterPath.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: XRouterPath.fillInOrder,
      page: () => FillInOrderPage(),
    ),
    GetPage(
      name: XRouterPath.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: XRouterPath.address,
      page: () => AddressViewPage(),
    ),
    GetPage(
      name: XRouterPath.editAddress,
      page: () => AddressDetailPage(),
    ),
    GetPage(
      name: XRouterPath.coupon,
      page: () => CouponPage(),
    ),
    GetPage(
      name: XRouterPath.searchGoods,
      page: () => SearchGoodsPage(),
    ),
    GetPage(
      name: XRouterPath.webView,
      page: () => WebViewPage(),
    ),
    GetPage(
      name: XRouterPath.brandDetail,
      page: () => BrandDetailPage("", 0),
    ),
    GetPage(
      name: XRouterPath.projectSelectionDetail,
      page: () => ProjectSelectionDetailView(0),
    ),
    GetPage(
      name: XRouterPath.collect,
      page: () => CollectPage(),
    ),
    GetPage(
      name: XRouterPath.aboutUs,
      page: () => AboutUsPage(),
    ),
    GetPage(
      name: XRouterPath.feedBack,
      page: () => FeedBackPage(),
    ),
    GetPage(
      name: XRouterPath.footPrint,
      page: () => FootPrintPage(),
    ),
    GetPage(
      name: XRouterPath.submitSuccess,
      page: () => SubmitSuccessPage(),
    ),
    GetPage(
      name: XRouterPath.categoryList,
      page: () => CategoryListPage(),
    ),
    GetPage(
      name: XRouterPath.orderPage,
      page: () => OrderPage(),
    ),
    GetPage(
      name: XRouterPath.orderDetailPage,
      page: () => OrderDetailPage(),
    ),
    GetPage(
      name: XRouterPath.qrcode,
      page: () => QrcodePage(),
    ),
    GetPage(
      name: XRouterPath.cartPage,
      page: () => TabCartPage(),
    ),
    GetPage(
      name: XRouterPath.settings,
      page: () => SettingPage(),
    ),
    GetPage(
      name: XRouterPath.review,
      page: () => ReviewPage(),
    ),
    GetPage(
      name: XRouterPath.wishlist,
      page: () => WishlistPage(),
    ),
    GetPage(
      name: XRouterPath.blogDetail,
      page: () => BlogDetailPage(),
    ),
    GetPage(
      name: XRouterPath.blogPosts,
      page: () => BlogPostsPage(),
    ),
    GetPage(
      name: XRouterPath.quoteRequests,
      page: () => QuoteRequestsPage(),
    ),
    GetPage(
      name: XRouterPath.selectVehicle,
      page: () => SelectVehiclePage(),
    ),
    GetPage(
      name: XRouterPath.selectCarType,
      page: () => SelectCarTypePage(),
    ),
    GetPage(
      name: XRouterPath.yourVehicle,
      page: () => YourVehiclePage(),
    ),
    GetPage(
      name: XRouterPath.searchSupplier,
      page: () => SearchSupplierPage(),
    ),
    GetPage(
      name: XRouterPath.supplierDetail,
      page: () => SupplierDetailPage(),
    ),
    GetPage(
      name: XRouterPath.followStore,
      page: () => FollowStorePage(),
    ),
    GetPage(
      name: XRouterPath.beSupplier,
      page: () => BeSupplierPage(),
    )
  ];
}
