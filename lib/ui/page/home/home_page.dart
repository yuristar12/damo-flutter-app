import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/ui/page/home/tab_cart_page.dart';
import 'package:dealful_mall/ui/page/home/tab_discover_page.dart';
import 'package:dealful_mall/ui/page/home/tab_message_page.dart';
import 'package:dealful_mall/ui/page/home/tab_mine_page.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_page.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _list = [];
  late CartViewModel _cartViewModel;
  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getInstance().setBool(AppStrings.IS_FIRST, false);
    tabSelectBus.on<TabSelectEvent>().listen((event) {
      if(mounted) {
        setState(() {
          _selectedIndex = event.selectIndex;
        });
      } else {
        _selectedIndex = event.selectIndex;
      }
    });
    _cartViewModel = Get.find();
    _list
      ..add(TabHomePage())
      ..add(TabDiscoverPage())
      ..add(TabMessagePage())
      ..add(TabCartPage())
      ..add(TabMinePage());
  }

  void _onItemTapped(int index) {
    if (index > 2) {
      SharedPreferencesUtil.getInstance()
          .getString(AppStrings.TOKEN)
          .then((value) {
        if (value == null || value.isEmpty) {
          NavigatorUtil.goLogin(context);
          return;
        }
        _changeIndex(index);
      });
    } else {
      //防止点击当前BottomNavigationBarItem rebuild
      _changeIndex(index);
    }
  }

  _changeIndex(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth/5;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.HOME.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storm),
            label: AppStrings.DISCOVER.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: AppStrings.MESSAGE.translated,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Stack(
                children: [
                  Positioned.fill(child: Icon(
                    Icons.shopping_cart,
                  )),
                  Positioned(
                      left: width/2,
                      child: Obx(() => Visibility(
                          visible: _cartViewModel.cartNum > 0,
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryColor,
                        ),
                        height: 20,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: XText(
                          XUtils.textOf(_cartViewModel.cartNum),
                          color: AppColors.COLOR_FFFFFF,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ))))
                ],
              ),
            ),
            label: AppStrings.CART.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.MINE.translated,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.COLOR_F7F7F9,
        onTap: _onItemTapped,
      ),
    );
  }
}
