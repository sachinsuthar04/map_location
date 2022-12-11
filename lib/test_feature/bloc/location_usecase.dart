import 'dart:async';
import 'dart:math';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:testing_app/main.dart';
import 'package:testing_app/test_feature/model/user_data_view_model.dart';

import '../ui/media_permission.dart';

class LocationUseCase extends UseCase {
  late final ViewModelCallback<UserDataViewModel> _viewModelCallBack;
  String address = "";
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  Timer? timer;
  bool isFirstTime = true;
  num distance = 0;

  LocationUseCase(ViewModelCallback<UserDataViewModel> viewModelCallBack)
      : _viewModelCallBack = viewModelCallBack;

  Future<void> execute() async {
    _viewModelCallBack(_buildViewModel(
        address, 0.0, 0.0, currentLatitude, currentLongitude, distance, true));

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      print("call multi time");
      _getCurrentPosition();
    });
  }

  Future<void> _getCurrentPosition() async {
    Position? _currentPosition;
    final hasPermission = await MediaPermission.handleLocationPermission(
        globalNavigatorKey.currentContext!);

    if (!hasPermission) {
      return;
    } else {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentPosition = position;
        if (isFirstTime) {
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
          isFirstTime = false;
        }

        final p1 = LatLng(currentLatitude, currentLongitude);
        final p2 =
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        distance = SphericalUtil.computeDistanceBetween(p1, p2) / 1000.0;
        print("Distance==>>" + distance.toString());
        await placemarkFromCoordinates(position.latitude, position.longitude)
            .then((List<Placemark> placemarks) {
          Placemark place = placemarks[0];
          address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
          return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        }).catchError((e) {
          debugPrint(e);
        });

        _viewModelCallBack(_buildViewModel(
            address,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            currentLatitude,
            currentLongitude,
            distance,
            false));
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  //TODO  Temporrary we can use this method also and for real time get distance from Google map api which is Paid
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  UserDataViewModel _buildViewModel(
      String address,
      double latitude,
      double longitude,
      double currLatitude,
      double currLongitude,
      num distance1,
      bool isLoading) {
    return UserDataViewModel(
        address: address,
        latitude: latitude,
        longitude: longitude,
        currentLatitude: currLatitude,
        currentLongitude: currLongitude,
        distance: distance1,
        isLoading: isLoading);
  }
}
