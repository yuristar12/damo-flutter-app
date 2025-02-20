
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/ui/page/inner/supplier_category_page.dart';
import 'package:dealful_mall/ui/page/inner/supplier_home_page.dart';
import 'package:dealful_mall/ui/page/inner/supplier_product_page.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:flutter/material.dart';

class SupplierDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_SupplierDetailState();

}

class _SupplierDetailState extends State<SupplierDetailPage> {
  int _selectedIndex = 0;
  late List<Widget> _list;
  @override
  void initState() {
    super.initState();
    _list = [
      SupplierHomePage(),
      SupplierProductPage(),
      SupplierCategoryPage(),
      SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: AppStrings.HOME.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall),
            label: AppStrings.PRODUCT.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: AppStrings.CATEGORY.translated,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
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

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}