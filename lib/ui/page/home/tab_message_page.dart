import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/main.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabMessagePage extends StatefulWidget {
  @override
  _TabMessagePageState createState() => _TabMessagePageState();
}

class _TabMessagePageState extends State<TabMessagePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.MESSAGE.translated),
        centerTitle: true,
      ),
      body: EmptyDataView(),
    );
  }
}
