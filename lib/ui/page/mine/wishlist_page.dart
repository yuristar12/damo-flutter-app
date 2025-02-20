import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class WishlistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<WishlistPage> {
  final RxList<ProductEntity> productEntitiesX = RxList();
  final Rx<PageState> pageStateX = Rx(PageState.loading);

  @override
  void initState() {
    super.initState();
    HttpUtil.fetchApiStore().getOwnWishlist().apiCallback((data) {
      if (data is List<ProductEntity>) {
        productEntitiesX.assignAll(data);
        pageStateX.value = PageState.hasData;
      }
    }, (errorMsg) {
      pageStateX.value = PageState.error;
      XUtils.showError(errorMsg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.WISHLIST.translated),
        centerTitle: true,
      ),
      body: Obx(() {
        if (pageStateX.value == PageState.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return _wishItemView(productEntitiesX[index]);
            },
            itemCount: productEntitiesX.length,
          );
        }
        return ViewModelStateWidget.pageStateWidget(
            pageStateX.value, "", () {});
      }),
    );
  }

  Widget _wishItemView(ProductEntity wishItem) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goGoodsDetails(context, wishItem.id ?? '');
      },
      child: Card(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            top: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
          child: Slidable(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedImageView(
                    ScreenUtil().setWidth(AppDimens.DIMENS_200),
                    ScreenUtil().setWidth(AppDimens.DIMENS_200),
                    XUtils.textOf(wishItem.image),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_20))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(XUtils.textOf(wishItem.name),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: XTextStyle.color_333333_size_42),
                        Padding(
                          padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                          child: Text("${wishItem.priceDiscounted}",
                              style: XTextStyle.color_999999_size_42),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (actionContext) {
                      deleteItem(wishItem);
                    },
                    label: AppStrings.DELETE.translated,
                    icon: Icons.delete,
                    foregroundColor: AppColors.primaryColor,
                  )
                ],
              )),
        ),
      ),
    );
  }

  void deleteItem(ProductEntity wishItem) {
    HttpUtil.fetchApiStore().updateWishlist(XUtils.textOf(wishItem.id)).apiCallback((successData){
      productEntitiesX.remove(wishItem);
    });
  }
}
