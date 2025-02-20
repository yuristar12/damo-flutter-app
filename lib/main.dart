import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/language_entity.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_strings.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  // 初始化
  WidgetsFlutterBinding.ensureInitialized();
  var _userViewModel = UserViewModel();
  var _cartViewModel = CartViewModel();
  Get.put(_userViewModel);
  Get.put(_cartViewModel);
  BrnInitializer.register(
      allThemeConfig: BrnAllThemeConfig(
    // 全局配置
    commonConfig: BrnCommonConfig(brandPrimary: AppColors.primaryColor),
  ));
  await ScreenUtil.ensureScreenSize();
  await initConfig();
  // await Future.delayed(Duration(seconds: 2));
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(AppDimens.MAX_WIDTH, AppDimens.MAX_HEIGHT));
    return ScreenUtilInit(
      designSize: const Size(AppDimens.MAX_WIDTH, AppDimens.MAX_HEIGHT),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale('zh', 'CN'),
          builder: EasyLoading.init(),
          title: AppStrings.APP_NAME,
          debugShowCheckedModeBanner: false,
          routingCallback: XRouter.routingCallback,
          initialRoute: XRouterPath.launch,
          getPages: XRouter.routes,
          translations: XStrings(),
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            BrnLocalizationDelegate.delegate
          ],
          supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
          theme: ThemeData(
            primarySwatch: AppColors.themeColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColors.COLOR_F7F7F9,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeColor),
            // fontFamily: 'Avenir',
            appBarTheme: AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(
                    color: Colors.black, fontSize: AppDimens.DIMENS_54.sp),
                surfaceTintColor: Colors.black,
                backgroundColor: AppColors.COLOR_F7F7F9,
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black)),
          ),
        );
      },
      fontSizeResolver: (fontSize, util) {
        return fontSize.r;
      },
    );
  }
}

Future initConfig() {
  SharedPreferencesUtil.getInstance()
      .getMap(AppStrings.APP_CURRENCY)
      .then((onValue) {
    if (onValue != null) {
      CurrencyEntity currencyEntity = CurrencyEntity.fromJson(onValue);
      XLocalization.setCurrencyEntity(currencyEntity);
    }
  });
  XLocalization.loadCarAttribute();
  return SharedPreferencesUtil.getInstance()
      .getMap(AppStrings.APP_LANGUAGE)
      .then((value) {
    if (value != null) {
      LanguageEntity languageEntity = LanguageEntity.fromJson(value);
      XLocalization.setLanguageEntity(languageEntity);
      XLocalization.loadLanguagePack();
    }
    XLocalization.loadLocation();
  });
}
