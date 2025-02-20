import 'package:flutter/material.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class BaseViewModel extends ChangeNotifier{
  PageState pageState = PageState.loading;
  bool _isDispose = false;
  var errorMessage;

  bool get isDispose => _isDispose;

  @override
  void notifyListeners() {
    print("view model notifyListeners");
    if (!_isDispose) {
      super.notifyListeners();
    }
  }

  errorNotify(String? error) {
    pageState = PageState.error;
    errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDispose = true;
    print("view model dispose");
    super.dispose();
  }
}
