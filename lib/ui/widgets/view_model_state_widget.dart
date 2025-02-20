import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/loading_dialog.dart';
import 'package:dealful_mall/ui/widgets/network_error.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';

class ViewModelStateWidget {
  static Widget stateWidget(BaseViewModel viewModel) {
    if (viewModel.pageState == PageState.loading) {
      return LoadingDialog();
    } else if (viewModel.pageState == PageState.error) {
      return NetWorkErrorView(viewModel.errorMessage);
    } else if (viewModel.pageState == PageState.empty) {
      return EmptyDataView();
    }
    return SizedBox.shrink();
  }

  static Widget stateWidgetWithCallBack(BaseViewModel viewModel, VoidCallback callback) {
    return pageStateWidget(viewModel.pageState, XUtils.textOf(viewModel.errorMessage), callback);
  }

  static Widget pageStateWidget(PageState pageState, String errorMessage, VoidCallback callback) {
    if (pageState == PageState.loading) {
      return LoadingDialog();
    } else if (pageState == PageState.error) {
      return NetWorkErrorView(errorMessage, callback: callback);
    } else   {
      return EmptyDataView();
    }
  }
}
