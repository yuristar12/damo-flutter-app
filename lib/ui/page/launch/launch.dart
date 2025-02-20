import 'package:dealful_mall/ui/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(HomePage());
    }); 
    return Container(
      alignment: Alignment.center,
      color: Color(0xFFF7F7F7),
      child: Image.asset('images/launch_bg.png'),
    );
  }
}