import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/ui/widgets/custom_radio_input_item.dart';
import 'package:dealful_mall/ui/widgets/select_location_dialog.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BeSupplierPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BeSupplierState();
}

class BeSupplierState extends State<BeSupplierPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _operatingAddressController =
      TextEditingController();
  final TextEditingController _businessLicenseController =
      TextEditingController();
  final TextEditingController _mainProductsController = TextEditingController();
  LocationEntity? _countryEntity;
  LocationEntity? _stateEntity;
  LocationEntity? _cityEntity;
  Rx<DateTime?> incorporationTimeX = Rx(null);
  final DateFormat dateformat = DateFormat("yyyy-MM-dd");
  PageState pageState = PageState.loading;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_FFFFFF,
      appBar: AppBar(
        title: Text(AppStrings.START_SELLING.translated),
        centerTitle: true,
      ),
      body: buildContent(),
      persistentFooterButtons: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  AppColors.primaryColor.withAlpha(200)),
              shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              AppDimens.DIMENS_30))))),
          onPressed: () {
            _submit();
          },
          child: Text(
            AppStrings.SUBMIT.translated,
            style: XTextStyle.color_ffffff_size_48,
          ),
        ),
      ],
    );
  }

  void _submit() {}

  String? _validatorNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.REQUIRED.translated;
    }
    return null;
  }

  String getInputHint(String fieldName) {
    return "${AppStrings.INPUT_HINT.translated}${fieldName}";
  }

  Widget buildContent() {
    if(pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(pageState, errorMessage, acquireData);
    }
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            left: AppDimens.DIMENS_30.w,
            right: AppDimens.DIMENS_30.w,
            top: AppDimens.DIMENS_10.h),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.START_SELLING_EXP.translated,
                  style: XTextStyle.color_333333_size_42,
                ),
                Padding(padding: EdgeInsets.only(top: AppDimens.DIMENS_60.h)),
                TextFormField(
                  maxLines: 1,
                  validator: _validatorNotEmpty,
                  decoration: InputDecoration(
                    hintText:
                    getInputHint(AppStrings.COMPANY_NAME.translated),
                    hintStyle: XTextStyle.color_999999_size_36,
                    labelStyle: XTextStyle.color_333333_size_42,
                    labelText: AppStrings.COMPANY_NAME.translated,
                  ),
                  controller: _companyNameController,
                ),
                BrnTitleFormItem(
                  title: AppStrings.COMPANY_TYPE.translated,
                  operationLabel: AppStrings.COMMON_CHOOSE_HINT.translated,
                  themeData: BrnFormItemConfig(
                      titlePaddingSm: EdgeInsets.zero,
                      titlePaddingLg: EdgeInsets.zero,
                      headTitleTextStyle: BrnTextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  onTap: () {
                    XUtils.showToast("choose company_type");
                  },
                ),
                BrnTitleFormItem(
                  title: AppStrings.PRODUCT_CATEGORY.translated,
                  operationLabel: AppStrings.COMMON_CHOOSE_HINT.translated,
                  themeData: BrnFormItemConfig(
                      titlePaddingSm: EdgeInsets.zero,
                      titlePaddingLg: EdgeInsets.zero,
                      headTitleTextStyle: BrnTextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  onTap: () {
                    XUtils.showToast("choose product_category");
                  },
                ),
                CustomRadioInputFormItem.autoLayout(
                  themeData: BrnFormItemConfig(
                    titlePaddingSm: EdgeInsets.zero,
                    titlePaddingLg: EdgeInsets.zero,
                  ),
                  title: AppStrings.FOREIGN_TRADE_EXP.translated,
                  options: [
                    AppStrings.YES.translated,
                    AppStrings.NONE.translated,
                  ],
                  value: AppStrings.NONE.translated,
                  titleMaxLines: 2,
                  onChanged: (oldValue, newValue) {},
                ),
                Obx(() => BrnTitleFormItem(
                  title: AppStrings.INCORPORATION_TIME.translated,
                  operationLabel: incorporationTimeX.value == null
                      ? AppStrings.COMMON_CHOOSE_HINT.translated
                      : dateformat.format(incorporationTimeX.value!),
                  themeData: BrnFormItemConfig(
                      titlePaddingSm: EdgeInsets.zero,
                      titlePaddingLg: EdgeInsets.zero,
                      headTitleTextStyle: BrnTextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  onTap: () {
                    BrnDatePicker.showDatePicker(context,
                        // initialDateTime: incorporationTimeX.value,
                        dateFormat: dateformat.pattern,
                        pickerTitleConfig: BrnPickerTitleConfig(
                            cancel: Text(AppStrings.CANCEL.translated),
                            confirm: Text(AppStrings.OK.translated),
                            titleContent: AppStrings.COMMON_CHOOSE_HINT.translated
                        ),
                        onConfirm: (selectedDate, _) {
                          incorporationTimeX.value = selectedDate;
                        });
                  },
                )),
                TextFormField(
                  maxLines: 3,
                  minLines: 1,
                  validator: _validatorNotEmpty,
                  decoration: InputDecoration(
                    hintText:
                    "${AppStrings.COMMON_CHOOSE_HINT.translated}${AppStrings.CITY.translated}",
                    hintStyle: XTextStyle.color_999999_size_36,
                    labelStyle: XTextStyle.color_333333_size_42,
                    labelText: AppStrings.CITY.translated,
                  ),
                  controller: _cityController,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => BottomSheet(
                            backgroundColor: Colors.white,
                            onClosing: () {},
                            builder: (sheetContext) {
                              return SelectLocationDialog(
                                saveFunc:
                                    (countryEntity, stateEntity, cityEntity) {
                                  _countryEntity = countryEntity;
                                  _stateEntity = stateEntity;
                                  _cityEntity = cityEntity;
                                  String countryName =
                                  XUtils.textOf(_countryEntity?.name);
                                  String stateName =
                                  XUtils.textOf(_stateEntity?.name);
                                  String cityName =
                                  XUtils.textOf(_cityEntity?.name);
                                  _cityController.text = XUtils.textOf(
                                      countryName,
                                      orEmpty: true,
                                      suffix: " ") +
                                      XUtils.textOf(stateName,
                                          orEmpty: true, suffix: " ") +
                                      XUtils.textOf(cityName, orEmpty: true);
                                },
                                requireDetailedLocation: true,
                              );
                            }));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                  child: TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    validator: _validatorNotEmpty,
                    decoration: InputDecoration(
                      hintText: getInputHint(AppStrings.ADDRESS.translated),
                      hintStyle: XTextStyle.color_999999_size_36,
                      labelStyle: XTextStyle.color_333333_size_42,
                      labelText: AppStrings.ADDRESS.translated,
                    ),
                    controller: _addressController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                  child: TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    validator: _validatorNotEmpty,
                    decoration: InputDecoration(
                      hintText: getInputHint(
                          AppStrings.OPERATING_ADDRESS.translated),
                      hintStyle: XTextStyle.color_999999_size_36,
                      labelStyle: XTextStyle.color_333333_size_42,
                      labelText: AppStrings.OPERATING_ADDRESS.translated,
                    ),
                    controller: _operatingAddressController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                  child: TextFormField(
                    validator: _validatorNotEmpty,
                    decoration: InputDecoration(
                      hintText: getInputHint(
                          AppStrings.BUSINESS_LICENSE.translated),
                      hintStyle: XTextStyle.color_999999_size_36,
                      labelStyle: XTextStyle.color_333333_size_42,
                      labelText: AppStrings.BUSINESS_LICENSE.translated,
                    ),
                    controller: _businessLicenseController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                  child: TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText:
                      getInputHint(AppStrings.MAIN_PRODUCTS.translated),
                      hintStyle: XTextStyle.color_999999_size_36,
                      labelStyle: XTextStyle.color_333333_size_42,
                      labelText: AppStrings.MAIN_PRODUCTS.translated,
                    ),
                    controller: _mainProductsController,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void acquireData() {
    HttpUtil.fetchApiStore().getRegistrationFields("supplier")
        .apiCallback((successFunc){
       setState(() {
         pageState = PageState.hasData;
       });
    });
  }
}
