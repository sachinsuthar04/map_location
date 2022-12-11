import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/test_feature/model/user_data_view_model.dart';
import 'package:testing_app/test_feature/ui/test_screen.dart';

import '../bloc/user_data_bloc.dart';
import 'media_permission.dart';

class TestPresenter
    extends Presenter<UserDataBloc, UserDataViewModel, UserDataScreen> {
  TestPresenter({Key? key}) : super();

  @override
  UserDataScreen buildScreen(
      BuildContext context, UserDataBloc bloc, UserDataViewModel viewModel) {
    return UserDataScreen(viewModel: viewModel);
  }

  @override
  void onViewModelUpdate(
      BuildContext context, UserDataBloc bloc, UserDataViewModel viewModel) {
    super.onViewModelUpdate(context, bloc, viewModel);
    print("view model update");
    if (viewModel.distance > 1) {
      MediaPermission.showToast(
          "You reached your Location approx ${viewModel.distance} km.");
    }
  }

  @override
  Stream<UserDataViewModel> getViewModelStream(UserDataBloc bloc) {
    return bloc.fetchUserData.receive;
  }
}
