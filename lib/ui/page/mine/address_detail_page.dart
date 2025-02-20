import 'package:city_pickers/city_pickers.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/ui/widgets/divider_line.dart';
import 'package:dealful_mall/ui/widgets/select_location_dialog.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/common_widget_creater.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/address_detail_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressDetailPage extends StatefulWidget {
  const AddressDetailPage();

  @override
  _AddressDetailPageState createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final AddressDetailViewModel _model = AddressDetailViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _addressId;
  bool inputInited = false;
  @override
  void initState() {
    super.initState();
    _addressId = Get.parameters[AppParameters.ADDRESS_ID] ?? "";
    inputInited = _addressId.isEmpty;
    _onRefresh();
  }

  _initController(AddressDetailViewModel model) {
    if(inputInited) {
      return;
    }
    final AddressEntity addressEntity = model.addressEntity;
    _titleController.text = XUtils.textOf(addressEntity.title);
    if(_titleController.text.isNotEmpty) {
      inputInited = true;
    }
    _firstNameController.text = XUtils.textOf(addressEntity.firstName);
    _lastNameController.text = XUtils.textOf(addressEntity.lastName);
    _emailController.text = XUtils.textOf(addressEntity.email);
    _phoneController.text = XUtils.textOf(addressEntity.phoneNumber);
    _zipCodeController.text = XUtils.textOf(addressEntity.zipCode);
    _addressDetailController.text = XUtils.textOf(addressEntity.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.ADDRESS_EDIT_TITLE.translated),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<AddressDetailViewModel>(
          create: (_) => _model,
          child: Consumer<AddressDetailViewModel>(
              builder: (builder, model, child) {
            _initController(model);
            return showWidget(model);
          }),
        ));
  }

  Widget showWidget(AddressDetailViewModel addressDetailViewModel) {
    if (addressDetailViewModel.pageState == PageState.hasData) {
      return _contentView(addressDetailViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        addressDetailViewModel, _onRefresh);
  }

  Widget _contentView(AddressDetailViewModel model) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _addressTypeWidget(),
                          DividerLineView(),
                          _simpleInputWidget(
                              AppStrings.ADDRESS_TITLE.translated,
                              _titleController),
                          DividerLineView(),
                          _simpleInputWidget(AppStrings.FIRST_NAME.translated,
                              _firstNameController),
                          DividerLineView(),
                          _simpleInputWidget(AppStrings.LAST_NAME.translated,
                              _lastNameController),
                          DividerLineView(),
                          _simpleInputWidget(
                              AppStrings.EMAIL.translated, _emailController,
                              (input) {
                            if (input?.isNotEmpty == true &&
                                GetUtils.isEmail(input!)) {
                              return null;
                            } else {
                              return AppStrings.ENTER_EMAIL_TIP.translated;
                            }
                          }),
                          DividerLineView(),
                          _phoneWidget(),
                          DividerLineView(),
                          _addressAreaWidget(model),
                          DividerLineView(),
                          _simpleInputWidget(AppStrings.ZIP_CODE.translated,
                              _zipCodeController),
                          DividerLineView(),
                          _addressDetailWidget(),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_30.h),
                  child: _defaultWidget(model),
                ),
                _saveButtonWidget(model),
                _deleteWidget(model)
              ],
            ))));
  }

  Widget _addressTypeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
      width: double.infinity,
      height: AppDimens.DIMENS_120.h,
      child: Row(
        children: [
          SizedBox(
              width: AppDimens.DIMENS_200.w,
              child: Text(
                AppStrings.ADDRESS_TYPE.translated,
                style: XTextStyle.color_333333_size_42,
              )),
          DropdownButton<KeyEntity>(
              value: _model.selectedType,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              onChanged: (entity) {
                if (entity != null && entity != _model.selectedType) {
                  setState(() {
                    _model.selectedType = entity;
                  });
                }
              },
              padding: EdgeInsets.zero,
              items: CommonWidgetCreater.buildKeyMenus(_model.addressTypesX,
                  textStyle: XTextStyle.color_333333_size_38)),
        ],
      ),
    );
  }

  Widget _simpleInputWidget(String label, TextEditingController inputController,
      [String? Function(String? value)? validator]) {
    if (validator == null) {
      validator = _requireInput;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
      width: double.infinity,
      height: AppDimens.DIMENS_120.h,
      child: Row(
        children: [
          SizedBox(
              width: AppDimens.DIMENS_200.w,
              child: Text(
                label,
                style: XTextStyle.color_333333_size_42,
              )),
          Expanded(
            child: TextFormField(
                maxLines: 1,
                cursorColor: AppColors.primaryColor,
                controller: inputController,
                style: XTextStyle.color_333333_size_42,
                validator: validator,
                decoration: InputDecoration(
                    hintStyle: XTextStyle.color_999999_size_42,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ))),
          )
        ],
      ),
    );
  }

  String? _requireInput(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.REQUIRED.translated;
    }
    return null;
  }

  Widget _phoneWidget() {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
      alignment: Alignment.center,
      width: double.infinity,
      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 0,
              child: SizedBox(
                  width: AppDimens.DIMENS_200.w,
                  child: Text(
                    AppStrings.PHONE_NUMBER.translated,
                    maxLines: 2,
                    style: XTextStyle.color_333333_size_42,
                  ))),
          Positioned(
            left: AppDimens.DIMENS_200.w,
            child: Container(
                width: ScreenUtil().setWidth(AppDimens.DIMENS_800),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    cursorColor: AppColors.primaryColor,
                    controller: _phoneController,
                    style: XTextStyle.color_333333_size_42,
                    validator: _requireInput,
                    decoration: InputDecoration(
                        hintStyle: XTextStyle.color_999999_size_42,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        )))),
          )
        ],
      ),
    );
  }

  Widget _addressAreaWidget(AddressDetailViewModel addressDetailViewModel) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
      alignment: Alignment.center,
      width: double.infinity,
      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 0,
              child: Text(
                AppStrings.CITY.translated,
                style: XTextStyle.color_333333_size_42,
              )),
          Positioned(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_200),
            child: Container(
                width: ScreenUtil().setWidth(AppDimens.DIMENS_800),
                child: InkWell(
                    onTap: () => this.show(context, addressDetailViewModel),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(AppDimens.DIMENS_160),
                      child: Obx(() => Text(
                            addressDetailViewModel.addressAreaX.isEmpty
                                ? AppStrings.COMMON_CHOOSE_HINT.translated
                                : addressDetailViewModel.addressAreaX.value,
                            style: addressDetailViewModel.addressAreaX.isEmpty
                                ? XTextStyle.color_999999_size_42
                                : XTextStyle.color_333333_size_42,
                          )),
                    ))),
          )
        ],
      ),
    );
  }

  Widget _addressDetailWidget() {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
      alignment: Alignment.center,
      width: double.infinity,
      height: ScreenUtil().setHeight(AppDimens.DIMENS_200),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 0,
              child: Text(
                AppStrings.ADDRESS.translated,
                style: XTextStyle.color_333333_size_42,
              )),
          Positioned(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_200),
            child: Container(
                width: ScreenUtil().setWidth(AppDimens.DIMENS_800),
                height: ScreenUtil().setHeight(AppDimens.DIMENS_200),
                child: TextFormField(
                    maxLines: 3,
                    controller: _addressDetailController,
                    style: XTextStyle.color_333333_size_42,
                    cursorColor: AppColors.primaryColor,
                    validator: _requireInput,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ))),
          )
        ],
      ),
    );
  }

  Widget _defaultWidget(AddressDetailViewModel addressDetailViewModel) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
            right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
        alignment: Alignment.center,
        width: double.infinity,
        height: ScreenUtil().setHeight(AppDimens.DIMENS_150),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0,
                child: Text(
                  AppStrings.SET_AS_DEFAULT.translated,
                  style: XTextStyle.color_333333_size_42,
                )),
            Positioned(
              right: ScreenUtil().setWidth(AppDimens.DIMENS_20),
              child: Container(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Obx(() => CupertinoSwitch(
                      value: addressDetailViewModel.isDefaultX.value,
                      activeColor: AppColors.primaryColor,
                      onChanged: (checked) {
                        addressDetailViewModel.setDefault(checked);
                      })),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _saveButtonWidget(AddressDetailViewModel addressViewModel) {
    return Container(
        margin: EdgeInsets.only(
            top: AppDimens.DIMENS_80.h,
            left: AppDimens.DIMENS_30.w,
            right: AppDimens.DIMENS_30.w),
        width: double.infinity,
        child: TextButton(
          onPressed: () => _submit(addressViewModel),
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.DIMENS_30)))),
          child: Text(
            AppStrings.SAVE.translated,
            style: XTextStyle.color_ffffff_size_42,
          ),
        ));
  }

  Widget _deleteWidget(AddressDetailViewModel addressDetailViewModel) {
    return Visibility(
      visible: _addressId.isNotEmpty,
      child: Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(AppDimens.DIMENS_40),
            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
        width: double.infinity,
        child: RawMaterialButton(
          onPressed: () => _delete(context, addressDetailViewModel),
          child: Text(
            AppStrings.DELETE.translated,
            style: XTextStyle.color_333333_size_42,
          ),
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.DIMENS_60),
              ),
              side: BorderSide(color: AppColors.COLOR_999999, width: 1)),
          fillColor: AppColors.COLOR_FFFFFF,
        ),
      ),
    );
  }

  _onRefresh() {
    _model.queryAddressDetail(_addressId);
  }

  //选择城市
  show(context, AddressDetailViewModel addressDetailViewModel) async {
    showDialog(
        context: context,
        builder: (_) => BottomSheet(
            backgroundColor: Colors.white,
            onClosing: () {},
            builder: (sheetContext) {
              return SelectLocationDialog(
                saveFunc: (countryEntity, stateEntity, cityEntity) {
                  addressDetailViewModel.saveLocation(
                      countryEntity, stateEntity, cityEntity);
                },
                requireDetailedLocation: true,
              );
            }));
  }

  //删除地址dialog
  _delete(BuildContext context, AddressDetailViewModel model) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppStrings.TIPS.tr,
              style: XTextStyle.color_333333_size_48,
            ),
            content: Text(
              AppStrings.ADDRESS_DELETE_TIPS.tr,
              style: XTextStyle.color_333333_size_42,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppStrings.CANCEL,
                  style: XTextStyle.color_primary_size_42,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteAddress(model);
                },
                child: Text(
                  AppStrings.CONFIRM,
                  style: XTextStyle.color_333333_size_42,
                ),
              ),
            ],
          );
        });
  }

  _submit(AddressDetailViewModel model) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    if (_model.addressEntity.stateId == null) {
      XUtils.showToast(AppStrings.FORM_VALIDATION_REQUIRED.translated
          .format([AppStrings.CITY.translated]));
      return;
    }
    model
        .saveAddress(
      _titleController.text,
      _firstNameController.text,
      _lastNameController.text,
      _emailController.text,
      _zipCodeController.text,
      _phoneController.text,
      _addressDetailController.text,
    )
        .then((response) {
      if (response!) {
        Navigator.pop(context);
      }
    });
  }

  _deleteAddress(AddressDetailViewModel model) {
    model.deleteAddress(_addressId).then((result) {
      if (result == true) {
        XUtils.showToast(AppStrings.DELETE_SUCCESS.tr);
        Navigator.pop(context);
      } else {
        XUtils.showToast(_model.errorMessage);
      }
    });
  }
}
