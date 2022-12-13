import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MediaPermission {
  final double sourceLat = 23.066600940779676;
  final double sourceLong = 72.67634292368186;

  final double destinationLat = 23.069870730503883;
  final double destinationLong = 72.67314033414975;

  final double stop1Lat = 23.0682851199053; // 190 m dairy shop
  final double stop1Long = 72.67583419401666;
  final double stop2Lat = 23.06949592299789; //350 m Cross road
  final double stop2Long = 72.6755865954304;
  final double stop3Lat = 23.06939255055921; // 550 m hospital
  final double stop3Long = 72.67366287828781;

  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      MediaPermission.showToast(
          'Location services are disabled. Please enable the services');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        MediaPermission.showToast('Location permissions are denied');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      MediaPermission.showToast(
          'Location permissions are permanently denied, we cannot request permissions.');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
