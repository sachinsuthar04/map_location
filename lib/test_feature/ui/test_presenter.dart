import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
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

    final p1 = LatLng(viewModel.latitude, viewModel.longitude);
    final step1 =
        LatLng(MediaPermission().stop1Lat, MediaPermission().stop1Long);
    final step2 =
        LatLng(MediaPermission().stop2Lat, MediaPermission().stop2Long);
    final step3 =
        LatLng(MediaPermission().stop3Lat, MediaPermission().stop3Long);
    if (isSpotWithinRange(p1, step1)) {
      MediaPermission.showToast("You reached your STOP 1");
    } else if (isSpotWithinRange(p1, step2)) {
      MediaPermission.showToast("You reached your STOP 2");
    } else if (isSpotWithinRange(p1, step3)) {
      MediaPermission.showToast("You reached your STOP 3");
    }

    if (viewModel.distance > 1) {
      MediaPermission.showToast(
          "You reached your Location approx ${viewModel.distance} km.");
    }
  }

  @override
  Stream<UserDataViewModel> getViewModelStream(UserDataBloc bloc) {
    return bloc.fetchUserData.receive;
  }

  bool isSpotWithinRange(LatLng updatedLatLng, LatLng spot) {
    num distanceStop1 =
        SphericalUtil.computeDistanceBetween(updatedLatLng, spot);
    if (distanceStop1.toInt() > 1 && distanceStop1.toInt() < 30) {
      return true;
    } else {
      return false;
    }
  }
}
