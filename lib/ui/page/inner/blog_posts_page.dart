import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/main.dart';
import 'package:dealful_mall/model/blog_category.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_brand.dart';
import 'package:dealful_mall/ui/page/inner/tab_blog_posts.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BlogPostsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BlogPostsPageState();
}

class _BlogPostsPageState extends State<BlogPostsPage> {
  PageState pageState = PageState.loading;
  String errorMessage = "";
  List<BlogCategory> blogCategories = [];
  @override
  void initState() {
    super.initState();
    HttpUtil.fetchApiStore().getBlogCategories()
      .apiCallback((data){
        if(data is List<BlogCategory>) {
          blogCategories = data;
        }
        setState(() {
          if(blogCategories.isNotEmpty) {
            pageState = PageState.hasData;
          } else {
            pageState = PageState.empty;
          }
        });
    }, (error) {
      setState(() {
        errorMessage = error;
        pageState = PageState.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pageState != PageState.hasData) {
      return Scaffold(body: ViewModelStateWidget.pageStateWidget(
          pageState, errorMessage, () {}));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.BLOG_POSTS.translated),
      ),
      body: DefaultTabController(length: blogCategories.length, child: Column(
        children: [
          TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.only(
                      top: AppDimens.DIMENS_10.h,
                      bottom: AppDimens.DIMENS_20.h),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  tabs: List.generate(
                      blogCategories.length,
                      (index) => Text(
                          XUtils.textOf(blogCategories[index].name))
                  )
          ),
          Expanded(
              child:
              TabBarView(
                  children: List.generate(blogCategories.length, (index)=>TabBlogPosts(blogCategories[index].id))))
        ],
      )),
    );
  }

}